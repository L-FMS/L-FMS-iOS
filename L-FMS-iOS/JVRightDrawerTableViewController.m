//
//  JVRightDrawerTableViewController.m
//  L-FMS-iOS
//
//  Created by 虎猫儿 on 15/10/2.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import "JVRightDrawerTableViewController.h"
#import "JVRightDrawerCell.h"

#import "LFCommon.h"
#import "AppDelegate.h"

#import <JVFloatingDrawer/JVFloatingDrawerView.h>
#import <JVFloatingDrawer/JVFloatingDrawerSpringAnimator.h>

#define kWIDTH_RATIO ([UIScreen mainScreen].bounds.size.width)/320.0
#define kHEIGHT_RATIO ([UIScreen mainScreen].bounds.size.height)/568.0

@interface JVRightDrawerTableViewController ()

@property (nonatomic,strong) NSArray *operationTitles ;

@end

@implementation JVRightDrawerTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone ;
    self.tableView.backgroundColor = [UIColor clearColor] ;
    self.tableView.contentInset = UIEdgeInsetsMake(80*kHEIGHT_RATIO, 0.0, 0.0, 0.0) ;
    self.clearsSelectionOnViewWillAppear = NO ;
    
    self.operationTitles = @[@"添加",@"搜索",@"扫一扫"] ;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning] ;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1 ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.operationTitles.count ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70*kHEIGHT_RATIO ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseId = @"JVRightDrawerCellReuseIdentifier" ;
    
    JVRightDrawerCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId forIndexPath:indexPath] ;
    
    cell.titleText = self.operationTitles[indexPath.row] ;
    cell.iconImage = [UIImage imageNamed:@"testIcon1"] ;
    
    return cell;
}

#pragma mark - UITableViewDelegate 

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger index = indexPath.row ;
    switch (index) {
        case 0 : {
            //添加
            [self addBtnClicked] ;
            break ;
        }
            
        case 1 : {
            //搜索
            [self searchBtnClicked] ;
            break ;
        }
            
        case 2 : {
            //扫一扫
            [self scanQRBtnClicked] ;
            break ;
        }
            
        default:
            break;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO] ;
}

#pragma mark - Actions

- (void)addBtnClicked {
    NSString *SBID = @"NewItemViewController2SBID" ;
    //@"NewItemTableViewControllerSBID"
    UIViewController *vc = [AppDelegate getViewControllerById:SBID] ;
    vc.hidesBottomBarWhenPushed = YES ;
    [self toVC:vc] ;
}

- (void)searchBtnClicked {
    UIViewController *vc = [AppDelegate getViewControllerById:@"LFSearchItemViewControllerSBID"] ;
    vc.hidesBottomBarWhenPushed = YES ;
    [self toVC:vc] ;
}

- (void)scanQRBtnClicked {
    
}

#pragma mark - Helper

- (void)toVC:(id)vc {
    if ( vc ) {
        UITabBarController *mainTabbarVc = (id)[[AppDelegate globalAppdelegate] drawerViewController].centerViewController ;
        UINavigationController *mainNavc = mainTabbarVc.viewControllers[0] ;
        [mainNavc pushViewController:vc animated:NO] ;
    }
    
    [[AppDelegate globalAppdelegate] toggleRightDrawer:self animated:YES] ;
}

@end
