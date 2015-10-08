//
//  LFMailBoxTableViewController.m
//  L-FMS-iOS
//
//  Created by 虎猫儿 on 15/10/3.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import "LFMailBoxTableViewController.h"
#import "LFMailBoxTableViewCell.h"
#import "LFMailBoxCommentTableViewCell.h"

#import "LFChatRoomViewController.h"
#import "AppDelegate.h"

#import "LFCommon.h"

@interface LFMailBoxTableViewController ()

@end

@implementation LFMailBoxTableViewController

- (void)viewDidLoad {
    [super viewDidLoad] ;

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated] ;
    [self.tabBarController.tabBar setHidden:NO] ;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning] ;
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60 ;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1 ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1 + 2 ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row ;
    if ( row == 0 ) {
        //评论
        LFMailBoxCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LFMailBoxCommentTableViewCellReuseId" forIndexPath:indexPath] ;
        return cell ;
    }
    
    LFMailBoxTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LFMailBoxTableViewCellReuseId" forIndexPath:indexPath] ;
    [cell.avatarImageView setImage:[UIImage imageNamed:@"testAvatar1"]] ;
    return cell ;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row ;
    if ( row == 0 ) {
        //到评论。
        QYDebugLog(@"到评论") ;
        UIViewController *vc = [AppDelegate getViewControllerById:@"LFCommentNoticeTableViewControllerSBID"] ;
        vc.hidesBottomBarWhenPushed = YES ;
        [self.navigationController pushViewController:vc animated:YES] ;
        
    } else {
        //到聊天界面。
        QYDebugLog(@"到聊天Room") ;
        LFChatRoomViewController *vc = [[LFChatRoomViewController alloc] init] ;
        vc.hidesBottomBarWhenPushed = YES ;
        [self.navigationController pushViewController:vc animated:YES] ;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES] ;
}

@end
