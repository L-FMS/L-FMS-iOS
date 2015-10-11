//
//  LFToolBarView.m
//  L-FMS-iOS
//
//  Created by 虎猫儿 on 15/10/11.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import "LFToolBarView.h"

#import <Masonry/Masonry.h>
#import "LFCommonDefine.h"

#define kLineViewTagOffset 1000

@interface LFToolBarView ()

@end

@implementation LFToolBarView

- (void)reloadData {
    if ( self.dataSource ) {
        NSUInteger numberOfItem = [self.dataSource numberOfItemsInToolBarView:self] ;
        NSMutableArray *titles = [NSMutableArray array] ;
        for (NSInteger i = 0 ; i < numberOfItem ; i++ ) {
            [titles addObject:[self.dataSource toolBarView:self titleForItemAtIndex:i]] ;
        }
        [self setUpWithTitles:titles] ;
    }
}

#pragma mark - Helper

- (void)setUpWithTitles:(NSArray *)titles {
    UIView *left = self ;
    for ( int i = 0 ; i < titles.count ; i++ ) {
        UIButton *button = [self getAbuttonWithTitle:titles[i]] ;
        button.tag = i ;
        [self addSubview:button] ;
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside] ;
        
        [button mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.and.bottom.equalTo(self) ;
            make.width.equalTo(self.mas_width).multipliedBy(1.0f/titles.count) ;
            if ( i == 0 )
                make.left.equalTo(left.mas_left) ;
            else
                make.left.equalTo(left.mas_right) ;
        }] ;
        [self sendSubviewToBack:button] ;
        
        left = button ;
        
        //添加那条线
        if ( i == titles.count - 1 ) {
            //最后一个没有line
            break ;
        }
        
        NSUInteger lineViewTag = kLineViewTagOffset + i ;
        UIView *lineView = [self viewWithTag:lineViewTag] ;
        if ( !lineView ) {
            lineView = [[UIView alloc] init] ;
            lineView.tag = lineViewTag ;
            lineView.backgroundColor = LFRGB(199, 199, 199) ;
            [self addSubview:lineView] ;
        }
        //添加约束
        [lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(left.mas_right) ;
            make.centerY.equalTo(self.mas_centerY) ;
            make.height.equalTo(self.mas_height).multipliedBy(2.0f/3) ;
            make.width.mas_equalTo(1) ;
        }] ;
        
    }
}

- (UIButton *)getAbuttonWithTitle:(NSString *)title {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem] ;
    [button setTitle:title forState:UIControlStateNormal] ;
    [button setTitleColor:LFRGB(90, 90, 90)
                 forState:UIControlStateNormal] ;
    return button ;
}

//+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
//
//    CGRect rect = CGRectMake(0, 0, size.width, size.height) ;
//
//    UIGraphicsBeginImageContext(rect.size) ;
//
//    CGContextRef context = UIGraphicsGetCurrentContext() ;
//
//    CGContextSetFillColorWithColor(context, [color CGColor]) ;
//
//    CGContextFillRect(context, rect) ;
//
//    UIImage *image = UIGraphicsGetImageFromCurrentImageContext() ;
//
//    UIGraphicsEndImageContext() ;
//
//    return image ;
//}

#pragma mark - actions

- (void)buttonClicked:(UIButton *)sender {
    NSUInteger index = sender.tag ;
    if ( [self.delegate respondsToSelector:@selector(toolBarView:didSelectedItemAtIndex:)]) {
        [self.delegate toolBarView:self didSelectedItemAtIndex:index] ;
    }
}

@end
