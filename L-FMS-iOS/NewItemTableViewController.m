//
//  NewItemTableViewController.m
//  L-FMS-iOS
//
//  Created by 虎猫儿 on 15/10/4.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import "NewItemTableViewController.h"

#import "LFCommon.h"

@interface NewItemTableViewController ()

@end

@implementation NewItemTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning] ;
}

#pragma mark - UITableViewDelegate

#pragma mark - UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row ;
    BOOL isSeparator = (row % 2)^TRUE ;
    row = row / 2 ;
    if ( isSeparator ) {
        return 36 ;
    } else {
        return 44 ;
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1 ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2 * 2 ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row ;
    BOOL isSeparator = (row % 2)^TRUE ;
    row = row / 2 ;
    if ( isSeparator ) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LFSeparatorTableViewCellReuseId" forIndexPath:indexPath] ;
        return cell ;
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LFTextFieldTableViewCellReuseId" forIndexPath:indexPath] ;
        return cell;
    }

}

- (IBAction)ensureBtnClicked:(id)sender {
    QYDebugLog(@"确定按钮") ;
    
    Item *newItem = [Item object] ;
    newItem.itemDescription = @"TestDesc" ;
    newItem.name = @"TestName" ;
    newItem.tags = @[@"Tag1",@"Tag2",@"Tag3"] ;
    newItem.type = @"found" ;
    newItem.user = [LFUser currentUser] ;
    
    [SVProgressHUD show] ;
    [newItem saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [SVProgressHUD dismiss] ;
        if ( succeeded ) {
            QYDebugLog(@"Successed") ;
            [self.navigationController popViewControllerAnimated:YES] ;
        } else {
            QYDebugLog(@"Error:[%@]",error) ;
        }
    }] ;
}

#pragma mark -

@end
