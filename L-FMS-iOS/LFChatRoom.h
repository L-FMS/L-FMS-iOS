//
//  LFChatRoom.h
//  L-FMS-iOS
//
//  Created by 虎猫儿 on 15/10/9.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AVIMConversation ;
@class AVIMTypedMessage ;

@interface LFChatRoom : NSObject

/**
 *  会话Id
 */
@property NSString* convid ;

/**
 *  会话实例
 */
@property AVIMConversation* conv ;

/**
 *  最后一条消息
 */
@property AVIMTypedMessage* lastMsg ;

/**
 *  未读消息条数
 */
@property NSInteger unreadCount ;

@end
