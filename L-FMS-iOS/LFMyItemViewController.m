//
//  LFMyItemViewController.m
//  L-FMS-iOS
//
//  Created by 虎猫儿 on 15/10/6.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import "LFMyItemViewController.h"
#import "LFItemDetailViewController.h"
#import "AppDelegate.h"

#import "LFActivityIndicatorLabel.h"
#import "LFItemTableViewCell.h"
#import "LFCommon.h"

@interface LFMyItemViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) LFActivityIndicatorLabel *titleLabel ;
@property (nonatomic,strong) id segnmentControl ;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong) UIRefreshControl *refreshControl ;

@property (nonatomic,strong) NSMutableArray *dataSource ;

- (BOOL)isRefreshing ;

@end

@implementation LFMyItemViewController

- (void)viewDidLoad {
    [super viewDidLoad] ;
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        self.segnmentControl = self.navigationItem.titleView ;
//        [self.navigationItem setTitleView:self.titleLabel] ;
//        [self.titleLabel showIndicator:YES] ;
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [self.navigationItem setTitleView:self.segnmentControl] ;
//        });
//    });
//
    
    [self.tableView addSubview:self.refreshControl] ;
}

- (void)viewWillAppear:(BOOL)animated {
    [self.tabBarController.tabBar setHidden:NO] ;
    [super viewWillAppear:animated] ;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning] ;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Item *item = self.dataSource[indexPath.row] ;
    LFItemDetailViewController *vc = [AppDelegate getViewControllerById:@"LFItemDetailViewControllerSBID"] ;
    vc.item = item ;
    vc.hidesBottomBarWhenPushed = YES ;
    [self.navigationController pushViewController:vc animated:YES] ;
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES] ;
}

#pragma mark - UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70 ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseId = @"LFItemTableViewCellReuseId" ;
    
    LFItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId forIndexPath:indexPath] ;
    cell.descImageView.image = [UIImage imageNamed:@"Lost"] ;
    
    Item *item = self.dataSource[indexPath.row] ;
    cell.ItemDescriptionLabel.text = item.name ;
    cell.timeLabel.text = [LFUtils date2LongTimeStr:item.createdAt] ;
    
    
    return cell ;
}

#pragma mark - getter && setter 

- (LFActivityIndicatorLabel *)titleLabel {
    if ( !_titleLabel ) {
        _titleLabel = [[LFActivityIndicatorLabel alloc] init] ;
        [_titleLabel setText:@"刷新中" showIndicator:NO] ;
        [_titleLabel sizeToFit] ;
    }
    return _titleLabel ;
}

- (UIRefreshControl *)refreshControl {
    if ( !_refreshControl ) {
        _refreshControl = [[UIRefreshControl alloc] init] ;
        [_refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged] ;
    }
    return _refreshControl ;
}

- (NSMutableArray *)dataSource {
    return _dataSource ? : (_dataSource = [NSMutableArray array] ) ;
}

#pragma mark - Refresh Status

- (BOOL)isRefreshing {
    return self.titleLabel.isRefreshing ;
}

- (void)setRefreshing:(BOOL)isRefreshing {
    if ( isRefreshing ) {
        [self.refreshControl removeFromSuperview] ;
        self.segnmentControl = self.navigationItem.titleView ;
        [self.navigationItem setTitleView:self.titleLabel] ;
        [self.titleLabel showIndicator:YES] ;
    } else {
        [self.titleLabel showIndicator:NO] ;
        [self.navigationItem setTitleView:self.segnmentControl] ;
        self.segnmentControl = nil ;
        [self.tableView addSubview:self.refreshControl] ;
    }
}

#pragma mark - actions 

- (void)refresh:(UIRefreshControl *)control {
    [control endRefreshing] ;
    if ( self.isRefreshing ) {
        return ;
    }
    
    [self setRefreshing:YES] ;
    
    AVQuery *query = [AVQuery queryWithClassName:NSStringFromClass([Item class])] ;
    [query whereKey:@"user" equalTo:[LFUser currentUser]] ;
    LFWEAKSELF
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        [weakSelf setRefreshing:NO] ;
        if ( objects ) {
            NSMutableSet *set = [NSMutableSet setWithArray:self.dataSource] ;
            [set addObjectsFromArray:objects] ;
            self.dataSource = [NSMutableArray arrayWithArray:set.allObjects] ;
            //排序
            [weakSelf.tableView reloadData] ;
        } else {
            [LFUtils alertError:error] ;
        }
    }] ;
}

@end
