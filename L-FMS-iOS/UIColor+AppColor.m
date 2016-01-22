//
//  UIColor+AppColor.m
//  L-FMS-iOS
//
//  Created by 虎猫儿 on 16/1/18.
//  Copyright © 2016年 虎猫儿. All rights reserved.
//

#import "UIColor+AppColor.h"

@implementation UIColor (AppColor)

+ (UIColor *)lf_colorWithHex:(NSInteger)hex {
    return [self lf_colorWithHex:hex alpha:1];
}

+ (UIColor *)lf_colorWithHex:(NSInteger)hex alpha:(CGFloat)alpha {
    NSInteger blue = hex & 0xFF;
    NSInteger green = (hex & 0xFF00) >> 8;
    NSInteger red = (hex & 0xFF0000) >> 16;
    return [UIColor colorWithRed:red / 255.0 green:green / 255.0 blue:blue / 255.0 alpha:alpha];
}

@end
