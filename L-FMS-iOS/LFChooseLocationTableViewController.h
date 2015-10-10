//
//  LFChooseLocationTableViewController.h
//  L-FMS-iOS
//
//  Created by 虎猫儿 on 15/10/10.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BMKSuggestionResult ;
@class CLLocation ;

@protocol LFChooseLocationTableViewControllerDelegate ;

@interface LFChooseLocationTableViewController : UITableViewController

@property (weak) id<LFChooseLocationTableViewControllerDelegate> delegate ;

@property (nonatomic,strong) BMKSuggestionResult *searchResult ;

@end

@protocol LFChooseLocationTableViewControllerDelegate <NSObject>

- (void)viewController:(LFChooseLocationTableViewController *)vc didChooseLocation:(CLLocation *)location ;

@end
