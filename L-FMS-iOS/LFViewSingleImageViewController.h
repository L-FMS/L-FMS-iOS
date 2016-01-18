//
//  LFViewSingleImageViewController.h
//  L-FMS-iOS
//
//  Created by 虎猫儿 on 15/10/13.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LFViewSingleImageViewController : UIViewController

+ (void)from:(UIViewController *)handleVC zoomInImage:(UIImage *)image;

+ (void)from:(UIViewController *)handleVC zoomInUrl:(NSString *)url;

@end
