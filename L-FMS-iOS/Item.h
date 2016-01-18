//
//  Item.h
//  L-FMS-iOS
//
//  Created by 虎猫儿 on 15/10/6.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import "AVObject.h"
#import <AVObject+Subclass.h>
#import <AVSubclassing.h>

@class LFUser;
@class AVGeoPoint;

@interface Item : AVObject<AVSubclassing>

@property (nonatomic,copy) NSString *itemDescription;
@property (nonatomic,copy) NSArray *tags;
@property (nonatomic,copy) NSString *place;
@property (nonatomic) AVGeoPoint *location;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *type;
@property (nonatomic) AVFile *image;
@property (nonatomic) LFUser *user;

- (BOOL)isLost;

@end
