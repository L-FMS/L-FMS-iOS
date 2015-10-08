//
//  LFCommentTableViewCell.h
//  L-FMS-iOS
//
//  Created by 虎猫儿 on 15/10/8.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LFComment ;

@protocol LFCommentTableViewCellDelegate <NSObject>

@end

@interface LFCommentTableViewCell : UITableViewCell

@property (weak) id<LFCommentTableViewCellDelegate> delegate ;

- (void)setUpWithLFComment:(LFComment *)comment ;

@end
