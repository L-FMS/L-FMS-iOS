//
//  LFUserAnnotation.h
//  L-FMS-iOS
//
//  Created by 虎猫儿 on 15/10/10.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "LFBaiduMapKit.h"

@interface LFUserAnnotation : NSObject<BMKAnnotation>

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

- (instancetype)initWithCLCorrdinate:(CLLocationCoordinate2D)coordinate;

@end
