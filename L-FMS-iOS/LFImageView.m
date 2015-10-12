//
//  LFImageView.m
//  L-FMS-iOS
//
//  Created by 虎猫儿 on 15/10/10.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import "LFImageView.h"

#import <Masonry/Masonry.h>
#import "LFCommon.h"

@interface LFImageView ()

@property (nonatomic,strong) UIImage *placeHolderImage ;

@property (nonatomic,strong) UIButton *xButton ;

@end

@implementation LFImageView

- (instancetype)init {
    if ( self = [super init] ) {
        [self setUp] ;
    }
    return self ;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if ( self = [super initWithCoder:aDecoder] ) {
        [self setUp] ;
    }
    return self ;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if ( self = [super initWithFrame:frame] ) {
        [self setUp] ;
    }
    return self ;
}

- (instancetype)initWithImage:(UIImage *)image {
    if ( self = [super initWithImage:image]) {
        [self setUp] ;
    }
    return self ;
}

- (void)setUp {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self addSubview:self.xButton] ;
        LFWEAKSELF
        [self.xButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.and.right.equalTo(weakSelf) ;
            make.width.and.height.mas_equalTo(19.0f) ;
        }] ;
        [self.xButton addTarget:self action:@selector(deleteBtnClicked) forControlEvents:UIControlEventTouchUpInside] ;
        [self.xButton setHidden:YES] ;
    });
}

#pragma mark - getter && setter 

- (UIImage *)placeHolderImage {
    return _placeHolderImage ? : ( _placeHolderImage = [UIImage imageNamed:@"testAdd"]) ;
}

- (void)setImage:(UIImage *)image {
    [super setImage:image] ;
    [self.xButton setHidden:NO] ;
}

- (UIButton *)xButton {
    if ( !_xButton ) {
        _xButton = [UIButton buttonWithType:UIButtonTypeCustom] ;
        [_xButton setImage:[UIImage imageNamed:@"testX"]
                  forState:UIControlStateNormal] ;
    }
    return _xButton ;
}

- (void)set2PlaceHolderImage {
    [super setImage:self.placeHolderImage] ;
    [self.xButton setHidden:YES] ;
}

- (void)deleteBtnClicked {
    [self set2PlaceHolderImage] ;
    if ( [self.delegate respondsToSelector:@selector(imageViewDidDeleteImage:)] ) {
        [self.delegate imageViewDidDeleteImage:self] ;
    }
}

@end
