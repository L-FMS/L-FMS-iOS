//
//  LFLostAFoundTableViewCell.m
//  L-FMS-iOS
//
//  Created by 虎猫儿 on 15/10/11.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import "LFLostAFoundTableViewCell.h"

@interface LFLostAFoundTableViewCell ()

@end

@implementation LFLostAFoundTableViewCell

- (void)awakeFromNib {
    //LFLostAFoundTableViewCellReuseId
    [self.avatarImageView.layer setMasksToBounds:YES] ;
    [self.avatarImageView.layer setCornerRadius:25.0f/2] ;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated] ;
}

@end
