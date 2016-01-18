//
//  LFItemSurveyView.m
//  L-FMS-iOS
//
//  Created by 虎猫儿 on 15/10/8.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import "LFItemSurveyView.h"

#import "LFCommonDefine.h"
#import <Masonry/Masonry.h>

#define kLFItemSurveyViewHeight 60.0f

@interface LFItemSurveyView () {
    CGSize _intrinsicContentSize;
}

@end

@implementation LFItemSurveyView

#pragma mark - Class method

+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

#pragma mark - Init

- (instancetype)init {
    if (self = [super init]) {
        [self setUp];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setUp];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUp];
    }
    return self;
}

- (void)setUp {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selfClicked:) ];
        [self addGestureRecognizer:tapGes];
    });
    _intrinsicContentSize = CGSizeMake(UIViewNoIntrinsicMetric, kLFItemSurveyViewHeight);
    self.backgroundColor = LFRGB(233, 233, 233);
    [self.layer setBorderWidth:1.0f];
    [self.layer setBorderColor:[LFRGB(233, 233, 233) CGColor]];
    self.userInteractionEnabled = YES;
    
    [self addSubview:self.imageView];
    [self addSubview:self.nameLabel];
    [self addSubview:self.contentLabel];
    
    LFWEAKSELF
    [self.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.equalTo(weakSelf);
        make.width.and.height.mas_equalTo(60.0f);
    }];
    self.imageView.clipsToBounds = YES;
    
    [self.nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.imageView.mas_right).with.offset(10.0f);
        make.top.equalTo(weakSelf.mas_top).with.offset(10.0f);
    }];
    
    [self.contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.nameLabel);
        make.top.equalTo(weakSelf.nameLabel.mas_bottom).with.offset(5.0f);
    }];
    
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(kLFItemSurveyViewHeight);
    }];
}

#pragma mark - getter && setter 

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
    }
    return _imageView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        [_nameLabel setNumberOfLines:1];
        _nameLabel.font = [UIFont systemFontOfSize:12.0f];
    }
    return _nameLabel;
}

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        [_contentLabel setNumberOfLines:2];
        _contentLabel.font = [UIFont systemFontOfSize:9.0f];
        _contentLabel.textColor = LFRGB(110, 110, 112);
    }
    return _contentLabel;
}

#pragma mark - size 

- (CGSize)intrinsicContentSize {
    return _intrinsicContentSize;
}

#pragma mark - IBActions 

- (void)selfClicked:(UITapGestureRecognizer *)tapGes {
    QYDebugLog(@"23333");
}

@end
