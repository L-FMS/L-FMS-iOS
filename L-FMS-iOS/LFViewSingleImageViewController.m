//
//  LFViewSingleImageViewController.m
//  L-FMS-iOS
//
//  Created by 虎猫儿 on 15/10/13.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import "LFViewSingleImageViewController.h"
#import <Masonry/Masonry.h>
#import <SDWebImage/UIImageView+WebCache.h>

@interface LFViewSingleImageViewController ()

@property (nonatomic,strong) UIImage *displayedImage;
@property (nonatomic,copy) NSString *imageUrl;

@property (nonatomic,strong) UIImageView *imageView;

@end

@implementation LFViewSingleImageViewController

+ (void)from:(UIViewController *)handleVC zoomInImage:(UIImage *)image {
    LFViewSingleImageViewController *vc = [[LFViewSingleImageViewController alloc] init];
    vc.displayedImage = image;
    [handleVC presentViewController:vc animated:YES completion:^{
    }];
}

+ (void)from:(UIViewController *)handleVC zoomInUrl:(NSString *)url {
    LFViewSingleImageViewController *vc = [[LFViewSingleImageViewController alloc] init];
    vc.imageUrl = url;
    [handleVC presentViewController:vc animated:YES completion:^{
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.imageView];
    
    self.view.backgroundColor = [UIColor blackColor];
    self.view.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] init];
    [tapGes addTarget:self action:@selector(roomOut)];
    [self.view addGestureRecognizer:tapGes];
    
    if (self.displayedImage) {
        self.imageView.image = self.displayedImage;
        [self.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.and.bottom.equalTo(self.view);
        }];
    }
    
    if (self.imageUrl) {
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.imageUrl]
                          placeholderImage:nil];
        [self.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view.mas_centerX);
            make.centerY.equalTo(self.view.mas_centerY);
            make.width.lessThanOrEqualTo(self.view.mas_width);
            make.height.lessThanOrEqualTo(self.view.mas_height);
        }];
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - getter && setter 

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
    }
    return _imageView;
}

#pragma mark - actions 

- (void)roomOut {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:^{
    }];
}

@end
