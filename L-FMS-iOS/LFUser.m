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

#import <SDWebImage/UIImageView+WebCache.h>

@implementation LFUser

@dynamic address ;
@dynamic major ;
@dynamic name ;
@dynamic gender ;
@dynamic birth ;

+ (NSString *)parseClassName {
    return @"_User" ;
}

+ (void)logOut {
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

@end
