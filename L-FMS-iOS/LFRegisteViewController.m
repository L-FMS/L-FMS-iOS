//
//  LFRegisteViewController.m
//  L-FMS-iOS
//
//  Created by 虎猫儿 on 15/9/26.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import "LFRegisteViewController.h"

#import "LFCommon.h"

@interface LFRegisteViewController ()

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *registeButton ;
@property (weak, nonatomic) IBOutlet UIView *passwordView;
@property (weak, nonatomic) IBOutlet UIView *usernameView;
@property (weak, nonatomic) IBOutlet UIView *registeInfoContainerView;

@end

@implementation LFRegisteViewController

- (void)viewDidLoad {
    [super viewDidLoad] ;
    
    NSArray *views = @[self.registeButton,self.passwordView,self.usernameView,self.registeInfoContainerView] ;
    [views enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
        [view.layer setMasksToBounds:YES] ;
        [view.layer setCornerRadius:5.0f] ;
    }] ;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning] ;
}

#pragma mark - IBActions

- (IBAction)registeBtnClicked:(id)sender {
    NSString *username = self.usernameTextField.text ;
    NSString *password = self.passwordTextField.text ;
    if ( !username || username.length == 0 ) {
        [LFUtils alert:@"用户名不能为空"] ;
        return ;
    }
    
    if ( !password || password.length == 0 ) {
        [LFUtils alert:@"密码不能为空"] ;
        return ;
    }
    
    if ( ![ZRUtils validateEmail:username] ) {
        [LFUtils alert:@"用户名不合法，请输入邮箱"] ;
        return ;
    }
    
    LFUser *user = [LFUser user] ;
    
    user.username = username ;
    user.password = password ;
    user.name = @"未设置昵称" ;
    user.email = username ;
    [SVProgressHUD show] ;
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if ( succeeded ) {
            [SVProgressHUD showWithStatus:@"注册成功"] ;
            [LFUser logInWithUsernameInBackground:username password:password block:^(AVUser *user, NSError *error) {
                if ( user ) {
                    [SVProgressHUD showSuccessWithStatus:@"登录成功"] ;
                    [LFUtils toMain] ;
                } else {
                    [SVProgressHUD showErrorWithStatus:@"登录失败"] ;
                    QYDebugLog(@"登录失败 Error:[%@]",error) ;
                }
            }] ;
            
        } else {
            [SVProgressHUD showErrorWithStatus:@"注册失败"] ;
            QYDebugLog(@"注册失败 Error:[%@]",error) ;
        }
    }] ;
    
}

- (IBAction)toLoginBtnClicked:(id)sender {
    [LFUtils toLogin] ;
}

#pragma mark - KeyBoard

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.usernameTextField resignFirstResponder] ;
    [self.passwordTextField resignFirstResponder] ;
}

@end
