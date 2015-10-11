//
//  LFToolBarView.h
//  L-FMS-iOS
//
//  Created by 虎猫儿 on 15/10/11.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LFToolBarViewDataSource ;
@protocol LFToolBarViewDelegate ;

@interface LFToolBarView : UIView

@property (weak) id<LFToolBarViewDelegate> delegate ;
@property (weak) id<LFToolBarViewDataSource> dataSource ;

- (void)reloadData ;

@end

@protocol LFToolBarViewDataSource <NSObject>

@required

- (NSUInteger)numberOfItemsInToolBarView:(LFToolBarView *)toolBarView ;
- (NSString *)toolBarView:(LFToolBarView *)toolBarView titleForItemAtIndex:(NSUInteger)index ;

@end

@protocol LFToolBarViewDelegate <NSObject>

@optional

- (void)toolBarView:(LFToolBarView *)toolBarView didSelectedItemAtIndex:(NSUInteger)index ;

@end
