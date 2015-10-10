//
//  LFClient.h
//  L-FMS-iOS
//
//  Created by 虎猫儿 on 15/10/9.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//
//  1.描述登陆后的端，包含CurrentUser 和 AVIMClient对象

#import <Foundation/Foundation.h>

#import <AVOSCloud/AVOSCloud.h>
#import <AVOSCloudIM/AVOSCloudIM.h>

@interface LFIMClient : NSObject

#pragma mark - session

/**
 *  打开AVIMClient，创建长连结
 *
 *  @param clientID   操作发起人的 id，以后使用该账户的所有聊天行为，都由此人发起。
 *  @param completion 回调
 */
- (void)openSessionWithClientID:(NSString *)clientID
                     completion:(void (^)(BOOL succeeded, NSError *error))completion ;

- (void)closeSessionCompletion:(void (^)(BOOL succeeded, NSError *error))completion ;

- (void)startConversationWithUserId:(NSString *)targetUserId completion:(void (^)(AVIMConversation *conversation, NSError *error))completion ;

- (BOOL)isOpened ;

/**
 *  查找后台会话,1000条上限
 *
 *  @param block
 */
- (void)findConvsWithBlock:(AVIMArrayResultBlock)block ;

#warning AVOSCloud的SDK的bug。user save的时候会调用这个。。不是dynamic也会调用。之后提issue。
- (void)encodeWithCoder:(NSCoder *)aCoder ;

@end
