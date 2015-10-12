//
//  LFSingleItemAnnotation.h
//  L-FMS-iOS
//
//  Created by 虎猫儿 on 15/10/13.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "LFBaiduMapKit.h"
@class Item ;

@interface LFSingleItemAnnotation : NSObject<BMKAnnotation>

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate ;

@property (nonatomic, retain) Item *item ;

- (instancetype)initWithItem:(Item *)item location:(CLLocation *)location ;

@end
