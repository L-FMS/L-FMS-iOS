//
//  LFCacheService.h
//  L-FMS-iOS
//
//  Created by 虎猫儿 on 15/10/6.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <AVOSCloud/AVOSCloud.h>
#import <AVOSCloudIM/AVOSCloudIM.h>

@class LFUser;

@interface LFCacheService : NSObject

+ (instancetype)shareInstance;

#pragma mark - User 

- (void)cacheUser:(LFUser *)user;

- (LFUser *)getUserById:(NSString *)userId;

#warning 以下垃圾代码。。

+ (void)cacheUsersWithIds:(NSSet*)userIds callback:(AVBooleanResultBlock)callback;

@end
