//
//  ZRUtils.m
//  L-FMS-iOS
//
//  Created by 虎猫儿 on 15/10/6.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import "ZRUtils.h"

#import "ZRRegularExpressionValidateUtilsImp.h"

@implementation ZRUtils

#pragma mark - ZRRegularExpressionValidateUtils

//邮箱
+ (BOOL)validateEmail:(NSString *)email {
    return [ZRRegularExpressionValidateUtilsImp validateEmail:email];
}

//手机号码验证
+ (BOOL)validateMobile:(NSString *)mobile {
    return [ZRRegularExpressionValidateUtilsImp validateMobile:mobile];
}

//车牌号验证
+ (BOOL)validateCarNo:(NSString *)carNo {
    return [ZRRegularExpressionValidateUtilsImp validateCarNo:carNo];
}

//车型
+ (BOOL)validateCarType:(NSString *)CarType {
    return [ZRRegularExpressionValidateUtilsImp validateCarType:CarType];
}

//用户名[大小写字母、0-9]6-20长度
+ (BOOL)validateUserName:(NSString *)name {
    return [ZRRegularExpressionValidateUtilsImp validateUserName:name];
}

//密码同用户名
+ (BOOL)validatePassword:(NSString *)passWord {
    return [ZRRegularExpressionValidateUtilsImp validatePassword:passWord];
}

//昵称
+ (BOOL)validateNickname:(NSString *)nickname {
    return [ZRRegularExpressionValidateUtilsImp validateNickname:nickname];
}

//身份证号
+ (BOOL)validateIdentityCard:(NSString *)identityCard {
    return [ZRRegularExpressionValidateUtilsImp validateIdentityCard:identityCard];
}

@end
