//
//  Item.m
//  L-FMS-iOS
//
//  Created by 虎猫儿 on 15/10/6.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import "Item.h"

#import <AVOSCloud/AVOSCloud.h>

@implementation Item

@dynamic itemDescription;
@dynamic tags;
@dynamic place;
@dynamic location;
@dynamic name;
@dynamic type;
@dynamic image;
@dynamic user;

+ (NSString *)parseClassName {
    return NSStringFromClass(self);
}

- (BOOL)isLost {
    return [self.type isEqualToString:@"lost"];
}

@end
