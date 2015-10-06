//
//  LFMailBoxTableViewController.m
//  L-FMS-iOS
//
//  Created by 虎猫儿 on 15/10/3.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import "LFMailBoxTableViewController.h"
#import "LFMailBoxTableViewCell.h"

@interface LFMailBoxTableViewController ()

@end

@implementation LFMailBoxTableViewController

- (void)viewDidLoad {
    [super viewDidLoad] ;
    

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
    return 2 ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseId = @"LFMailBoxTableViewCellReuseId" ;
    LFMailBoxTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId forIndexPath:indexPath] ;
    [cell.avatarImageView setImage:[UIImage imageNamed:@"testAvatar1"]] ;
    
    return cell ;
}

@end
