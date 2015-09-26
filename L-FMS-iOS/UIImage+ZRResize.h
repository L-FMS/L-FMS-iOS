//
//  UIImage+ZRResize.h
//  L-FMS-iOS
//
//  Created by 虎猫儿 on 15/9/26.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ZRResize)

/**
 *  改变图像的尺寸，方便上传服务器
 *
 *  @param image
 *  @param size
 *
 *  @return
 */
+ (UIImage *)zrScaleFromImage:(UIImage *)image toSize:(CGSize)size ;

/**
 *  保持原来的长宽比，生成一个缩略图
 *
 *  @param image
 *  @param asize
 *
 *  @return
 */
+ (UIImage *)zrThumbnailWithImageWithoutScale:(UIImage *)image size:(CGSize)asize ;

@end
