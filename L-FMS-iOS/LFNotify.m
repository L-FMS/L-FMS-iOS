//
//  LFNotify.m
//  L-FMS-iOS
//
//  Created by 虎猫儿 on 15/10/9.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import "LFNotify.h"

@interface LFNotify ()

@property (weak) NSNotificationCenter* center;

@end

@implementation LFNotify

+ (instancetype)shareInstance {
    static LFNotify *sharedInstace = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstace = [[LFNotify alloc] init];
    });
    return sharedInstace;
}

- (instancetype)init {
    if (self = [super init]) {
        _center = [NSNotificationCenter defaultCenter];
    }
    return self;
}

#pragma mark - Conversation

- (void)addConvObserver:(id)target selector:(SEL)selector {
    [_center addObserver:target selector:selector name:kNOTIFICATION_CONV_UPDATED object:nil];
}

- (void)removeConvObserver:(id)target {
    [_center removeObserver:target name:kNOTIFICATION_CONV_UPDATED object:nil];
}

- (void)postConvNotify {
    [_center postNotificationName:kNOTIFICATION_CONV_UPDATED object:nil];
}

#pragma mark - Message

- (void)addMsgObserver:(id)target selector:(SEL)selector {
    [_center addObserver:target selector:selector name:kNOTIFICATION_MESSAGE_UPDATED object:nil];
}

- (void)removeMsgObserver:(id)target {
    [_center removeObserver:target name:kNOTIFICATION_MESSAGE_UPDATED object:nil];
}

- (void)postMessageNotify:(AVIMTypedMessage*)msg {
    [_center postNotificationName:kNOTIFICATION_MESSAGE_UPDATED object:msg];
}

#pragma mark - Session

- (void)addSessionObserver:(id)target selector:(SEL)selector {
    [_center addObserver:target selector:selector name:kNOTIFICATION_SESSION_UPDATED object:nil];
}

- (void)removeSessionObserver:(id)target {
    [_center removeObserver:target name:kNOTIFICATION_SESSION_UPDATED object:nil];
}

- (void)postSessionNotify {
    [_center postNotificationName:kNOTIFICATION_SESSION_UPDATED object:nil];
}


@end
