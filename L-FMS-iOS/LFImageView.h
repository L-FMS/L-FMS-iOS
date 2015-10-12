//
//  LFImageView.h
//  L-FMS-iOS
//
//  Created by 虎猫儿 on 15/10/10.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LFImageViewDelegate ;

@interface LFImageView : UIImageView

@property (weak) id<LFImageViewDelegate> delegate ;

- (void)set2PlaceHolderImage ;

@end

@protocol LFImageViewDelegate <NSObject>

- (void)imageViewDidDeleteImage:(LFImageView *)imageView ;

@end
