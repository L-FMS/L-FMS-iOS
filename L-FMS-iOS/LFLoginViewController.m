//
//  LFLoginViewController.m
//  L-FMS-iOS
//
//  Created by 虎猫儿 on 15/9/26.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import "LFLoginViewController.h"

#import "LFCommon.h"

@interface LFLoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@end

@implementation LFLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBActions

- (IBAction)loginBtnClicked:(id)sender {
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
    
//#warning test
//    username = @"zrtest" ;
//    password = @"123456" ;
    
    [SVProgressHUD show] ;
    [LFUser logInWithUsernameInBackground:username password:password block:^(AVUser *user, NSError *error) {
        if ( user ) {
            [SVProgressHUD showSuccessWithStatus:@"登录成功"] ;
            [LFUtils toMain] ;
        } else {
            [SVProgressHUD showErrorWithStatus:@"登录失败"] ;
            QYDebugLog(@"登录失败 Error:[%@]",error) ;
        }
    }] ;
    
}

- (IBAction)toRegisteBtnClicked:(id)sender {
    [LFUtils toRegiste] ;
}

#pragma mark - KeyBoard

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.usernameTextField resignFirstResponder] ;
    [self.passwordTextField resignFirstResponder] ;
}

@end