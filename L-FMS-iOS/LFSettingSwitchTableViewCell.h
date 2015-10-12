//
//  LFSettingSwitchTableViewCell.h
//  L-FMS-iOS
//
//  Created by 虎猫儿 on 15/10/12.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LFSettingSwitchTableViewCellDelegate ;

@interface LFSettingSwitchTableViewCell : UITableViewCell

@property (weak) id<LFSettingSwitchTableViewCellDelegate> delegate ;

@property (weak, nonatomic) IBOutlet UILabel *itemDescriptionLabel ;
@property (weak, nonatomic) IBOutlet UISwitch *itemSwitch ;

@end

@protocol LFSettingSwitchTableViewCellDelegate <NSObject>

- (void)cell:(LFSettingSwitchTableViewCell *)cell switchToState:(BOOL)on ;

@end
