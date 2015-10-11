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

@interface LFItemDetailViewController ()<LFToolBarViewDelegate,LFToolBarViewDataSource,UITableViewDelegate,UITableViewDataSource> {
    NSArray *_titles ;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView ;
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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning] ;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES] ;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0 ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil ;
}



#pragma mark - LFToolBarViewDelegate

- (void)toolBarView:(LFToolBarView *)toolBarView didSelectedItemAtIndex:(NSUInteger)index {
    switch (index) {
        case 0 : {
            //评论
            QYDebugLog(@"评论") ;
            break ;
        }
            
        case 1 : {
            //私信
            QYDebugLog(@"私信") ;
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

@end
