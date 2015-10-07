//
//  LFMyItemViewController.m
//  L-FMS-iOS
//
//  Created by 虎猫儿 on 15/10/6.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import "LFMyItemViewController.h"

#import "LFActivityIndicatorLabel.h"
#import "LFItemTableViewCell.h"
#import "LFCommon.h"

@interface LFMyItemViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) LFActivityIndicatorLabel *titleLabel ;
@property (nonatomic,strong) id segnmentControl ;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong) UIRefreshControl *refreshControl ;

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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning] ;
}

#pragma mark - UITableViewDelegate 



#pragma mark - UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70 ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1 ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseId = @"LFItemTableViewCellReuseId" ;
    
    LFItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId forIndexPath:indexPath] ;
    cell.descImageView.image = [UIImage imageNamed:@"Lost"] ;
    
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

- (BOOL)isRefreshing {
    return self.titleLabel.isRefreshing ;
}

#pragma mark - actions 

- (void)refresh:(UIRefreshControl *)control {
    [control endRefreshing] ;
    if ( self.isRefreshing ) {
        return ;
    }
    self.segnmentControl = self.navigationItem.titleView ;
    [self.navigationItem setTitleView:self.titleLabel] ;
    [self.titleLabel showIndicator:YES] ;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.titleLabel showIndicator:NO] ;
        [self.navigationItem setTitleView:self.segnmentControl] ;
    });
}

@end
