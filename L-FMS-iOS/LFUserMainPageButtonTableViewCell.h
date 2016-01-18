//
//  LFUserMainPageButtonTableViewCell.h
//  L-FMS-iOS
//
//  Created by 虎猫儿 on 15/10/13.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LFUserMainPageButtonTableViewCellDelegate;

@interface LFUserMainPageButtonTableViewCell : UITableViewCell

@property (weak) id<LFUserMainPageButtonTableViewCellDelegate> delegate;

@end

@protocol LFUserMainPageButtonTableViewCellDelegate <NSObject>

//点击了按钮

- (void)buttonCellDidClickedButton:(LFUserMainPageButtonTableViewCell *)cell;

@end
