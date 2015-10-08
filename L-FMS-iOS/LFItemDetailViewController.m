//
//  LFItemDetailViewController.m
//  L-FMS-iOS
//
//  Created by 虎猫儿 on 15/10/8.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import "LFItemDetailViewController.h"

#import "LFCommon.h"

@interface LFItemDetailViewController ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UILabel *tagsLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation LFItemDetailViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad] ;

    self.nameLabel.text = _item.name ;
    self.descLabel.text = _item.itemDescription ;
    self.tagsLabel.text = [_item.tags componentsJoinedByString:@","] ;
    if ( _item.image ) {
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:_item.image.url]
                          placeholderImage:[UIImage imageNamed:@"testAvatar1"]] ;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning] ;
}

#pragma mark - getter && setter

@end
