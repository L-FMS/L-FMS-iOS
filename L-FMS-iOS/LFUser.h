//
//  LFUser.h
//  L-FMS-iOS
//
//  Created by 虎猫儿 on 15/10/6.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import "AVUser.h"
#import <AVObject+Subclass.h>
#import <AVSubclassing.h>

@class UIImageView ;

@interface LFUser : AVUser<AVSubclassing>

@property (nonatomic,copy) NSString *address ;
@property (nonatomic,copy) NSString *major ;
@property (nonatomic,copy) NSString *name ;//真名
@property (nonatomic,copy) NSString *gender ;
@property (nonatomic,copy) NSDate *birth ;
@property (nonatomic) AVFile *avatar ;

- (void)displayAvatarAtImageView:(UIImageView *)avatarImageView ;

- (NSString *)displayName ;

@end
