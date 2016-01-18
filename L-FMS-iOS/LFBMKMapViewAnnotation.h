//
//  LFBMKMapViewAnnotation.h
//  L-FMS-iOS
//
//  Created by 虎猫儿 on 15/10/11.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "LFBaiduMapKit.h"

@class Item;
@class UIImage;

@interface LFBMKMapViewAnnotation : NSObject<BMKAnnotation>

///标注view中心坐标.
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

- (instancetype)initWithCLCorrdinate:(CLLocationCoordinate2D)coordinate;

@property (nonatomic,strong) Item *item;

- (UIImage *)annotationImage;

@end
