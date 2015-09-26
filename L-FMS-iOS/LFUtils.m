//
//  LFUtils.m
//  L-FMS-iOS
//
//  Created by 虎猫儿 on 15/9/26.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import "LFUtils.h"

#import "AppDelegate.h"

@implementation LFUtils

+ (void)alert:(NSString*)msg {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                        message:msg
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil] ;
    [alertView show] ;
}

+ (BOOL)alertError:(NSError *)error {
    if( error ){
        [self alert:[NSString stringWithFormat:@"%@",error]] ;
        return YES ;
    }
    return NO ;
}

#pragma mark - Indicator

+ (void)showNetworkIndicator {
    UIApplication *app = [UIApplication sharedApplication] ;
    app.networkActivityIndicatorVisible = YES ;
}

+ (void)hideNetworkIndicator{
    UIApplication *app = [UIApplication sharedApplication] ;
    app.networkActivityIndicatorVisible = NO ;
}

#pragma mark - async

+ (void)runInMainQueue:(void (^)())queue {
    dispatch_async(dispatch_get_main_queue(), queue) ;
}

+ (void)runInGlobalQueue:(void (^)())queue {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), queue) ;
}

+ (void)runAfterSecs:(float)secs block:(void (^)())block {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secs*NSEC_PER_SEC), dispatch_get_main_queue(), block) ;
}

#pragma mark - toMain && toRegiste && toLogin

+ (void)toMain {
    [[AppDelegate globalAppdelegate] toMain] ;
}

+ (void)toRegiste {
    [[AppDelegate globalAppdelegate] toRegiste] ;
}

+ (void)toLogin {
    [[AppDelegate globalAppdelegate] toLogin] ;
}

#pragma mark - NSDate && Timestamp

//时间转时间戳的方法:
+ (NSString *)date2timestampStr:(NSDate *)date {
    assert(date) ;
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970]];
    return timeSp ;
}
+ (NSTimeInterval)date2timestamp:(NSDate *)date {
    assert(date) ;
    return [date timeIntervalSince1970] ;
}

//时间戳转时间的方法
+ (NSDate *)timestampStr2date:(NSString *)timestamp {
    assert(timestamp) ;
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[timestamp longLongValue]] ;
    return confromTimesp ;
}
+ (NSDate *)timestamp2date:(NSTimeInterval)timestamp {
    assert(timestamp) ;
    return [NSDate dateWithTimeIntervalSince1970:timestamp] ;
}

+ (NSInteger)ageWithDateOfBirth:(NSDate *)date {
    // 出生日期转换 年月日
    NSDateComponents *components1 = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date] ;
    NSInteger brithDateYear  = [components1 year] ;
    NSInteger brithDateDay   = [components1 day] ;
    NSInteger brithDateMonth = [components1 month] ;
    
    // 获取系统当前 年月日
    NSDateComponents *components2 = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    NSInteger currentDateYear  = [components2 year] ;
    NSInteger currentDateDay   = [components2 day] ;
    NSInteger currentDateMonth = [components2 month] ;
    
    // 计算年龄
    NSInteger iAge = currentDateYear - brithDateYear - 1 ;
    if ((currentDateMonth > brithDateMonth) || (currentDateMonth == brithDateMonth && currentDateDay >= brithDateDay)) {
        iAge++;
    }
    return iAge ;
}


#pragma mark - UUID

/**
 *  生成一个UUID
 *
 *  @return 24位的UUID
 */
+ (NSString*)uuid {
    NSString *chars = @"abcdefghijklmnopgrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789" ;
    assert(chars.length == 62) ;
    int len = (int)chars.length ;
    NSMutableString* result = [[NSMutableString alloc] init] ;
    for(int i = 0 ; i < 24 ; i++ ){
        int p = arc4random_uniform(len) ;
        NSRange range = NSMakeRange(p, 1) ;
        [result appendString:[chars substringWithRange:range]] ;
    }
    return result ;
}

@end
