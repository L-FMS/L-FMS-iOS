//
//  ZRRegularExpressionValidateUtils.h
//  L-FMS-iOS
//
//  Created by 虎猫儿 on 15/10/6.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#ifndef L_FMS_iOS_ZRRegularExpressionValidateUtils_h
#define L_FMS_iOS_ZRRegularExpressionValidateUtils_h

@protocol ZRRegularExpressionValidateUtils <NSObject>

//邮箱
+ (BOOL)validateEmail:(NSString *)email ;

//手机号码验证
+ (BOOL)validateMobile:(NSString *)mobile ;

//车牌号验证
+ (BOOL)validateCarNo:(NSString *)carNo ;

//车型
+ (BOOL)validateCarType:(NSString *)CarType ;

//用户名[大小写字母、0-9]6-20长度
+ (BOOL)validateUserName:(NSString *)name ;

//密码同用户名
+ (BOOL)validatePassword:(NSString *)passWord ;

//昵称
+ (BOOL)validateNickname:(NSString *)nickname ;

//身份证号
+ (BOOL)validateIdentityCard:(NSString *)identityCard ;

@end

#endif
