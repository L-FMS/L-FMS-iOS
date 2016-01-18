//
//  NewItemTableViewController.m
//  L-FMS-iOS
//
//  Created by 虎猫儿 on 15/10/4.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import "NewItemTableViewController.h"

#import "LFCommon.h"

#import "LFLocationTableViewCell.h"

#define KTwo 2

#define kNewItemVC2ChooseLocationMapVCSegueId @"NewItemVC2ChooseLocationMapVCSegueId"

@interface NewItemTableViewController ()

@end

@implementation NewItemTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row / 2;
    
    switch (row) {
        case 2 : {
            //到选地图界面
            [self performSegueWithIdentifier:kNewItemVC2ChooseLocationMapVCSegueId sender:self];
            break;
        }
            
        default : {
            break;
        }
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    BOOL isSeparator = (row % 2)^TRUE;
    row = row / 2;
    if (isSeparator) {
        return 36;
    } else {
        return 44;
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return KTwo * 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    BOOL isSeparator = (row % 2)^TRUE;
    row = row / 2;
    if (isSeparator) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LFSeparatorTableViewCellReuseId" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else {
        UITableViewCell *cell;
        switch (row) {
            case 2 : {
                cell = [tableView dequeueReusableCellWithIdentifier:@"LFLocationTableViewCellReuseId" forIndexPath:indexPath];
                break;
            }
                
            default : {
                cell = [tableView dequeueReusableCellWithIdentifier:@"LFTextFieldTableViewCellReuseId" forIndexPath:indexPath];
                break;
            }
        }
        
        return cell;
    }

}

- (IBAction)ensureBtnClicked:(id)sender {
    QYDebugLog(@"确定按钮");
    
    Item *newItem = [Item object];
    newItem.itemDescription = @"TestDesc";
    newItem.name = @"TestName";
    newItem.tags = @[@"Tag1",@"Tag2",@"Tag3"];
    newItem.type = @"found";
    newItem.user = [LFUser currentUser];
    
    [SVProgressHUD show];
    [newItem saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [SVProgressHUD dismiss];
        if (succeeded) {
            QYDebugLog(@"Successed");
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            QYDebugLog(@"Error:[%@]",error);
        }
    }];
}

#pragma mark -

@end
