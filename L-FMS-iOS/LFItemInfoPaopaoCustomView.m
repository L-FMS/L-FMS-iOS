//
//  LFItemInfoPaopaoCustomView.m
//  L-FMS-iOS
//
//  Created by 虎猫儿 on 15/10/12.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import "LFItemInfoPaopaoCustomView.h"

#import "LFCommon.h"

@interface LFItemInfoPaopaoCustomView ()

@property (nonatomic,strong) UILabel *itemNameLabel;
@property (nonatomic,strong) UILabel *locationLabel;
@property (nonatomic,strong) UILabel *itemDescrioptionLabel;
@property (nonatomic,strong) UIImageView *itemImageView;
@property (nonatomic,strong) UIButton *viewDetailButton;

@end

@implementation LFItemInfoPaopaoCustomView

- (instancetype)initWithItem:(Item *)item {
    if (self = [super init]) {
        [self setUpWithItem:item];
    }
    return self;
}

- (void)setUpWithItem:(Item *)item {
    if (!item) return;
    self.item = item;
    
    [self addSubview:self.itemNameLabel];
    self.itemNameLabel.text = [item.name stringByAppendingString:self.item.isLost?@"(我丢了东西)":@"(我捡到了东西)"];
    [self.itemNameLabel sizeToFit];
    
    [self addSubview:self.locationLabel];
    self.locationLabel.text = item.place;
    [self.locationLabel sizeToFit];
    
    [self addSubview:self.itemDescrioptionLabel];
    self.itemDescrioptionLabel.text = item.itemDescription;
    [self.itemDescrioptionLabel sizeToFit];
    
    [self addSubview:self.itemImageView];
    if (item.image) {
        [self.itemImageView sd_setImageWithURL:[NSURL URLWithString:item.image.url]
                              placeholderImage:[UIImage imageNamed:@"testMapIcon(Tabbar)"]];
    } else {
        self.itemImageView.hidden = YES;
    }
    //计算固有高度
    [self addSubview:self.viewDetailButton];
    [self.viewDetailButton sizeToFit];
    
    self.frame = CGRectMake(0, 0, 250, 120);
    [self.layer setCornerRadius:5.0f];
    [self.layer setBorderWidth:1.0f];
    [self.layer setBorderColor:[LFRGB(169, 183, 183) CGColor]];
    
    LFWEAKSELF
    [self.itemNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.mas_left).with.offset(5.0f);
        make.top.equalTo(weakSelf.mas_top).with.offset(5.0f);
    }];
    
    [self.locationLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.itemNameLabel.mas_left);
        make.top.equalTo(weakSelf.itemNameLabel.mas_bottom).with.offset(10.0f);
    }];

    [self.itemDescrioptionLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.locationLabel.mas_left);
        make.top.equalTo(weakSelf.locationLabel.mas_bottom).with.offset(10.0f);
        make.right.lessThanOrEqualTo(weakSelf.itemImageView.mas_left).with.offset(10.0f);
    }];
    
    [self.viewDetailButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.itemDescrioptionLabel.mas_left);
        make.top.equalTo(weakSelf.itemDescrioptionLabel.mas_bottom).with.offset(10.0f);
    }];
    
    [self.itemImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.mas_right);
        make.top.equalTo(self.locationLabel);
        make.width.and.height.mas_equalTo(50.0f);
    }];
    
    self.backgroundColor = [UIColor whiteColor];
}

#pragma mark - getter && setter 

- (UILabel *)itemNameLabel {
    if (!_itemNameLabel) {
        _itemNameLabel = [[UILabel alloc] init];
        _itemNameLabel.font = [UIFont systemFontOfSize:15.0f];
    }
    return _itemNameLabel;
}

- (UILabel *)locationLabel {
    if (!_locationLabel) {
        _locationLabel = [[UILabel alloc] init];
        _locationLabel.font = [UIFont systemFontOfSize:12.0f];
    }
    return _locationLabel;
}

- (UILabel *)itemDescrioptionLabel {
    if (!_itemDescrioptionLabel) {
        _itemDescrioptionLabel = [[UILabel alloc] init];
        _itemDescrioptionLabel.font = [UIFont systemFontOfSize:12.0f];
    }
    return _itemDescrioptionLabel;
}

- (UIImageView *)itemImageView {
    if (!_itemImageView) {
        _itemImageView = [[UIImageView alloc] init];
        [_itemImageView.layer setBorderColor:[[UIColor blackColor] CGColor]];
        [_itemImageView.layer setBorderWidth:1.0f];
    }
    return _itemImageView;
}

- (UIButton *)viewDetailButton {
    if (!_viewDetailButton) {
        _viewDetailButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_viewDetailButton setTitle:@"详细信息" forState:UIControlStateNormal];
        [_viewDetailButton addTarget:self action:@selector(showDetailButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _viewDetailButton;
}

#pragma mark - actions 

- (void)showDetailButtonClicked {
    if ([self.delegate respondsToSelector:@selector(view:shouldShowItemDetail:)]) {
        [self.delegate view:self shouldShowItemDetail:self.item];
    }
}

@end
