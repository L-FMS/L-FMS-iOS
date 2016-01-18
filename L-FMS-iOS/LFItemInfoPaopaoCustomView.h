//
//  LFItemInfoPaopaoCustomView.h
//  L-FMS-iOS
//
//  Created by 虎猫儿 on 15/10/12.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Item;
@protocol LFItemInfoPaopaoCustomViewDelegate;

@interface LFItemInfoPaopaoCustomView : UIView

@property (weak) id<LFItemInfoPaopaoCustomViewDelegate> delegate;
@property (weak) Item *item;

- (instancetype)initWithItem:(Item *)item;

@end

@protocol LFItemInfoPaopaoCustomViewDelegate <NSObject>

- (void)view:(LFItemInfoPaopaoCustomView *)view shouldShowItemDetail:(Item *)item;

@end