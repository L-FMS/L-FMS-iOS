//
//  JVLeftDrawerTableViewController.m
//  L-FMS-iOS
//
//  Created by 虎猫儿 on 15/10/2.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import "JVLeftDrawerTableViewController.h"
#import "LFCommon.h"
#import "AppDelegate.h"

#import "JVLeftDrawerCell.h"

#import <JVFloatingDrawer/JVFloatingDrawerView.h>
#import <JVFloatingDrawer/JVFloatingDrawerSpringAnimator.h>

#define kHEIGHT_RATIO ([UIScreen mainScreen].bounds.size.height)/568.0

static CGFloat kJVTableViewTopInset = 110.0 ;

@interface JVLeftDrawerTableViewController ()

@property (strong,nonatomic) UIImageView *avatarImageView ;
@property (strong,nonatomic) UILabel *nameLabel ;

@property (nonatomic,strong) NSArray *operationTitles ;
@property (nonatomic,strong) NSArray *iconImangeNames ;


@end

@implementation JVLeftDrawerTableViewController

#pragma mark - getter && setter

- (UIImageView *)avatarImageView {
    if ( !_avatarImageView ) {
        _avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(36, -40, 45, 45)] ;
        _avatarImageView.userInteractionEnabled = YES ;
        UITapGestureRecognizer *singleTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(avatarImageViewClicked:)] ;
        [_avatarImageView addGestureRecognizer:singleTap1] ;
        
        [_avatarImageView.layer setCornerRadius:CGRectGetHeight([_avatarImageView bounds]) / 2.0f] ;
        _avatarImageView.layer.masksToBounds = YES ;
    }
    return _avatarImageView ;
}

- (UILabel *)nameLabel {
    if ( !_nameLabel ) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, -36, 80, 25)] ;
        _nameLabel.font = [UIFont systemFontOfSize:15.0f] ;
        _nameLabel.text = @"" ;
    }
    return _nameLabel ;
}

#pragma mark - Life Cycle 

- (void)setUpUIControls {
    //头像
    [self.view addSubview:self.avatarImageView] ;
    
    //昵称
    [self.view addSubview:self.nameLabel] ;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.backgroundColor = [UIColor clearColor] ;
    self.tableView.contentInset = UIEdgeInsetsMake(kJVTableViewTopInset*kHEIGHT_RATIO, 0.0, 0.0, 0.0) ;
    self.clearsSelectionOnViewWillAppear = NO ;
    
    [self setUpUIControls] ;
    
    self.nameLabel.text = [[LFUser currentUser] displayName] ;
    [self.nameLabel sizeToFit] ;
    [[LFUser currentUser] displayAvatarAtImageView:self.avatarImageView] ;
    
    self.operationTitles = @[@"个人信息",@"关于我们",@"设置",@"版本说明"] ;
    self.iconImangeNames = @[@"selfInfoIcon(LeftDrawer)",
                             @"aboutUsIcon(LeftDrawer)",
                             @"testIcon1",
                             @"versionReadmeIcon(LeftDrawer)"] ;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning] ;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1 ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4 ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 48 * kHEIGHT_RATIO ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseId = @"JVLeftDrawerCellReuseIdentifier" ;
    
    JVLeftDrawerCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId forIndexPath:indexPath] ;
    
    [cell setIconImage:[UIImage imageNamed:@"testIcon1"]] ;
    
    [cell setIconImage:[UIImage imageNamed:self.iconImangeNames[indexPath.row]]] ;
    [cell setTitleText:self.operationTitles[indexPath.row]] ;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0 : {
            id vc = [AppDelegate getViewControllerById:@"UserInformationViewControllerSBID"] ;
            [self toVC:vc] ;
            break ;
        }
        default :
            [self toVC:nil] ;
            break;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO] ;
}

#pragma mark - IBActions 

- (void)avatarImageViewClicked:(id)sender {
    QYDebugLog(@"点击了头像") ;
}

- (void)toVC:(id)vc {
    if ( vc ) {
        UITabBarController *mainTabbarVc = (id)[[AppDelegate globalAppdelegate] drawerViewController].centerViewController ;
        UINavigationController *mainNavc = mainTabbarVc.viewControllers[0] ;
        [mainNavc pushViewController:vc animated:NO] ;
    }
    
    [[AppDelegate globalAppdelegate] toggleLeftDrawer:self animated:YES] ;
}

@end
