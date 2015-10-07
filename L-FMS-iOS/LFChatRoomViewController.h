//
//  LFChatRoomViewController.h
//  L-FMS-iOS
//
//  Created by 虎猫儿 on 15/10/7.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import "XHMessageTableViewController.h"

@class AVIMConversation ;

@interface LFChatRoomViewController : XHMessageTableViewController

- (instancetype)initWithConersation:(AVIMConversation *)conv ;

@end
