//
//  LFSettingTableViewController.m
//  L-FMS-iOS
//
//  Created by 虎猫儿 on 15/10/12.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import "LFSettingTableViewController.h"

#import "LFSettingSwitchTableViewCell.h"

#import "LFCommon.h"
#import "LFUserDefaultService.h"

@interface LFSettingTableViewController ()<LFSettingSwitchTableViewCellDelegate>

@end

@implementation LFSettingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad] ;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning] ;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated] ;
    [self.tabBarController.tabBar setHidden:YES] ;
}

#pragma mark - UITableViewDelegate 

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60 ;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1 ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1 ;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LFSettingSwitchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LFSettingSwitchTableViewCellReuseId"  forIndexPath:indexPath] ;
    cell.itemDescriptionLabel.text = @"显示聊天室背景图片" ;
    BOOL on = [LFUserDefaultService getChatRoomBackgroundSwitch] ;
    [cell.itemSwitch setOn:on animated:NO] ;
    cell.delegate = self ;
    
    return cell;
}


#pragma mark - LFSettingSwitchTableViewCellDelegate

- (void)cell:(LFSettingSwitchTableViewCell *)cell switchToState:(BOOL)on {
    [LFUserDefaultService setChatRoomBackgroundSwitch:on] ;
}


@end
