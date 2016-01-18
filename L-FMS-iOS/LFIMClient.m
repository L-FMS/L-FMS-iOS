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
#import "LFCacheService.h"

@interface LFIMClient ()<AVIMClientDelegate>

@property (nonatomic,strong) AVIMClient *aAVIMClient;

@property (nonatomic,copy) NSString *clientId;//userId

@property (weak) LFStorage *storage;

@property (weak) LFNotify *notify;








/**
 *  {[key]AVIMConversation.conversationId : [value]AVIMConversation}
 */
@property (nonatomic,strong) NSMutableDictionary* cachedConvs;//

@end

@implementation LFIMClient

#pragma mark - init 

- (instancetype)init {
    if (self = [super init]) {
        [self setUp];
    }
    return self;
}

- (void)setUp {
    self.aAVIMClient = [[AVIMClient alloc] init];
    self.aAVIMClient.delegate = self;
    self.storage = [LFStorage shareInstance];
    self.notify = [LFNotify shareInstance];
}

#pragma mark - session

- (void)openSessionWithClientID:(NSString *)clientID
                     completion:(void (^)(BOOL succeeded, NSError *error))completion {
    self.clientId = clientID;
    [self.storage setupWithUserId:clientID];
    if (self.aAVIMClient.status == AVIMClientStatusNone) {
        [self.aAVIMClient openWithClientId:clientID callback:completion];
    } else {
        [self.aAVIMClient closeWithCallback:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                [self.aAVIMClient openWithClientId:clientID callback:completion];
            } else {
                completion(false,error);
            }
        }];
    }
}

//关闭AVIMCLient
- (void)closeSessionCompletion:(void (^)(BOOL succeeded, NSError *error))completion; {
    [self.aAVIMClient closeWithCallback:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            self.aAVIMClient.delegate = nil;
            self.aAVIMClient = nil;
            self.clientId = nil;
        }
        completion(succeeded,error);
    }];
}

- (void)startConversationWithUserId:(NSString *)targetUserId completion:(void (^)(AVIMConversation *conversation, NSError *error))completion {
    assert(targetUserId);
    AVIMConversationQuery *query = [self.aAVIMClient conversationQuery];
    NSArray *cliendIds = @[self.clientId,targetUserId];
    
    [query whereKey:kAVIMKeyMember containsAllObjectsInArray:cliendIds];
    [query findConversationsWithCallback:^(NSArray *objects, NSError *error) {
        if (error) {
            QYDebugLog(@"查询会话失败 Error:[%@]",error);
            completion(nil,error);
        } else {
            
            if (!objects || objects.count < 1) {
                //没有去创建一个
                [self.aAVIMClient createConversationWithName:nil clientIds:cliendIds callback:^(AVIMConversation *conversation, NSError *error) {
                    if (error) {
                        //创建失败
                        QYDebugLog(@"创建会话失败 Error:[%@]",error);
                        completion(nil,error);
                    } else {
                        //创建成功
                        completion(conversation,nil);
                    }
                }];
            } else {
                //有去获取一个
                AVIMConversation *conv = [objects lastObject];
                completion(conv,nil);
            }            
        }
    }];
    
    
}

#pragma mark - AVIMClientDelegate

/*!
 当前聊天状态被暂停，常见于网络断开时触发，error 包含暂停的错误信息。
 注意：该回调会覆盖 imClientPaused: 方法。
 */
- (void)imClientPaused:(AVIMClient *)imClient error:(NSError *)error {
    QYDebugLog(@"断网");
    [_notify postSessionNotify];
}

/*!
 当前聊天状态开始恢复，常见于网络断开后开始重新连接。
 */
- (void)imClientResuming:(AVIMClient *)imClient {
    QYDebugLog(@"正在重连");
    [_notify postSessionNotify];
}

/*!
 当前聊天状态已经恢复，常见于网络断开后重新连接上。
 */
- (void)imClientResumed:(AVIMClient *)imClient {
    QYDebugLog(@"网络恢复");
    [_notify postSessionNotify];
}

/*!
 接收到新的普通消息。
 @param conversation － 所属对话
 @param message - 具体的消息
 @return None.
 */
- (void)conversation:(AVIMConversation *)conversation didReceiveCommonMessage:(AVIMMessage *)message {
    QYDebugLog(@"接收到新的普通消息。");
}

/*!
 接收到新的富媒体消息。
 @param conversation － 所属对话
 @param message - 具体的消息
 @return None.
 */
- (void)conversation:(AVIMConversation *)conversation didReceiveTypedMessage:(AVIMTypedMessage *)message {
    QYDebugLog(@"接收到新的富媒体消息。");
    if(message.messageId) {
        [self didReceiveMessage:message fromConversation:conversation];
    } else {
        QYDebugLog(@"Received message , but messageId is nil");
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
    if (message && [message isKindOfClass:[AVIMTypedMessage class]]) {
        [_storage updateMessageStatus:AVIMMessageStatusDelivered byMessageId:message.messageId];
        [_notify postMessageNotify:(id)message];
    }
}

/*
 收到未读通知。
 @param conversation 所属会话。
 @param unread 未读消息数量。
 */
- (void)conversation:(AVIMConversation *)conversation didReceiveUnread:(NSInteger)unread {
    QYDebugLog(@"收到未读通知 %ld",(long)unread);
}

#pragma mark - Helper 

- (void)didReceiveMessage:(AVIMTypedMessage*)msg fromConversation:(AVIMConversation*)conv{
    if (![msg isKindOfClass:[AVIMTypedMessage class]]) {
        return;
    }
    [_storage insertRoomWithConversationId:conv.conversationId];
    [_storage insertMessage:msg];
    [_storage incrementUnreadWithConversationId:conv.conversationId];
    //通知viewController
    
    [_notify postMessageNotify:msg];
}

- (BOOL)isOpened {
    return _aAVIMClient.status == AVIMClientStatusOpened;
}

/**
 *  查找后台会话,1000条上限
 *
 *  @param block
 */
- (void)findConvsWithBlock:(AVIMArrayResultBlock)block {
    AVIMConversationQuery *q = [self.aAVIMClient conversationQuery];
    [q whereKey:@"m" containedIn:@[self.clientId]];
    q.limit = 1000;
    [q findConversationsWithCallback:block];
}





#warning 以下是垃圾代码。。无参考价值

- (void)encodeWithCoder:(NSCoder *)aCoder {
    QYDebugLog(@"...");
}

#pragma mark - conv cache

/**
 *  缓存room数组，并从服务器获取未缓存的room data。
 *
 *  @param rooms    Array<CDRoom>
 *  @param callback (BOOL succeeded, NSError *error)
 */
-(void)cacheAndFillRooms:(NSMutableArray*)rooms callback:(AVBooleanResultBlock)callback {
    NSMutableSet *convids = [NSMutableSet set];
    
    for(LFChatRoom *room in rooms)
        [convids addObject:room.convid];
    
    
    [self cacheConvsWithIds:convids callback:^(NSArray *conversations, NSError *error) {
        if(error) {
            callback(NO,error);
        } else {
            for(LFChatRoom *room in rooms) {
                
                room.conv = [self lookupConvById:room.convid];
                if (nil == room.conv) {
                    [NSException raise:@"not found conv" format:nil];
                }
            }
            NSMutableSet *userIds = [NSMutableSet set];
            for(LFChatRoom *room in rooms) {
                [userIds addObject:room.conv.otherId];
            }
            [LFCacheService cacheUsersWithIds:userIds callback:callback];
        }
    }];
}

- (void)cacheConvsWithIds:(NSMutableSet*)convids callback:(AVArrayResultBlock)callback {
    
    NSMutableSet *uncacheConvids = [NSMutableSet set];
    //找出未缓存的部分。
    for(NSString *convid in convids){
        if(nil == [self lookupConvById:convid]){
            [uncacheConvids addObject:convid];
        }
    }
    //拉取未缓存的会话
    [self fetchConvsWithConvids:uncacheConvids callback:^(NSArray *conversations, NSError *error) {
        if(error){
            callback(nil,error);
        } else {
            //缓存拉取的会话
            [self registerConvs:conversations];
            callback(conversations,error);
        }
    }];
}

- (AVIMConversation *)lookupConvById:(NSString*)convid {
    return [self.cachedConvs valueForKey:convid];
}

//缓存会话数组
- (void)registerConvs:(NSArray*)convs {
    for(AVIMConversation *conv in convs){
        [self.cachedConvs setValue:conv forKey:conv.conversationId];
    }
}

/**
 *  使用AVIMConversationQuery拉取convids里的所有AVIMConversation对象
 *
 *  @param convids  AVIMConversation.objectId
 *  @param callback (NSArray *objects, NSError *error)
 */
- (void)fetchConvsWithConvids:(NSSet*)convids callback:(AVIMArrayResultBlock)callback {
    
    if(convids.count > 0) {
        AVIMConversationQuery *q = [self.aAVIMClient conversationQuery];
        [q whereKey:@"objectId" containedIn:[convids allObjects]];
        q.limit = 1000;  // default limit:10
        [q findConversationsWithCallback:callback];
    } else {
        callback([NSMutableArray array],nil);
    }
}

#pragma mark - getter & setter

- (NSMutableDictionary *)cachedConvs {
    if (_cachedConvs == nil) _cachedConvs = [NSMutableDictionary new];
    return _cachedConvs;
}

#pragma mark - query msgs

- (NSArray *)queryMsgsWithConv:(AVIMConversation*)conv msgId:(NSString*)msgId maxTime:(int64_t)time limit:(NSUInteger)limit error:(NSError**)theError {
    dispatch_semaphore_t sema=dispatch_semaphore_create(0);
    __block NSArray* result;
    __block NSError* blockError=nil;
    
    
    [conv queryMessagesBeforeId:msgId timestamp:time limit:limit callback:^(NSArray *objects, NSError *error) {
        result=objects;
        blockError=error;
        dispatch_semaphore_signal(sema);
    }];
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    
    *theError=blockError;
    if(blockError == nil){
    }
    return result;
}

- (NSString *)uuid {
    NSString *chars = @"abcdefghijklmnopgrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    assert(chars.length == 62);
    int len = (int)chars.length;
    NSMutableString *result = [NSMutableString string];
    for(int i = 0; i <24; i++) {
        int p = arc4random_uniform(len);
        NSRange range = NSMakeRange(p, 1);
        [result appendString:[chars substringWithRange:range]];
    }
    return result;
}

@end;
