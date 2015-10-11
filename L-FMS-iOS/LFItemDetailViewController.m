//
//  LFItemDetailViewController.m
//  L-FMS-iOS
//
//  Created by 虎猫儿 on 15/10/8.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import "LFItemDetailViewController.h"

#import "LFToolBarView.h"
#import "LFCommon.h"

#import "LFItemDetailTagsTableViewCell.h"
#import "LFItemDetailInformationTableViewCell.h" 
#import "LFItemDetailCommentNavTableViewCell.h"
#import "LFitemDetailCommentTableViewCell.h"
#import "LFItemDetailUserInfoTableViewCell.h"
#import "LFItemDetailSeparateTableViewCell.h"

@interface LFItemDetailViewController ()<LFToolBarViewDelegate,LFToolBarViewDataSource,UITableViewDelegate,UITableViewDataSource> {
    NSArray *_titles ;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView ;
@property (strong ,nonatomic) UIRefreshControl *refreshControl ;
@property (weak, nonatomic) IBOutlet LFToolBarView *toolBarView ;

@end

@implementation LFItemDetailViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad] ;

    self.tableView.delegate = self ;
    self.tableView.dataSource = self ;
//    self.nameLabel.text = _item.name ;
//    self.descLabel.text = _item.itemDescription ;
//    self.tagsLabel.text = [_item.tags componentsJoinedByString:@","] ;
//    if ( _item.image ) {
//        [self.imageView sd_setImageWithURL:[NSURL URLWithString:_item.image.url]
//                          placeholderImage:[UIImage imageNamed:@"testAvatar1"]] ;
//    }
    
    self.toolBarView.delegate = self ;
    self.toolBarView.dataSource = self ;
    _titles = @[@"评论",@"私信"] ;    
    [self.toolBarView reloadData] ;
    
    [self.tableView addSubview:self.refreshControl] ;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning] ;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES] ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //Item+(分割)+User+(分割)+Tag+(分割)+评论Nav+评论*N
    NSInteger row = indexPath.row ;
    
    if ( row <= 5 ) {
        //Item+(分割)+User+(分割)+Tag+(分割)
        BOOL isSeparate = row % 2 ;
        row = row / 2 ;
        if ( isSeparate ) {
            //分割
            return 10.0f ;
            
        } else {
            //Item + User + Tag
            switch (row) {
                case 0 : {
                    //Item
#warning 计算的高度！
                    return 180 ;
                    break ;
                }
                    
                case 1 : {
                    //User
                    return 70 ;
                    break ;
                }
                    
                default : {
                    //Tag
#warning 计算的高度！
                    return 44 ;
                    
                    break ;
                }
            }
            
        }
        
        
    } else {
        //评论Nav+评论*N
        row -= 6 ;
        
        if ( row == 0 ) {
            //评论Nav
            return 30 ;
            
        } else {
            row -= 1 ;
            //评论
#warning 计算的高度
            return 120 ;
        }
        
    }
    return 44 ;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3 * 2 + 1 + 2 ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //Item+(分割)+User+(分割)+Tag+(分割)+评论Nav+评论*N
    
    
    NSInteger row = indexPath.row ;
    if ( row <= 5 ) {
        //Item+(分割)+User+(分割)+Tag+(分割)
        BOOL isSeparate = row % 2 ;
        row = row / 2 ;
        if ( isSeparate ) {
            //分割
            LFItemDetailSeparateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LFItemDetailSeparateTableViewCellReuseId" forIndexPath:indexPath] ;
            return cell ;
            
        } else {
            //Item + User + Tag
            switch (row) {
                case 0 : {
                    //Item
                    LFItemDetailInformationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LFItemDetailInformationTableViewCellReuseId" forIndexPath:indexPath] ;
                    return cell ;
                    
                    break ;
                }
                    
                case 1 : {
                    //User
                    LFItemDetailUserInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LFItemDetailUserInfoTableViewCellReuseId" forIndexPath:indexPath] ;
                    return cell ;
                    
                    break ;
                }
                    
                default : {
                    //Tag
                    LFItemDetailTagsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LFItemDetailTagsTableViewCellReuseId" forIndexPath:indexPath] ;
                    return cell ;
                    
                    break ;
                }
            }
            
        }
        
        
    } else {
        //评论Nav+评论*N
        row -= 6 ;
        
        if ( row == 0 ) {
            //评论Nav
            LFItemDetailCommentNavTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LFItemDetailCommentNavTableViewCellReuseId" forIndexPath:indexPath] ;
            return cell ;
            
        } else {
            row -= 1 ;
            //评论
            LFitemDetailCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LFitemDetailCommentTableViewCellReuseId" forIndexPath:indexPath] ;
            return cell ;
        }
        
    }
    
    
    LFItemDetailUserInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LFItemDetailUserInfoTableViewCellReuseId" forIndexPath:indexPath] ;
    
    
    return cell ;
}



#pragma mark - LFToolBarViewDelegate

- (void)toolBarView:(LFToolBarView *)toolBarView didSelectedItemAtIndex:(NSUInteger)index {
    switch (index) {
        case 0 : {
            //评论
            [self showCommentViewController] ;
            break ;
        }
            
        case 1 : {
            //私信
            [self showMailBoxViewController] ;
            break ;
        }
            
        default :
            break ;
    }
}

#pragma mark - LFToolBarViewDataSource

- (NSUInteger)numberOfItemsInToolBarView:(LFToolBarView *)toolBarView {
    return _titles.count ;
}

- (NSString *)toolBarView:(LFToolBarView *)toolBarView titleForItemAtIndex:(NSUInteger)index {
    return _titles[index] ;
}

#pragma mark - getter && setter

- (UIRefreshControl *)refreshControl {
    if ( !_refreshControl ) {
        _refreshControl = [[UIRefreshControl alloc] init] ;
        [_refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged] ;
    }
    return _refreshControl ;
}

#pragma mark - actions 

- (void)refresh:(UIRefreshControl *)refreshControl {
    [refreshControl endRefreshing] ;
}

- (void)showCommentViewController {
    QYDebugLog(@"评论") ;
}

- (void)showMailBoxViewController {
    QYDebugLog(@"私信") ;
}

@end
