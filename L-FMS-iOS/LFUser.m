//
//  LFUser.m
//  L-FMS-iOS
//
//  Created by 虎猫儿 on 15/10/6.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import "LFUser.h"
#import "AppDelegate.h"

@implementation LFUser

+ (NSString *)parseClassName {
    return @"_User" ;
}

+ (void)logOut {
    [super logOut] ;
    [AppDelegate globalAppdelegate].drawerViewController = nil ;
}

@end
