//
//  LFItemDetailViewController.m
//  L-FMS-iOS
//
//  Created by 虎猫儿 on 15/10/8.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import "LFItemDetailViewController.h"
#import "LFWriteCommentViewController.h"
#import "LFCheckItemAtMapViewController.h"
#import "LFUserMainPageTableViewController.h"
#import "LFChatRoomViewController.h"

#import "LFToolBarView.h"
#import "LFCommon.h"
#import "LFIMClient.h"
#import "LFStorage.h"

#import "LFItemDetailTagsTableViewCell.h"
#import "LFItemDetailInformationTableViewCell.h" 
#import "LFItemDetailCommentNavTableViewCell.h"
#import "LFitemDetailCommentTableViewCell.h"
#import "LFItemDetailUserInfoTableViewCell.h"
#import "LFItemDetailSeparateTableViewCell.h"


#import "AppDelegate.h"

#import "LFCommentActionSheet.h"

#define kItemDetailVC2WriteCommentVCSegueId @"itemDetailVC2WriteCommentVCSegueId"
#define kItemDetailVC2CheckItemAtMapVCSegueId @"ItemDetailVC2CheckItemAtMapVCSegueId"
#define kItemDetailVC2UserMainPageVC @"itemDetailVC2UserMainPageVC"

#import "LFViewSingleImageViewController.h"

@interface LFItemDetailViewController ()<LFToolBarViewDelegate,LFToolBarViewDataSource,UITableViewDelegate,UITableViewDataSource,LFWriteCommentViewControllerDelegate,UIActionSheetDelegate,LFItemDetailInformationTableViewCellDelegate> {
    NSArray *_titles;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong ,nonatomic) UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet LFToolBarView *toolBarView;

@property (nonatomic,strong) NSMutableArray *comments;
@property (nonatomic,strong) NSMutableDictionary *commentsDic;


@property (nonatomic,weak) LFIMClient *IM;
@property (nonatomic,weak) LFStorage *storage;

@end

@implementation LFItemDetailViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.IM = [LFUser currentUser].imClient;
    self.storage = [LFStorage shareInstance];

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
//    self.nameLabel.text = _item.name;
//    self.descLabel.text = _item.itemDescription;
//    self.tagsLabel.text = [_item.tags componentsJoinedByString:@","];
//    if (_item.image) {
//        [self.imageView sd_setImageWithURL:[NSURL URLWithString:_item.image.url]
//                          placeholderImage:[UIImage imageNamed:@"testAvatar1"]];
//    }
    
    self.toolBarView.delegate = self;
    self.toolBarView.dataSource = self;
    
    NSString *mailStr = [@"私信" stringByAppendingString:self.item.isLost ? @"失主": @"拾者"];
    _titles = @[@"评论",mailStr];
    self.title = self.item.isLost ? @"我丢了东西" : @"我捡到了东西";
    [self.toolBarView reloadData];
    
    [self.tableView addSubview:self.refreshControl];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - actions 

- (void)toUserMainPage:(LFUser *)user {
    if (!user) return;
    [self performSegueWithIdentifier:kItemDetailVC2UserMainPageVC sender:user];
}

- (void)showActionSheetForComment:(LFComment *)comment {
    if (!comment) return;
    
    LFCommentActionSheet *actionSheet = [[LFCommentActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"回复", nil];
    actionSheet.comment = comment;
    actionSheet.delegate = self;
    
    [actionSheet showInView:self.view];
}

- (void)replyToComments:(LFComment *)comment {
    if (!comment) return;
    
    LFWriteCommentViewController *vc = [AppDelegate getViewControllerById:@"LFWriteCommentViewControllerSBID"];
    vc.delegate = self;
    vc.targetItem = comment.item;
    vc.targetUser = comment.author;
    NSString *name = comment.author.displayName;
    vc.placeHolderString = [NSString stringWithFormat:@"回复：%@",name];
    
    [self presentViewController:vc animated:YES completion:^{
    }];
}

- (void)toLocationViewController {
    if (!self.item.location) return;
    CLLocation *location = [[CLLocation alloc] initWithLatitude:self.item.location.latitude longitude:self.item.location.longitude];
    [self performSegueWithIdentifier:kItemDetailVC2CheckItemAtMapVCSegueId sender:location];
}

- (void)showItemImage {
    if (!self.item.image) return;
//    [LFViewSingleImageViewController from:self zoomInImage:[UIImage imageNamed:@"testChatRoomBackgroundImg"]];
    [LFViewSingleImageViewController from:self zoomInUrl:self.item.image.url];
}


#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ([actionSheet isKindOfClass:[LFCommentActionSheet class]]) {
        //评论
        LFCommentActionSheet *commentAS = (id)actionSheet;
        LFComment *comment = commentAS.comment;
        commentAS.comment = nil;
        if (buttonIndex != commentAS.cancelButtonIndex) {
            //评论
            [self replyToComments:comment];
        }
    }
}

#pragma mark - LFItemDetailInformationTableViewCellDelegate

//点击了位置
- (void)itemCellDidClickedLocation:(LFItemDetailInformationTableViewCell *)cell {
    [self toLocationViewController];
}

//点击了图片
- (void)itemCellDidClickedImage:(LFItemDetailInformationTableViewCell *)cell {
    [self showItemImage];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    
    if (row <= 5) {
        //Item+(分割)+User+(分割)+Tag+(分割)
        BOOL isSeparate = row % 2;
        row = row / 2;
        if (!isSeparate) {
            if (1 == row) {
                //User
                LFUser *user = self.item.user;
                [self toUserMainPage:user];
            }
        }
    } else {
        row -= 7;
        
        LFComment *comment = self.comments[row];
        [self showActionSheetForComment:comment];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //Item+(分割)+User+(分割)+Tag+(分割)+评论Nav+评论*N
    NSInteger row = indexPath.row;
    
    if (row <= 5) {
        //Item+(分割)+User+(分割)+Tag+(分割)
        BOOL isSeparate = row % 2;
        row = row / 2;
        if (isSeparate) {
            //分割
            return 10.0f;
            
        } else {
            //Item + User + Tag
            switch (row) {
                case 0 : {
                    //Item
#warning 计算的高度！
                    return 180;
                    break;
                }
                    
                case 1 : {
                    //User
                    return 70;
                    break;
                }
                    
                default : {
                    //Tag
#warning 计算的高度！
                    return 44;
                    
                    break;
                }
            }
            
        }
        
        
    } else {
        //评论Nav+评论*N
        row -= 6;
        
        if (row == 0) {
            //评论Nav
            return 30;
            
        } else {
            row -= 1;
            //评论
#warning 计算的高度
            return 120;
        }
        
    }
    return 44;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3 * 2 + 1 + self.comments.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //Item+(分割)+User+(分割)+Tag+(分割)+评论Nav+评论*N
    
    
    NSInteger row = indexPath.row;
    if (row <= 5) {
        //Item+(分割)+User+(分割)+Tag+(分割)
        BOOL isSeparate = row % 2;
        row = row / 2;
        if (isSeparate) {
            //分割
            LFItemDetailSeparateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LFItemDetailSeparateTableViewCellReuseId" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
            
        } else {
            //Item + User + Tag
            switch (row) {
                case 0 : {
                    //Item
                    LFItemDetailInformationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LFItemDetailInformationTableViewCellReuseId" forIndexPath:indexPath];
                    cell.iconImageView.image = self.item.isLost ? [UIImage imageNamed:@"Lost"] : [UIImage imageNamed:@"Found"];
                    
                    cell.itemNameLabel.text = self.item.name;
                    cell.timeLabel.text = [self getTimeStrFromDate:self.item.createdAt];
                    cell.itemDescriptionLabel.text = self.item.itemDescription;
                    cell.locationLabel.text = self.item.place;
                    [cell.itemImageView sd_setImageWithURL:[NSURL URLWithString:self.item.image.url]
                                          placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
                    
                    cell.delegate = self;
                    return cell;
                    break;
                }
                    
                case 1 : {
                    //User[ok]
                    LFItemDetailUserInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LFItemDetailUserInfoTableViewCellReuseId" forIndexPath:indexPath];
                    cell.nameLabel.text = self.item.user.displayName;
                    cell.emailOrTelLabel.text = self.item.user.mobilePhoneNumber ? : self.item.user.email ? : @"暂无联系方式";
                    [cell.avatarImageView sd_setImageWithURL:[NSURL URLWithString:self.item.user.avatar.url]
                                            placeholderImage:[UIImage imageNamed:@"testAvatar1"]];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    return cell;
                    
                    break;
                }
                    
                default : {
                    //Tag[ok]
                    LFItemDetailTagsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LFItemDetailTagsTableViewCellReuseId" forIndexPath:indexPath];
                    cell.tagsLabel.text = [self.item.tags componentsJoinedByString:@","];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    return cell;
                    
                    break;
                }
            }
            
        }
        
        
    } else {
        //评论Nav+评论*N
        row -= 6;
        
        if (0 == row) {
            //评论Nav
            LFItemDetailCommentNavTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LFItemDetailCommentNavTableViewCellReuseId" forIndexPath:indexPath];
            NSString *commentCount = @"评论";
            
            if (self.comments.count) {
                commentCount = [commentCount stringByAppendingString:[NSString stringWithFormat:@" %lu",(unsigned long)self.comments.count]];
            }
            
            cell.commentCountLabel.text = commentCount;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
            
        } else {
            row -= 1;
            //评论
            LFComment *comment = self.comments[row];
            
            LFitemDetailCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LFitemDetailCommentTableViewCellReuseId" forIndexPath:indexPath];
            cell.nameLabel.text = comment.author.displayName;
            cell.timeLabel.text = [self getTimeStrFromDate:comment.createdAt];
            [cell.avatarImageView sd_setImageWithURL:[NSURL URLWithString:comment.author.avatar.url]
                                    placeholderImage:[UIImage imageNamed:@"testAvatar1"]];
            
            
            NSString *content = comment.content;
            if (comment.replyTo) {
                content = [NSString stringWithFormat:@"回复:%@ %@",comment.replyTo.displayName,content];
            }
            cell.contentLabel.text = content;
            
            return cell;
        }
        
    }
    
    
    LFItemDetailUserInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LFItemDetailUserInfoTableViewCellReuseId" forIndexPath:indexPath];
    
    
    return cell;
}



#pragma mark - LFToolBarViewDelegate

- (void)toolBarView:(LFToolBarView *)toolBarView didSelectedItemAtIndex:(NSUInteger)index {
    switch (index) {
        case 0 : {
            //评论
            [self showCommentViewController];
            break;
        }
            
        case 1 : {
            //私信
            [self showMailBoxViewController];
            break;
        }
            
        default :
            break;
    }
}

#pragma mark - LFToolBarViewDataSource

- (NSUInteger)numberOfItemsInToolBarView:(LFToolBarView *)toolBarView {
    return _titles.count;
}

- (NSString *)toolBarView:(LFToolBarView *)toolBarView titleForItemAtIndex:(NSUInteger)index {
    return _titles[index];
}


#pragma mark - LFWriteCommentViewControllerDelegate

- (void)viewControllerDidCancel:(LFWriteCommentViewController *)viewcontroller {
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

- (void)viewController:(LFWriteCommentViewController *)viewcontroller shouldSendComent:(NSString *)comment {
    Item *item = self.item;
    
    LFUser *me = [LFUser currentUser];
    LFUser *replyedUser = viewcontroller.targetUser;
    LFUser *itemAuthor = item.user;
    
    //new
    LFComment *aComment = [LFComment object];
    aComment.content = comment;
    aComment.item = self.item;
    aComment.author = me;
    aComment.replyTo = replyedUser;
    
    NSArray *replyToUsers;
    //看item的主人 和 回复的人
    if (replyedUser) {
        
        if ([replyedUser.objectId isEqualToString:itemAuthor.objectId]) {
            replyToUsers = @[replyedUser];
        } else {
            replyToUsers = @[replyedUser,
                             itemAuthor];
        }
        
    } else {
        
        replyToUsers = @[itemAuthor];
        
    }
    
    aComment.replyToUsers = replyToUsers;
    LFWEAKSELF
    [aComment saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            [weakSelf addItemComments:@[aComment]];
        } else {
            QYDebugLog(@"发表评论错误 Error:[%@]",error);
        }
    }];
    
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}


#pragma mark - getter && setter

- (UIRefreshControl *)refreshControl {
    if (!_refreshControl) {
        _refreshControl = [[UIRefreshControl alloc] init];
        [_refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    }
    return _refreshControl;
}

- (NSMutableArray *)comments {
    return _comments ? : (_comments = [NSMutableArray array]);
}

- (void)setItem:(Item *)item {
    _item = item;
    
    //加载评论
    LFWEAKSELF
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        AVQuery *query = [LFComment query];
        [query whereKey:@"item" equalTo:_item];
        [query includeKey:@"author"];
//        [query includeKey:@"author.avatar"];
        [query includeKey:@"replyTo"];
        
        [query findObjectsInBackgroundWithBlock:^(NSArray *comments, NSError *error) {
            if (comments) {
                [weakSelf addItemComments:comments];
            } else {
                QYDebugLog(@"获取评论出错 Error:[%@]",error);
            }
        }];
    });
}

#pragma mark - actions 

- (void)refresh:(UIRefreshControl *)refreshControl {
    [refreshControl endRefreshing];
}

- (void)showCommentViewController {
    QYDebugLog(@"评论");
    [self performSegueWithIdentifier:kItemDetailVC2WriteCommentVCSegueId sender:self];
}

- (void)showMailBoxViewController {
    QYDebugLog(@"私信");
    
    [SVProgressHUD show];
    [self.IM startConversationWithUserId:self.item.user.objectId completion:^(AVIMConversation *conversation, NSError *error) {
        if (conversation) {
            [self.storage insertRoomWithConversationId:conversation.conversationId];
            AVIMTextMessage *message = [AVIMTextMessage messageWithText:@"你好" attributes:nil];
            
            [conversation sendMessage:message options:AVIMMessageSendOptionRequestReceipt callback:^(BOOL succeeded, NSError *error) {
                [SVProgressHUD dismiss];
                if (succeeded) {
                    [self.storage insertMessage:message];
                    [self toChatRoomWithConversation:conversation];
                    [[LFNotify shareInstance] postMessageNotify:nil];
                } else {
                    QYDebugLog(@"发送失败Error:[%@]",error);
                    [LFUtils alertError:error];
                }
            }];
        } else {
            [SVProgressHUD dismiss];
        }
    }];
    
}

- (void)toChatRoomWithConversation:(AVIMConversation *)conversation {
    if (!conversation) return;
    
    LFChatRoomViewController *vc = [[LFChatRoomViewController alloc] initWithConersation:conversation];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Helper 

- (NSString *)getTimeStrFromDate:(NSDate *)date {
    NSString *dateStr;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"M-d HH:mm"];
    dateStr = [formatter stringFromDate:date];
    return dateStr;
}

- (void)addItemComments:(NSArray *)comments {
    if (!comments) return;
    
    [comments enumerateObjectsUsingBlock:^(LFComment *comment, NSUInteger idx, BOOL *stop) {
        if (!self.commentsDic[comment.objectId]) {
            [self.commentsDic setObject:comment forKey:comment.objectId];
            [self.comments addObject:comment];
        }
    }];
    
    [self.tableView reloadData];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:kItemDetailVC2WriteCommentVCSegueId]) {
        //
        LFWriteCommentViewController *vc = segue.destinationViewController;
        vc.delegate = self;
        vc.targetItem = self.item;
        vc.targetUser = nil;
        vc.placeHolderString = nil;
        vc.delegate = self;
        return;
    }
    
    if ([segue.identifier isEqualToString:kItemDetailVC2CheckItemAtMapVCSegueId]) {
        //到地图
        LFCheckItemAtMapViewController *vc = segue.destinationViewController;
        vc.itemLocation = sender;
        vc.item = self.item;
        
        return;        
    }
    
    if ([segue.identifier isEqualToString:kItemDetailVC2UserMainPageVC]) {
        LFUserMainPageTableViewController *vc = segue.destinationViewController;
        vc.user = sender;        
        return;
    }
}

@end
