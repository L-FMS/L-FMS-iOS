//
//  LFComment.h
//  L-FMS-iOS
//
//  Created by 虎猫儿 on 15/10/9.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import "AVObject.h"
#import <AVObject+Subclass.h>
#import <AVSubclassing.h>

@class Item ;
@class LFUser ;

@interface LFComment : AVObject<AVSubclassing>

@property (nonatomic,copy) NSString *content ;
@property (nonatomic) Item *item ;
@property (nonatomic) LFUser *author ;
@property (nonatomic) LFUser *replyTo ;
@property (nonatomic) NSArray *replyToUsers ;

@end

@interface LFComment (LFCommentNoticeTableViewController)

@property (nonatomic,copy) NSNumber *cellHeight ;

@end
