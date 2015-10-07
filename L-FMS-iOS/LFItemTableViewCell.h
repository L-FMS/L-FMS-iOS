//
//  LFItemTableViewCell.h
//  L-FMS-iOS
//
//  Created by 虎猫儿 on 15/10/7.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LFItemTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *ItemDescriptionLabel ;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel ;
@property (weak, nonatomic) IBOutlet UIImageView *descImageView;

@end
