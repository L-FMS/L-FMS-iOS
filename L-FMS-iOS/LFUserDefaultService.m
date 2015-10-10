//
//  LFUserDefaultService.m
//  L-FMS-iOS
//
//  Created by 虎猫儿 on 15/10/11.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import "LFUserDefaultService.h"

#import "LFCommon.h"

@implementation LFUserDefaultService

+ (void)saveUserLocation:(CLLocationCoordinate2D)coordinate forUser:(LFUser *)user {
    assert(user) ;
    NSNumber *lat = [NSNumber numberWithDouble:coordinate.latitude] ;
    NSNumber *lon = [NSNumber numberWithDouble:coordinate.longitude] ;
    NSDictionary *userLocationDic = @{@"lat":lat,
                                      @"lon":lon} ;
    [[NSUserDefaults standardUserDefaults] setObject:userLocationDic
                                              forKey:@"userLocation"] ;
    [[NSUserDefaults standardUserDefaults] synchronize] ;
}

+ (CLLocation *)getUserLocationForUser:(LFUser *)user {
    CLLocation *location ;
    
    NSDictionary *userLocationDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"userLocation"] ;
    if ( !userLocationDic ) return nil ;
    
    NSNumber *lat = userLocationDic[@"lat"] ;
    NSNumber *lon = userLocationDic[@"lon"] ;
    location = [[CLLocation alloc] initWithLatitude:[lat doubleValue] longitude:[lon doubleValue]] ;
    
    return location ;
}

@end
