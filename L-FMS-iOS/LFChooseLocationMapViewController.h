//
//  LFChooseLocationMapViewController.h
//  L-FMS-iOS
//
//  Created by 虎猫儿 on 15/10/10.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CLLocation ;
@protocol LFChooseLocationMapViewControllerDelegate ;

@interface LFChooseLocationMapViewController : UIViewController

@property (weak) id<LFChooseLocationMapViewControllerDelegate> delegate ;

@end

@protocol LFChooseLocationMapViewControllerDelegate <NSObject>

- (void)viewController:(LFChooseLocationMapViewController *)vc didClickedLocation:(CLLocation *)location ;

@end
