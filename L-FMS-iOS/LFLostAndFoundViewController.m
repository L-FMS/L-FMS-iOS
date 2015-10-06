//
//  LFLostAndFoundViewController.m
//  L-FMS-iOS
//
//  Created by 虎猫儿 on 15/10/3.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import "LFLostAndFoundViewController.h"

#import "AppDelegate.h"

@interface LFLostAndFoundViewController ()

@end

@implementation LFLostAndFoundViewController

- (void)viewDidLoad {
    [super viewDidLoad] ;
    [self.navigationController.navigationBar setTranslucent:FALSE] ;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated] ;
    [self.tabBarController.tabBar setHidden:NO] ;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning] ;
}

#pragma mark - IBActions

- (IBAction)showLeftDrawerBtnClicked:(id)sender {
    [[AppDelegate globalAppdelegate] toggleLeftDrawer:self animated:YES] ;
}

- (IBAction)showRightDrawerBtnClicked:(id)sender {
    [[AppDelegate globalAppdelegate] toggleRightDrawer:self animated:YES] ;
}

@end
