//
//  LFActivityIndicatorLabel.m
//  L-FMS-iOS
//
//  Created by 虎猫儿 on 15/10/6.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import "LFActivityIndicatorLabel.h"

@interface LFActivityIndicatorLabel ()

@property (nonatomic,strong) UIActivityIndicatorView *indicatorView ;

@end

@implementation LFActivityIndicatorLabel

- (instancetype)init {
    if ( self = [super init] ) {
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

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if ( self = [super initWithCoder:aDecoder] ) {
        [self setUp] ;
    }
    return self ;
}

- (void)setUp {
    [self addSubview:self.indicatorView] ;
}

#pragma mark -

- (void)setText:(NSString *)text showIndicator:(BOOL)show {
    [self setText:text] ;
    [self showIndicator:show] ;
    [self sizeToFit] ;
}

- (void)showIndicator:(BOOL)show {
    if ( show )
        [self.indicatorView startAnimating] ;
    else
        [self.indicatorView stopAnimating] ;
}

#pragma mark - getter && setter 

- (UIActivityIndicatorView *)indicatorView {
    if ( !_indicatorView ) {
        _indicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(-25, 0, 20, 20)] ;
        [_indicatorView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray] ;
    }
    return _indicatorView ;
}

- (BOOL)isRefreshing {
    return [self.indicatorView isAnimating] ;
}

@end
