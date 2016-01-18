//
//  UserInfoItemTableViewCell.m
//  L-FMS-iOS
//
//  Created by 虎猫儿 on 15/10/5.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import "UserInfoItemTableViewCell.h"

@interface UserInfoItemTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *itemTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *itemDetailLabel;


@end

@implementation UserInfoItemTableViewCell

- (void)setUpWithTitle:(NSString *)title detailDesc:(NSString *)detailDesc {
    self.itemTitleLabel.text = title ? : @"";
    self.itemDetailLabel.text = detailDesc ? : @"";
}

- (void)awakeFromNib {
    self.itemTitleLabel.text = @"";
    self.itemDetailLabel.text = @"";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
