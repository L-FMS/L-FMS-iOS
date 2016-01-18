//
//  AVIMConversation+LFApp.h
//  L-FMS-iOS
//
//  Created by 虎猫儿 on 15/10/9.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import "AVIMConversation.h"

@interface AVIMConversation (LFApp)

/**
 *  一对一聊天室另一个人的clientId
 *
 *  @return 另一个人的clientId(userId)
 */
- (NSString *)otherId;

/**
 *  要显示什么title
 *  单人：显示另一个人的名字
 *  多人：群聊名字 or @"群聊"
 *
 *  @return
 */
- (NSString *)displayName;

/**
 *  聊天室标题 @"用户名"
 */
- (NSString *)title;

@end
