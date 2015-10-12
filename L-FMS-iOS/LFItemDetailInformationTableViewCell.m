//
//  LFItemDetailInformationTableViewCell.m
//  L-FMS-iOS
//
//  Created by 虎猫儿 on 15/10/11.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import "LFItemDetailInformationTableViewCell.h"

@interface LFItemDetailInformationTableViewCell ()

@end

@implementation LFItemDetailInformationTableViewCell

- (void)awakeFromNib {
    //LFItemDetailInformationTableViewCellReuseId
    
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] init] ;
    [tapGes addTarget:self action:@selector(imageClicked)] ;
    self.itemImageView.userInteractionEnabled = YES ;
    [self.itemImageView addGestureRecognizer:tapGes] ;
    
    tapGes = [[UITapGestureRecognizer alloc] init] ;
    [tapGes addTarget:self action:@selector(locationClicked)] ;
    self.locationLabel.userInteractionEnabled = YES ;
    [self.locationLabel addGestureRecognizer:tapGes] ;
    self.locationLabel.textColor = [UIColor blueColor] ;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated] ;
}

#pragma mark - actions 

- (void)imageClicked {
    if ( [self.delegate respondsToSelector:@selector(itemCellDidClickedImage:)]) {
        [self.delegate itemCellDidClickedImage:self] ;
    }
}

- (void)locationClicked {
    if ( [self.delegate respondsToSelector:@selector(itemCellDidClickedLocation:)]) {
        [self.delegate itemCellDidClickedLocation:self] ;
    }
}

@end
