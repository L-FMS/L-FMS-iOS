//
//  LFUser.m
//  L-FMS-iOS
//
//  Created by 虎猫儿 on 15/10/6.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import "LFUser.h"
#import "AppDelegate.h"

#import <UIKit/UIKit.h>
#import <AVOSCloud/AVOSCloud.h>
#import "LFIMClient.h"
#import "LFCommon.h"

#import <SDWebImage/UIImageView+WebCache.h>

@interface LFUser ()

@end

@implementation LFUser

@dynamic address ;
@dynamic major ;
@dynamic name ;
@dynamic gender ;
@dynamic birth ;
@dynamic avatar ;

+ (NSString *)parseClassName {
    return @"_User" ;
}

+ (void)logOut {
    LFUser *user = [LFUser currentUser] ;
    if ( user.imClient ) {
        [user.imClient closeSessionCompletion:^(BOOL succeeded, NSError *error) {
            if ( error ) {
                QYDebugLog(@"Close Session Error:[%@]",error) ;
            }
            user.imClient = nil ;
        }] ;
    }
    user = nil ;
    [super logOut] ;
    [AppDelegate globalAppdelegate].drawerViewController = nil ;
}

#pragma mark - 

- (void)displayAvatarAtImageView:(UIImageView *)avatarImageView {
    [avatarImageView sd_setImageWithURL:[NSURL URLWithString:self.avatar.url]
                       placeholderImage:[UIImage imageNamed:@"testAvatar1"]] ;
}

- (NSString *)displayName {
    return self.name ? : self.username ? : @"" ;
}

#pragma mark - getter && setter 

@end
