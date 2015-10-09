//
//  LFUserAnnotation.m
//  L-FMS-iOS
//
//  Created by 虎猫儿 on 15/10/10.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import "LFUserAnnotation.h"

@interface LFUserAnnotation ()

@property (nonatomic, readwrite) CLLocationCoordinate2D coordinate ;

@end

@implementation LFUserAnnotation

- (instancetype)initWithCLCorrdinate:(CLLocationCoordinate2D)coordinate {
    if ( self = [super init] ) {
        self.coordinate = coordinate ;
    }
    return self ;
}

@end
