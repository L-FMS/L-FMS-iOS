//
//  LFCommentTableViewCell.m
//  L-FMS-iOS
//
//  Created by 虎猫儿 on 15/10/8.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import "LFCommentTableViewCell.h"
#import "LFItemSurveyView.h"
#import "LFCommon.h"

#import <Masonry/Masonry.h>

@interface LFCommentTableViewCell ()

@property (nonatomic,strong) UIImageView *avatarImageView ;
@property (nonatomic,strong) UILabel *nameLabel ;
@property (nonatomic,strong) UILabel *timeLabel ;
@property (nonatomic,strong) UIButton *replyButton ;
@property (nonatomic,strong) UILabel *commentLabel ;
@property (nonatomic,strong) LFItemSurveyView *itemSurveyView ;

@end

@implementation LFCommentTableViewCell

#pragma mark - Class method

+ (BOOL)requiresConstraintBasedLayout {
    return YES ;
}

#pragma mark - init

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

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ( self = [super initWithStyle:style reuseIdentifier:reuseIdentifier] ) {
        [self setUp] ;
    }
    return self ;
}

- (void)setUp {
    NSArray *subViews = @[self.avatarImageView,self.nameLabel,self.timeLabel,self.commentLabel,self.replyButton,self.itemSurveyView] ;
    [subViews enumerateObjectsUsingBlock:^(UIView *subView, NSUInteger idx, BOOL *stop) {
        [self addSubview:subView] ;
    }] ;
    [self.avatarImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.equalTo(self).with.offset(10.0f) ;
        make.width.and.height.mas_equalTo(30.0f) ;
    }] ;
    
    [self.nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.avatarImageView) ;
        make.left.equalTo(self.avatarImageView.mas_right).with.offset(5.0f) ;
    }] ;
    
    [self.timeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel) ;
        make.top.equalTo(self.nameLabel.mas_bottom).with.offset(1.0f) ;
    }] ;
    
    [self.replyButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).with.offset(10.0f) ;
        make.right.equalTo(self.mas_right).with.offset(-10.0f) ;
    }] ;
    
    [self.commentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.avatarImageView.mas_bottom).with.offset(5.0f) ;
        make.left.equalTo(self.avatarImageView.mas_left) ;
        make.right.equalTo(self.mas_right).with.offset(-10.0f) ;
    }] ;
    
    [self.itemSurveyView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.commentLabel.mas_bottom).with.offset(10.0f) ;
        make.left.equalTo(self.mas_left).with.offset(10.0f) ;
        make.right.equalTo(self.mas_right).with.offset(-10.0f) ;
    }] ;
    
}

- (void)awakeFromNib {
    //LFCommentTableViewCellReuseId
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated] ;
}

#pragma mark - getter && setter 

- (UIImageView *)avatarImageView {
    if ( !_avatarImageView ) {
        _avatarImageView = [[UIImageView alloc] init] ;
        _avatarImageView.image = [UIImage imageNamed:@"testAvatar1"] ;
        _avatarImageView.userInteractionEnabled = YES ;
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] init] ;
        [tapGes addTarget:self action:@selector(avatarClicked)] ;
        [_avatarImageView addGestureRecognizer:tapGes] ;
    }
    return _avatarImageView ;
}

- (UILabel *)nameLabel {
    if ( !_nameLabel ) {
        _nameLabel = [[UILabel alloc] init] ;
        _nameLabel.text = @"" ;
        _nameLabel.font = [UIFont systemFontOfSize:15.0f] ;
    }
    return _nameLabel ;
}

- (UILabel *)timeLabel {
    if ( !_timeLabel ) {
        _timeLabel = [[UILabel alloc] init] ;
        _timeLabel.text = @"" ;
        _timeLabel.font = [UIFont systemFontOfSize:10.0f] ;
        _timeLabel.textColor = LFRGB(110, 110, 112) ;        
    }
    return _timeLabel ;
}

- (UILabel *)commentLabel {
    if ( !_commentLabel ) {
        _commentLabel = [[UILabel alloc] init] ;
        _commentLabel.textAlignment = NSTextAlignmentLeft ;
        _commentLabel.text = @"" ;
        _commentLabel.font = [UIFont systemFontOfSize:15.0f] ;
        _commentLabel.textColor = [UIColor blackColor] ;
        [_commentLabel setNumberOfLines:100] ;
    }
    return _commentLabel ;
}

- (UIButton *)replyButton {
    if ( !_replyButton ) {
        _replyButton = [UIButton buttonWithType:UIButtonTypeCustom] ;
//        [_replyButton setTitle:@"回复" forState:UIControlStateNormal] ;
        [_replyButton setImage:[UIImage imageNamed:@"testReply"]
                      forState:UIControlStateNormal] ;
        [_replyButton setBounds:CGRectMake(0, 0, 52, 28)] ;
        _replyButton.backgroundColor = LFRGB(0, 0, 0) ;
        [_replyButton addTarget:self action:@selector(replyBtnClicked:) forControlEvents:UIControlEventTouchUpInside] ;
    }
    return _replyButton ;
}

- (LFItemSurveyView *)itemSurveyView {
    if ( !_itemSurveyView ) {
        _itemSurveyView = [[LFItemSurveyView alloc] init] ;
        _itemSurveyView.userInteractionEnabled = YES ;
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] init] ;
        [tapGes addTarget:self action:@selector(itemViewClicked)] ;
        [_itemSurveyView addGestureRecognizer:tapGes] ;
    }
    return _itemSurveyView ;
}

#pragma mark - Data Input 

- (void)setUpWithLFComment:(LFComment *)comment {
    self.comment = comment ;
    self.item = comment.item ;
    self.author = comment.author ;
    
    self.nameLabel.text = comment.author.displayName ;
    self.timeLabel.text = [LFUtils date2LongTimeStr:comment.createdAt?:[NSDate date]] ;
    self.commentLabel.text = comment.content ;
    self.itemSurveyView.nameLabel.text = comment.item.user.displayName ;
    self.itemSurveyView.contentLabel.text = comment.item.itemDescription ;
    AVFile *imageFile = comment.item.image ? : comment.item.user.avatar ;
    UIImage *placeholderImage = [UIImage zrScaleFromImage:[UIImage imageNamed:@"testAvatar1"] toSize:CGSizeMake(60, 60)] ;
    
    [self.itemSurveyView.imageView sd_setImageWithURL:[NSURL URLWithString:imageFile.url] placeholderImage:placeholderImage] ;
    self.itemSurveyView.imageView.contentMode = UIViewContentModeCenter ;
    
}

#pragma mark - IBActions

- (void)replyBtnClicked:(UIButton *)sender {
    if ( [self.delegate respondsToSelector:@selector(commentCellDidClickedReplyButton:)]) {
        [self.delegate commentCellDidClickedReplyButton:self] ;
    }
}

- (void)avatarClicked {
    if ( [self.delegate respondsToSelector:@selector(commentCellDidClickedUserAvatar:)]) {
        [self.delegate commentCellDidClickedUserAvatar:self] ;
    }
}

- (void)itemViewClicked {
    if ( [self.delegate respondsToSelector:@selector(commentCellDidClickedItemView:)]) {
        [self.delegate commentCellDidClickedItemView:self] ;
    }
}

@end
