//
//  LFSingleItemAnnotation.m
//  L-FMS-iOS
//
//  Created by 虎猫儿 on 15/10/13.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import "LFSingleItemAnnotation.h"
#import "LFCommon.h"

@interface LFSingleItemAnnotation ()

@property (nonatomic, readwrite) CLLocationCoordinate2D coordinate;

@end

@implementation LFSingleItemAnnotation

- (instancetype)initWithItem:(Item *)item location:(CLLocation *)location {
    if (self = [super init]) {
        self.item = item;
        self.coordinate = location.coordinate;
    }
    return self;
}

/**
 *获取annotation标题
 *@return 返回annotation的标题信息
 */
- (NSString *)title {
    return self.item.name;
}

/**
 *获取annotation副标题
 *@return 返回annotation的副标题信息
 */
- (NSString *)subtitle {
    return self.item.itemDescription;    
}

@end
