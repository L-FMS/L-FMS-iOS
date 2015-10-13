//
//  LFStorage.h
//  L- FMS- iOS
//
//  Created by 虎猫儿 on 15/10/9.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <FMDB/FMDB.h>
#import "LFChatRoom.h"

#import <AVOSCloud/AVOSCloud.h>
#import <AVOSCloudIM/AVOSCloudIM.h>

@interface LFStorage : NSObject

+ (instancetype)shareInstance ;

- (void)setupWithUserId:(NSString*)userId ;

- (NSArray *)getMsgsWithConvid:(NSString*)convid maxTime:(int64_t)time limit:(NSInteger)limit ;

/**
 *  [异步]插入AVIMTypedMessage到数据库
 *
 *  @param msg 要插入的AVIMTypedMessage实例
 *
 *  @return rowId行号
 */
- (int64_t)insertMessage:(AVIMTypedMessage*)msg ;

- (BOOL)updateMessageStatus:(AVIMMessageStatus)status byMessageId:(NSString*)msgId ;

- (BOOL)updateFailedMsg:(AVIMTypedMessage*)msg byTmpId:(NSString*)tmpId ;

/**
 *  清除convid对应的Msgs，清除消息记录
 *
 *  @param convid AVIMConversation.conversationId
 */
- (void)deleteMsgsByConvid:(NSString*)convid ;

- (NSArray *)getRooms ;

- (LFChatRoom *)getRoomByConvId:(NSString *)convId ;

- (NSArray *)getConvIds ;

- (NSInteger)countUnread ;

- (void)insertRoomWithConversationId:(NSString*)convid ;

/**
 *  清除convid对应的聊天室，清除聊天室记录，解散聊天室情调用[CDStorage deleteRoomAndMsgsByConvid:]并删除云端数据。
 *
 *  @param convid AVIMConversation.conversationId
 */
- (void)deleteRoomByConvid:(NSString*)convid ;

- (void)incrementUnreadWithConversationId:(NSString*)convid ;

- (void)clearUnreadWithConvid:(NSString*)convid ;

/**
 *  删除本地聊天室所有数据。[解散聊天室]
 *
 *  @param convid AVIMConversation.conversationId
 */
- (void)deleteRoomAndMsgsByConvid:(NSString *)convid ;

@end
