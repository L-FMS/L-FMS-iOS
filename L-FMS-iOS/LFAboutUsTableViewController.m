//
//  LFAboutUsTableViewController.m
//  L-FMS-iOS
//
//  Created by 虎猫儿 on 15/10/12.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import "LFAboutUsTableViewController.h"
#import "LFAboutUsAuthorInfoTableViewCell.h"

#define kUserNameKey @"username"
#define kUserAvatarKey @"avatarImagename"
#define kUserDescriptionKey @"userDescription"

@interface LFAboutUsTableViewController ()

@property (nonatomic) NSArray *dataSource ;

@end

@implementation LFAboutUsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad] ;
    
    self.dataSource = @[@{kUserNameKey:@"张思雨",
                          kUserAvatarKey:@"zsy",
                          kUserDescriptionKey:@"大三\n"
                                               "感妩媚"},
                        @{kUserNameKey:@"胡圣托",
                          kUserAvatarKey:@"hst",
                          kUserDescriptionKey:@"大四\n"
                                               "gay佬"},
                        @{kUserNameKey:@"张睿",
                          kUserAvatarKey:@"zr",
                          kUserDescriptionKey:@"大四\n"
                                               "变态"}] ;
    
    self.tableView.dataSource = self ;
    self.tableView.delegate = self ;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning] ;
}

#pragma mark - UITableViewDelegate 

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120 ;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LFAboutUsAuthorInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LFAboutUsAuthorInfoTableViewCellReuseId" forIndexPath:indexPath] ;
    NSDictionary *info = self.dataSource[indexPath.row] ;
    cell.selectionStyle = UITableViewCellSelectionStyleNone ;
    
    cell.photoImageView.image = [UIImage imageNamed:info[kUserAvatarKey]] ;
    cell.nameLabel.text = info[kUserNameKey] ;
    cell.descriptionLabel.text = info[kUserDescriptionKey] ;
    [cell.descriptionLabel sizeToFit] ;
    
    return cell;
}


@end
