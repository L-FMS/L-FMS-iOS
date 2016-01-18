//
//  LFCommentTableViewCell.h
//  L-FMS-iOS
//
//  Created by 虎猫儿 on 15/10/8.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LFComment;
@class LFUser;
@class Item;

@protocol LFCommentTableViewCellDelegate;

@interface LFCommentTableViewCell : UITableViewCell

@property (weak) id<LFCommentTableViewCellDelegate> delegate;

- (void)setUpWithLFComment:(LFComment *)comment;

@property (weak) LFComment *comment;
@property (weak) LFUser *author;
@property (weak) Item *item;

@end

@protocol LFCommentTableViewCellDelegate <NSObject>

@optional

//点击了回复
- (void)commentCellDidClickedReplyButton:(LFCommentTableViewCell *)cell;

//点击了头像
- (void)commentCellDidClickedUserAvatar:(LFCommentTableViewCell *)cell;

//点击了ItemView
- (void)commentCellDidClickedItemView:(LFCommentTableViewCell *)cell;

@end