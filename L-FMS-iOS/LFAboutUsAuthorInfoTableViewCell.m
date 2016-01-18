//
//  LFAboutUsAuthorInfoTableViewCell.m
//  L-FMS-iOS
//
//  Created by 虎猫儿 on 15/10/12.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import "LFAboutUsAuthorInfoTableViewCell.h"

#import <Masonry/Masonry.h>

@interface LFAboutUsAuthorInfoTableViewCell ()

@property (weak, nonatomic) IBOutlet UIView *containerView;

@end

@implementation LFAboutUsAuthorInfoTableViewCell

- (void)awakeFromNib {
    //LFAboutUsAuthorInfoTableViewCellReuseId
    self.photoImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.photoImageView.clipsToBounds = YES;
    
    self.nameLabel.numberOfLines = 4;
    UILabel *descriptionLabel = self.descriptionLabel;
    [self.descriptionLabel removeFromSuperview];
    [self.containerView addSubview:self.descriptionLabel];
    
    [self.descriptionLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.and.right.equalTo(self.containerView);
    }];
    descriptionLabel = nil;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
