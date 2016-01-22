//
//  UIColor+AppColor.h
//  L-FMS-iOS
//
//  Created by 虎猫儿 on 16/1/18.
//  Copyright © 2016年 虎猫儿. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (AppColor)

/**
 *  根据 hex 返回对应的颜色 ff0000 返回红色 默认 alpha 为 255
 *
 *  @param 16进制颜色
 */
+ (UIColor *)qy_colorWithHex:(NSInteger)hex;


/**
 *  根据 hex 返回对应的颜色 ff0000 返回红色
 *
 *  @param 16进制颜色
 *  @param 0~1 的透明度
 */
+ (UIColor *)qy_colorWithHex:(NSInteger)hex alpha:(CGFloat)alpha;

@end

NS_ASSUME_NONNULL_END