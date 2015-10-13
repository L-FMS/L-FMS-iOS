//
//  LFCommentNoticeTableViewController.m
//  L-FMS-iOS
//
//  Created by 虎猫儿 on 15/10/8.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import "LFCommentNoticeTableViewController.h"
#import "LFWriteCommentViewController.h"
#import "LFItemDetailViewController.h"

#import "LFCommentTableViewCell.h"
#import "LFCommon.h"
#import "AppDelegate.h"

typedef struct {
    CGFloat lineNumber ;
    CGFloat contentHeight ;
} PYQContentInfo ;

#define kCommentNotice2WriteCommentVCSegueId @"CommentNotice2WriteCommentVCSegueId"

@interface LFCommentNoticeTableViewController ()<LFCommentTableViewCellDelegate,LFWriteCommentViewControllerDelegate> {
    NSInteger heightPerLine ;
    NSInteger containerWidth ;
}

@property (nonatomic,strong) NSMutableArray *dataSource ;//LFComment

@property (nonatomic,strong) UILabel *calculateHelperLabel ;


@property (nonatomic,strong) NSMutableArray *comments ;
@property (nonatomic,strong) NSMutableDictionary *commentsDic ;


@end

@implementation LFCommentNoticeTableViewController

#pragma mark - Life Cycle

//- (void)makeTestData {
//    {
//        //make demo data
//        LFComment *commet = [LFComment object] ;
//        commet.author = [LFUser currentUser] ;
//        commet.content = @"卧槽，测试啊\n卧槽啊，测试两行了" ;
//        Item *item = [Item object] ;
//        {
//            item.name = @"Test" ;
//            item.user = [LFUser currentUser] ;
//            item.itemDescription = @"卧槽，我捡到了扒拉扒拉" ;
//            //            item.image =
//        }
//        commet.item = item ;
//        
//        commet.cellHeight = @([self getCellHeightFrom:commet]) ;
//        
//        [self.dataSource addObject:commet] ;
//        [self.dataSource addObject:commet] ;
//    }
//}

- (void)viewDidLoad {
    [super viewDidLoad] ;
    
    [self calculateHeightPerLine] ;
    
//    [self makeTestData] ;
    
    [self.tableView registerClass:[LFCommentTableViewCell class] forCellReuseIdentifier:@"LFCommentTableViewCellReuseId"] ;
    self.refreshControl = [[UIRefreshControl alloc] init] ;
    [self.refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged] ;
    [self.tableView addSubview:self.refreshControl] ;
    
    [self refresh:nil] ;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning] ;
}


#pragma mark - actions

- (void)refresh:(UIRefreshControl *)refreshControl {

    AVQuery *commentQuery = [LFComment query] ;
    
    [commentQuery includeKey:@"author"] ;
    [commentQuery includeKey:@"item.user"] ;
    [commentQuery includeKey:@"replyToUsers"] ;
    [commentQuery whereKey:@"replyToUsers" containsAllObjectsInArray:@[[LFUser currentUser]]] ;    

    LFWEAKSELF
    [commentQuery findObjectsInBackgroundWithBlock:^(NSArray *comments, NSError *error) {
        [weakSelf.refreshControl endRefreshing] ;
        if ( comments ) {
            [weakSelf addItemComments:comments] ;
        } else {
            QYDebugLog(@"查找回复出错 Error:[%@]",error) ;
        }
    }] ;
    
}

- (void)toUserMainPage:(LFUser *)targetUser {
    if ( !targetUser ) return ;
#warning 下一步写
}

- (void)toItemDetailViewController:(Item *)item {
    if ( !item ) return ;
    
    LFItemDetailViewController *vc = [AppDelegate getViewControllerById:@"LFItemDetailViewControllerSBID"] ;
    vc.item = item ;
    [self.navigationController pushViewController:vc animated:YES] ;
}

#pragma mark - UITableViewDelegate 

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 8.0f ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    LFComment *comment = self.comments[indexPath.section] ;
    //= self.dataSource[indexPath.section] ;
    return [comment.cellHeight floatValue] ;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO] ;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.comments.count ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1 ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LFCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LFCommentTableViewCellReuseId"] ;
    if ( !cell ) {
        cell = [[LFCommentTableViewCell alloc] init] ;
    }
    
    cell.delegate = self ;
    [cell setUpWithLFComment:self.comments[indexPath.section]] ;
    cell.selectionStyle = UITableViewCellSelectionStyleNone ;
    
    return cell;
}


#pragma mark - LFCommentTableViewCellDelegate

//点击了回复
- (void)commentCellDidClickedReplyButton:(LFCommentTableViewCell *)cell {
    //
    [self performSegueWithIdentifier:kCommentNotice2WriteCommentVCSegueId sender:cell.comment] ;
}

//点击了头像
- (void)commentCellDidClickedUserAvatar:(LFCommentTableViewCell *)cell {
    [self toUserMainPage:cell.author] ;
}

//点击了ItemView
- (void)commentCellDidClickedItemView:(LFCommentTableViewCell *)cell {
    [self toItemDetailViewController:cell.item] ;
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ( [segue.identifier isEqualToString:kCommentNotice2WriteCommentVCSegueId] ) {
        LFWriteCommentViewController *vc = segue.destinationViewController ;
        vc.delegate = self ;
        LFComment *comment = sender ;
        vc.targetItem = comment.item ;
        vc.targetUser = comment.author ;
        NSString *name = comment.author.displayName ;
        vc.placeHolderString = [NSString stringWithFormat:@"回复：%@",name] ;
    }
}


#pragma mark - LFWriteCommentViewControllerDelegate

- (void)viewControllerDidCancel:(LFWriteCommentViewController *)viewcontroller {
    [self dismissViewControllerAnimated:YES completion:^{
    }] ;
}

- (void)viewController:(LFWriteCommentViewController *)viewcontroller shouldSendComent:(NSString *)comment {
    Item *item = viewcontroller.targetItem ;
    
    LFUser *me = [LFUser currentUser] ;
    LFUser *replyedUser = viewcontroller.targetUser ;
    LFUser *itemAuthor = item.user ;
    
    //new
    LFComment *aComment = [LFComment object] ;
    aComment.content = comment ;
    aComment.item = item ;
    aComment.author = me ;
    aComment.replyTo = replyedUser ;
    
    NSArray *replyToUsers ;
    
    //看item的主人和目标回复的人。
    if ( [itemAuthor.objectId isEqualToString:replyedUser.objectId]) {
        replyToUsers = @[itemAuthor] ;
    } else {
        replyToUsers = @[itemAuthor,
                         replyedUser] ;
    }
    aComment.replyToUsers = replyToUsers ;
    LFWEAKSELF
    [aComment saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if ( succeeded ) {
            [weakSelf addItemComments:@[aComment]] ;
        } else {
            QYDebugLog(@"发表评论错误 Error:[%@]",error) ;
        }
    }] ;
    
    [self dismissViewControllerAnimated:YES completion:^{
    }] ;
}


#pragma mark - getter && setter 

- (NSMutableArray *)dataSource {
    return _dataSource ? : (_dataSource = [NSMutableArray array] ) ;
}

- (UILabel *)calculateHelperLabel {
    return _calculateHelperLabel ?  : ( _calculateHelperLabel = [[UILabel alloc] init]) ;
}

- (NSMutableArray *)comments {
    return _comments ? : ( _comments = [NSMutableArray array] ) ;
}

- (NSMutableDictionary *)commentsDic {
    return _commentsDic ? : ( _commentsDic = [NSMutableDictionary dictionary] ) ;
}






#pragma mark - Helper 

#define CheckViewInSuperView(view,superView) if ( !view.superview ) { [superView addSubview:view] ; }

- (CGFloat)getCellHeightFrom:(LFComment *)comment {
    CGFloat contentHeight = [self calculateLineNumber:comment.content].contentHeight ;
    return (10) + 30 + (5) + contentHeight + (10) + 60 + (10) ;//括号中是间距
}

/**
 *  计算文本的高度和行数
 */
- (PYQContentInfo)calculateLineNumber:(NSString *)text {
    assert(text) ;
    PYQContentInfo info ;
    
    NSInteger lineNumber , contentHeight ;
    
    self.calculateHelperLabel.font = [UIFont systemFontOfSize:15.0] ;
    self.calculateHelperLabel.text = text ;
    self.calculateHelperLabel.numberOfLines = 100 ;
    
    LFWEAKSELF
    CheckViewInSuperView(self.calculateHelperLabel, self.view) ;
    
    [self.calculateHelperLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(containerWidth) ;
        make.top.equalTo(weakSelf.view.mas_bottom) ;
        make.left.equalTo(weakSelf.view.mas_left) ;
    }] ;
    
    [self.calculateHelperLabel layoutIfNeeded] ;
    contentHeight = CGRectGetHeight(self.calculateHelperLabel.frame) ;
    [self.calculateHelperLabel removeFromSuperview] ;
    //heightPerLine / 6 为误差阈值
    lineNumber = ( contentHeight + heightPerLine / 6  ) / heightPerLine ;
    
    info.contentHeight = contentHeight ;
    info.lineNumber = lineNumber ;
    return info ;
}

/**
 *  计算每行高度，宽度固定。
 */
- (void)calculateHeightPerLine {
    
    self.calculateHelperLabel.font = [UIFont systemFontOfSize:15.0] ;
    self.calculateHelperLabel.text = @"1\n2\n3\n4" ;
    NSInteger contentLineNumber = 4 ;
    self.calculateHelperLabel.numberOfLines = 100 ;
    
    LFWEAKSELF
    CheckViewInSuperView(self.calculateHelperLabel,self.view) ;
    
    containerWidth = CGRectGetWidth([[UIScreen mainScreen] bounds])  - (10.0f * 2) ;
    
    [self.calculateHelperLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(containerWidth) ;
        make.top.equalTo(weakSelf.view.mas_bottom) ;
        make.left.equalTo(weakSelf.view.mas_left) ;
    }] ;
    
    [self.calculateHelperLabel layoutIfNeeded] ;
    heightPerLine = CGRectGetHeight(self.calculateHelperLabel.frame) / contentLineNumber ;
    [self.calculateHelperLabel removeFromSuperview] ;
}

- (void)addItemComments:(NSArray *)comments {
    if ( !comments ) return ;
    
    [comments enumerateObjectsUsingBlock:^(LFComment *comment, NSUInteger idx, BOOL *stop) {
        if ( !self.commentsDic[comment.objectId]) {
            comment.cellHeight = @([self getCellHeightFrom:comment]) ;            
            [self.commentsDic setObject:comment forKey:comment.objectId] ;
            [self.comments addObject:comment] ;
        }
    }] ;
    
    [self.tableView reloadData] ;
}

@end
