//
//  LFWriteCommentViewController.h
//  L-FMS-iOS
//
//  Created by 虎猫儿 on 15/10/11.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LFWriteCommentViewControllerDelegate;

@interface LFWriteCommentViewController : UIViewController

@property (weak) id<LFWriteCommentViewControllerDelegate> delegate;

@property (nonatomic,copy) NSString *placeHolderString;

@property (nonatomic,strong) id targetItem;
@property (nonatomic,strong) id targetUser;

@end

@protocol LFWriteCommentViewControllerDelegate <NSObject>

@optional

- (void)viewControllerDidCancel:(LFWriteCommentViewController *)viewcontroller;

- (void)viewController:(LFWriteCommentViewController *)viewcontroller shouldSendComent:(NSString *)comment;

@end
