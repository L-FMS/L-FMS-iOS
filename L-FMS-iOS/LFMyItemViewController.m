//
//  LFMyItemViewController.m
//  L-FMS-iOS
//
//  Created by 虎猫儿 on 15/10/6.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import "LFMyItemViewController.h"

#import "LFActivityIndicatorLabel.h"

@interface LFMyItemViewController ()

@property (nonatomic,strong) LFActivityIndicatorLabel *titleLabel ;

@end

@implementation LFMyItemViewController

- (void)viewDidLoad {
    [super viewDidLoad] ;
    
    self.titleLabel = [[LFActivityIndicatorLabel alloc] init] ;
    [self.titleLabel setText:@"test"] ;
    [self.titleLabel sizeToFit] ;
    
    [self.navigationItem setTitleView:self.titleLabel] ;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.titleLabel showIndicator:YES] ;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.titleLabel setText:@"OK" showIndicator:NO] ;
        });
    });
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning] ;
}


@end
