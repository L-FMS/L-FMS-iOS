//
//  LFAVSubclassRegister.m
//  L-FMS-iOS
//
//  Created by 虎猫儿 on 15/10/6.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import "LFAVSubclassRegister.h"

#import "LFAVOSCloudModels.h"

@implementation LFAVSubclassRegister

+ (void)registeAllAVSubclasses {
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        [Item registerSubclass] ;
        [LFUser registerSubclass] ;
        [LFComment registerSubclass] ;
    }) ;
}

@end
