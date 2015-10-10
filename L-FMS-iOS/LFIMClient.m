//
//  LFClient.m
//  L-FMS-iOS
//
//  Created by 虎猫儿 on 15/10/9.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import "LFIMClient.h"
#import <AVOSCloudIM/AVOSCloudIM.h> 
#import "LFCommon.h"
#import "LFStorage.h"
#import "LFNotify.h"

@interface LFIMClient ()<AVIMClientDelegate>

@property (nonatomic,strong) AVIMClient *aAVIMClient ;

@property (nonatomic,copy) NSString *clientId ;

@property (weak) LFStorage *storage ;

@property (weak) LFNotify *notify ;

@end

@implementation LFIMClient

#pragma mark - init 

- (instancetype)init {
    if ( self = [super init] ) {
        [self setUp] ;
    }
    return self ;
}

- (void)setUp {
    self.aAVIMClient = [[AVIMClient alloc] init] ;
    self.aAVIMClient.delegate = self ;
    self.storage = [LFStorage shareInstance] ;
    self.notify = [LFNotify shareInstance] ;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    QYDebugLog(@"...") ;
}

#pragma mark - session

- (void)openSessionWithClientID:(NSString *)clientID
                     completion:(void (^)(BOOL succeeded, NSError *error))completion {
    self.clientId = clientID ;
    [self.storage setupWithUserId:clientID] ;
    if ( self.aAVIMClient.status == AVIMClientStatusNone ) {
        [self.aAVIMClient openWithClientId:clientID callback:completion] ;
    } else {
        [self.aAVIMClient closeWithCallback:^(BOOL succeeded, NSError *error) {
            if ( succeeded ) {
                [self.aAVIMClient openWithClientId:clientID callback:completion] ;
            } else {
                completion(false,error) ;
            }
        }] ;
    }
}

//关闭AVIMCLient
- (void)closeSessionCompletion:(void (^)(BOOL succeeded, NSError *error))completion ; {
    [self.aAVIMClient closeWithCallback:^(BOOL succeeded, NSError *error) {
        if ( succeeded ) {
            self.aAVIMClient.delegate = nil ;
            self.aAVIMClient = nil ;
            self.clientId = nil ;
        }
        completion(succeeded,error) ;
    }] ;
}

- (void)startConversationWithUserId:(NSString *)targetUserId completion:(void (^)(AVIMConversation *conversation, NSError *error))completion {
    assert(targetUserId) ;
    AVIMConversationQuery *query = [self.aAVIMClient conversationQuery] ;
    NSArray *cliendIds = @[self.clientId,targetUserId] ;
    
    [query whereKey:kAVIMKeyMember containsAllObjectsInArray:cliendIds] ;
    [query findConversationsWithCallback:^(NSArray *objects, NSError *error) {
        if ( error ) {
            QYDebugLog(@"查询会话失败 Error:[%@]",error) ;
            completion(nil,error) ;
        } else {
            
            if ( !objects || objects.count < 1 ) {
                //没有去创建一个
                [self.aAVIMClient createConversationWithName:nil clientIds:cliendIds callback:^(AVIMConversation *conversation, NSError *error) {
                    if ( error ) {
                        //创建失败
                        QYDebugLog(@"创建会话失败 Error:[%@]",error) ;
                        completion(nil,error) ;
                    } else {
                        //创建成功
                        completion(conversation,nil) ;
                    }
                }] ;
            } else {
                //有去获取一个
                AVIMConversation *conv = [objects lastObject] ;
                completion(conv,nil) ;
            }            
        }
    }] ;
    
    
}

#pragma mark - AVIMClientDelegate

/*!
 当前聊天状态被暂停，常见于网络断开时触发，error 包含暂停的错误信息。
 注意：该回调会覆盖 imClientPaused: 方法。
 */
- (void)imClientPaused:(AVIMClient *)imClient error:(NSError *)error {
    QYDebugLog(@"断网") ;
    [_notify postSessionNotify] ;
}

/*!
 当前聊天状态开始恢复，常见于网络断开后开始重新连接。
 */
- (void)imClientResuming:(AVIMClient *)imClient {
    QYDebugLog(@"正在重连") ;
    [_notify postSessionNotify] ;
}

/*!
 当前聊天状态已经恢复，常见于网络断开后重新连接上。
 */
- (void)imClientResumed:(AVIMClient *)imClient {
    QYDebugLog(@"网络恢复") ;
    [_notify postSessionNotify] ;
}

/*!
 接收到新的普通消息。
 @param conversation － 所属对话
 @param message - 具体的消息
 @return None.
 */
- (void)conversation:(AVIMConversation *)conversation didReceiveCommonMessage:(AVIMMessage *)message {
    QYDebugLog(@"接收到新的普通消息。") ;
}

/*!
 接收到新的富媒体消息。
 @param conversation － 所属对话
 @param message - 具体的消息
 @return None.
 */
- (void)conversation:(AVIMConversation *)conversation didReceiveTypedMessage:(AVIMTypedMessage *)message {
    QYDebugLog(@"接收到新的富媒体消息。") ;
    if(message.messageId){
        [self didReceiveMessage:message fromConversation:conversation];
    }else{
        QYDebugLog(@"Received message , but messageId is nil") ;
    }
}

/*!
 消息已投递给对方。
 @param conversation － 所属对话
 @param message - 具体的消息
 @return None.
 */
- (void)conversation:(AVIMConversation *)conversation messageDelivered:(AVIMMessage *)message {
    QYDebugLog(@"消息已经投递给对方")
    if ( message && [message isKindOfClass:[AVIMTypedMessage class]]) {
        [_storage updateMessageStatus:AVIMMessageStatusDelivered byMessageId:message.messageId] ;
        [_notify postMessageNotify:(id)message] ;
    }
}

/*
 收到未读通知。
 @param conversation 所属会话。
 @param unread 未读消息数量。
 */
- (void)conversation:(AVIMConversation *)conversation didReceiveUnread:(NSInteger)unread {
    QYDebugLog(@"收到未读通知 %ld",(long)unread) ;
}

#pragma mark - Helper 

- (void)didReceiveMessage:(AVIMTypedMessage*)msg fromConversation:(AVIMConversation*)conv{
    if ( ![msg isKindOfClass:[AVIMTypedMessage class]]) {
        return ;
    }
    [_storage insertRoomWithConversationId:conv.conversationId] ;
    [_storage insertMessage:msg] ;
    [_storage incrementUnreadWithConversationId:conv.conversationId] ;
    //通知viewController
    
    [_notify postMessageNotify:msg] ;
}

- (BOOL)isOpened {
    return _aAVIMClient.status == AVIMClientStatusOpened ;
}

/**
 *  查找后台会话,1000条上限
 *
 *  @param block
 */
- (void)findConvsWithBlock:(AVIMArrayResultBlock)block {
    AVIMConversationQuery *q = [self.aAVIMClient conversationQuery] ;
    [q whereKey:@"m" containedIn:@[self.clientId]] ;
    q.limit = 1000 ;
    [q findConversationsWithCallback:block] ;
}

@end ;
