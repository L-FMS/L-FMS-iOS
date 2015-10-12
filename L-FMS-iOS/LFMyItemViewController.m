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
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;

@property (nonatomic,strong) NSMutableArray *dataSource ;

- (BOOL)isRefreshing ;

@property (strong) NSMutableArray *items ;
@property (strong) NSMutableDictionary *itemsDic ;

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
    
    self.items = [NSMutableArray array] ;
    self.itemsDic = [NSMutableDictionary dictionary] ;
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
    [self.navigationController pushViewController:vc animated:NO] ;
    
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
    cell.descImageView.image = item.isLost ? [UIImage imageNamed:@"Lost"] :
                                             [UIImage imageNamed:@"Found"] ;
    
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
    [query includeKey:@"user"] ;
    LFWEAKSELF
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        [weakSelf setRefreshing:NO] ;
        if ( objects ) {
            [weakSelf addItems:objects] ;
        } else {
            [LFUtils alertError:error] ;
        }
    }] ;
}

- (IBAction)changeSegument:(UISegmentedControl *)sender {
    NSString *type = sender.selectedSegmentIndex == 0 ? @"found" : @"lost" ;
    [self filterItemsByType:type] ;
}

#pragma mark - Helper 

- (void)addItems:(NSArray *)items {
    if ( !items ) return ;
    
    [items enumerateObjectsUsingBlock:^(Item *item, NSUInteger idx, BOOL *stop) {
        if ( !self.itemsDic[item.objectId] ) {
            [self.itemsDic setObject:item forKey:item.objectId] ;
            [self.items addObject:item] ;
        }
    }] ;
    
    [self filterItemsByType:self.segmentedControl.selectedSegmentIndex==0?@"found":@"lost"] ;
}

- (void)filterItemsByType:(NSString *)type {
    //塞选
    NSMutableArray *dataSource = [NSMutableArray array] ;
    [self.items enumerateObjectsUsingBlock:^(Item *item, NSUInteger idx, BOOL *stop) {
        if ( [item.type isEqualToString:type] ) {
            [dataSource addObject:item] ;
        }
    }] ;
    self.dataSource = dataSource ;
    
    [self.tableView reloadData] ;
}

//- (void)sortItemsByCreateDateWithAscending:(BOOL)isAscending {
//    
//}

@end
