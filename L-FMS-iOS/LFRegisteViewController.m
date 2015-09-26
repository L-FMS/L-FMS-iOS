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

@end

@implementation LFRegisteViewController

- (void)viewDidLoad {
    [super viewDidLoad] ;
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
    
    AVUser *user = [AVUser user] ;
    
    user.username = username ;
    user.password = password ;
    [SVProgressHUD show] ;
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if ( succeeded ) {
            [SVProgressHUD showWithStatus:@"注册成功"] ;
            [AVUser logInWithUsernameInBackground:username password:password block:^(AVUser *user, NSError *error) {
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
