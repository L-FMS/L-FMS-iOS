//
//  LFItemDetailInformationTableViewCell.h
//  L-FMS-iOS
//
//  Created by 虎猫儿 on 15/10/11.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LFItemDetailInformationTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *itemNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *finishImageView;
@property (weak, nonatomic) IBOutlet UILabel *itemDescriptionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *itemImageView;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;

@end
