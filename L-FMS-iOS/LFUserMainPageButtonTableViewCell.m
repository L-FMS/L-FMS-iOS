//
//  LFUserMainPageButtonTableViewCell.m
//  L-FMS-iOS
//
//  Created by 虎猫儿 on 15/10/13.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import "LFUserMainPageButtonTableViewCell.h"

@interface LFUserMainPageButtonTableViewCell ()

@property (weak, nonatomic) IBOutlet UIButton *button;

@end

@implementation LFUserMainPageButtonTableViewCell

- (void)awakeFromNib {
    [self.button.layer setMasksToBounds:YES];
    [self.button.layer setCornerRadius:5.0f];
    [self.button addTarget:self action:@selector(buttonClicked) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

#pragma mark - actions 

- (void)buttonClicked {
    if ([self.delegate respondsToSelector:@selector(buttonCellDidClickedButton:)]) {
        [self.delegate buttonCellDidClickedButton:self];
    }
}

@end
