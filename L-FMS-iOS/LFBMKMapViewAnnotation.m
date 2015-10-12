//
//  LFBMKMapViewAnnotation.m
//  L-FMS-iOS
//
//  Created by 虎猫儿 on 15/10/11.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import "LFBMKMapViewAnnotation.h"
#import <UIKit/UIKit.h>
#import "LFCommon.h"

@interface LFBMKMapViewAnnotation ()

@property (nonatomic, readwrite) CLLocationCoordinate2D coordinate ;

@end

@implementation LFBMKMapViewAnnotation

- (instancetype)initWithCLCorrdinate:(CLLocationCoordinate2D)coordinate {
    if ( self = [super init] ) {
        self.coordinate = coordinate ;
    }
    return self ;
}

/**
 *获取annotation标题
 *@return 返回annotation的标题信息
 */
- (NSString *)title {
    return self.item.name ;
}

/**
 *获取annotation副标题
 *@return 返回annotation的副标题信息
 */
- (NSString *)subtitle {
    return self.item.itemDescription ;
}

- (UIImage *)annotationImage {
    if ( !self.item ) return nil ;
    return self.item.isLost ? [UIImage imageNamed:@"LostAnnotation"] :
                              [UIImage imageNamed:@"FoundAnnotation"] ;
}

@end
