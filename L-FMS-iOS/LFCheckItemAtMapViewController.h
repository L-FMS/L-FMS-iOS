//
//  LFCheckItemAtMapViewController.h
//  L-FMS-iOS
//
//  Created by 虎猫儿 on 15/10/11.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CLLocation;
@class Item;

@interface LFCheckItemAtMapViewController : UIViewController

@property (nonatomic) CLLocation *itemLocation;

@property (nonatomic) Item *item;

@end
