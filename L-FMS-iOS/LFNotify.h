//
//  LFNotify.h
//  L-FMS-iOS
//
//  Created by 虎猫儿 on 15/10/9.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AVIMTypedMessage ;

#define kNOTIFICATION_MESSAGE_UPDATED @"NOTIFICATION_MESSAGE_UPDATED"
#define kNOTIFICATION_CONV_UPDATED @"NOTIFICATION _CONV_UPDATED"
#define kNOTIFICATION_SESSION_UPDATED @"NOTIFICATION_SESSION_UPDATED"

@interface LFNotify : NSObject

+ (instancetype)shareInstance ;

#pragma mark - Conversation

- (void)addConvObserver:(id)target selector:(SEL)selector ;

- (void)removeConvObserver:(id)target ;

- (void)postConvNotify ;

#pragma mark - Message

- (void)addMsgObserver:(id)target selector:(SEL)selector ;

- (void)removeMsgObserver:(id)target ;

- (void)postMessageNotify:(AVIMTypedMessage *)msg ;

#pragma mark - Session

- (void)addSessionObserver:(id)target selector:(SEL)selector ;

- (void)removeSessionObserver:(id)target ;

- (void)postSessionNotify ;

@end
