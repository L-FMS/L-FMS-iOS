//
//  AVIMConversation+LFApp.m
//  L-FMS-iOS
//
//  Created by 虎猫儿 on 15/10/9.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import "AVIMConversation+LFApp.h"

#import "LFCommon.h"
#import "LFCacheService.h"

@implementation AVIMConversation (LFApp)

- (NSString *)otherId {
    NSArray *members = self.members ;
    
    if( [members[0] isEqualToString:[LFUser currentUser].objectId] )
        return members[1] ;
    else
        return members[0] ;
}

- (NSString *)displayName {
    if ( self.otherId == nil ) return @"无数据" ;
    LFUser *user = [[LFCacheService shareInstance] getUserById:self.otherId] ;
    return user.displayName ;
}

- (NSString *)title {
    return self.displayName ;
}


@end
