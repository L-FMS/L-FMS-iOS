//
//  LFSettingSwitchTableViewCell.m
//  L-FMS-iOS
//
//  Created by 虎猫儿 on 15/10/12.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import "LFSettingSwitchTableViewCell.h"

@implementation LFSettingSwitchTableViewCell

- (void)awakeFromNib {
    //LFSettingSwitchTableViewCellReuseId
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (IBAction)switchStateChanged:(UISwitch *)sender {
    if ([self.delegate respondsToSelector:@selector(cell:switchToState:)]) {
        [self.delegate cell:self switchToState:sender.isOn];
    }
}


@end
