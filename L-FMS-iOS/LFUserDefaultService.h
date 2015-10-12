//
//  LFUserDefaultService.h
//  L-FMS-iOS
//
//  Created by 虎猫儿 on 15/10/11.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <CoreLocation/CoreLocation.h>
@class LFUser ;

@interface LFUserDefaultService : NSObject

+ (void)saveUserLocation:(CLLocationCoordinate2D)coordinate forUser:(LFUser *)user ;

+ (CLLocation *)getUserLocationForUser:(LFUser *)user ;

+ (void)setChatRoomBackgroundSwitch:(BOOL)show ;

+ (BOOL)getChatRoomBackgroundSwitch ;

@end
