//
//  UserInformationViewController.m
//  L-FMS-iOS
//
//  Created by 虎猫儿 on 15/10/4.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import "UserInformationViewController.h"
#import "UserInfoItemTableViewCell.h"

#import "LFCommon.h"

@interface UserInformationViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;

@property (nonatomic) NSArray *titles ;

@end

@implementation UserInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad] ;
    
    [self.avatarImageView.layer setMasksToBounds:YES] ;
    [self.avatarImageView.layer setCornerRadius:self.avatarImageView.bounds.size.height/2] ;
    
    self.titles = @[@"邮箱",@"昵称",@"性别"] ;
    self.title = @"账号信息" ;
    
    [[LFUser currentUser] displayAvatarAtImageView:self.avatarImageView] ;
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated] ;
    [self.tabBarController.tabBar setHidden:YES] ;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning] ;
}

#pragma mark - UITableViewDataSource 

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1 ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titles.count ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseId = @"UserInfoItemTableViewCellReuseId" ;
    
    UserInfoItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId forIndexPath:indexPath] ;
    [cell setUpWithTitle:self.titles[indexPath.row] detailDesc:@"描述"] ;
    
    return cell ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50 ;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES] ;
}

#pragma mark - IBActions 

- (IBAction)avatarBtnClicked:(id)sender {
    QYDebugLog(@"点击了头像，是自己能修改，别人就是查看图片") ;
}

- (IBAction)logoffBtnClicked:(id)sender {
    [LFUser logOut] ;
    [LFUtils toLogin] ;
}

@end