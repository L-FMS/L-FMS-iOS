//
//  LFMailBoxTableViewController.m
//  L-FMS-iOS
//
//  Created by 虎猫儿 on 15/10/3.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import "LFMailBoxTableViewController.h"
#import "LFMailBoxTableViewCell.h"
#import "LFMailBoxCommentTableViewCell.h"

#import "LFChatRoomViewController.h"
#import "AppDelegate.h"

#import "LFCommon.h"

#define LFMailBoxTableViewDefaultCellNumber 1

@interface LFMailBoxTableViewController ()

@property NSUInteger totalBadge ; //Badge总数

@property (nonatomic) NSMutableArray *rooms ;//LFChatRoom

@property (nonatomic, weak) LFStorage *storage ;
@property (nonatomic, weak) LFNotify *notify ;
@property (nonatomic, weak) LFIMClient *IM ;

@end

@implementation LFMailBoxTableViewController

- (void)viewDidLoad {
    [super viewDidLoad] ;
    
    self.refreshControl = [[UIRefreshControl alloc] init] ;
    [self.refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged] ;
    [self.tableView addSubview:self.refreshControl] ;
    
    self.rooms = [[self.storage getRooms] mutableCopy] ;
    
    [self.notify addMsgObserver:self selector:@selector(refresh)] ;
    [self refresh:nil] ;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated] ;
    [self.tabBarController.tabBar setHidden:NO] ;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning] ;
}

- (void)dealloc {
    [self.notify removeMsgObserver:self] ;
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60 ;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1 ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return LFMailBoxTableViewDefaultCellNumber + self.rooms.count ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row ;
    if ( row == 0 ) {
        //评论
        LFMailBoxCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LFMailBoxCommentTableViewCellReuseId" forIndexPath:indexPath] ;
        return cell ;
    } else {
        LFChatRoom *room = self.rooms[indexPath.row - 1] ;
        
        LFMailBoxTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LFMailBoxTableViewCellReuseId" forIndexPath:indexPath] ;
        cell.nameLabel.text = [room.conv title] ;
        
        if ( [room.lastMsg isKindOfClass:[AVIMTextMessage class]]) {
            cell.lastMessageLabel.text = room.lastMsg.text ;
        }
        
        if ( [room.lastMsg isKindOfClass:[AVIMAudioMessage class]] ) {
            cell.lastMessageLabel.text = @"[语音]" ;
        }
        
        if ( [room.lastMsg isKindOfClass:[AVIMImageMessage class]] ) {
            cell.lastMessageLabel.text = @"[图片]" ;
        }
        
        if ( [room.lastMsg isKindOfClass:[AVIMLocationMessage class]] ) {
            cell.lastMessageLabel.text = @"[坐标]" ;
        }
        
        {
            NSDate *timestamp = [LFUtils timestamp2date:room.lastMsg.sendTimestamp] ;
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
            [formatter setDateFormat:@"MM-dd HH:mm"] ;
            NSString *dateStr = [formatter stringFromDate:timestamp] ;
            cell.timeLabel.text = dateStr ;
        }
        
        
        [cell.avatarImageView setImage:[UIImage imageNamed:@"testAvatar1"]] ;
        return cell ;
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row ;
    if ( row == 0 ) {
        //到评论。
        QYDebugLog(@"到评论") ;
        UIViewController *vc = [AppDelegate getViewControllerById:@"LFCommentNoticeTableViewControllerSBID"] ;
        vc.hidesBottomBarWhenPushed = YES ;
        [self.navigationController pushViewController:vc animated:YES] ;
        
    } else {
        //到聊天界面。
        QYDebugLog(@"到聊天Room") ;
        LFChatRoom *room = self.rooms[indexPath.row - 1] ;
        LFChatRoomViewController *vc = [[LFChatRoomViewController alloc] initWithConersation:room.conv] ;
        vc.hidesBottomBarWhenPushed = YES ;
        [self.navigationController pushViewController:vc animated:YES] ;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES] ;
}

#pragma mark - refresh 

- (void)refresh {
    QYDebugLog(@"新消息") ;
    [self.refreshControl beginRefreshing] ;
    [self refresh:self.refreshControl] ;
}

- (void)refresh:(UIRefreshControl *)refreshControl {
    if ( ![self.IM isOpened] ) {
        [refreshControl endRefreshing] ;
        return ;
    }
    
    //是否是网络查询，还是查询缓存有control是网络查询（True）。没有是缓存查询（False）
    BOOL netWorkOnly = ( nil != refreshControl ) ;
    
    if ( !netWorkOnly ) {
        [self refreshByStorage] ;
        [refreshControl endRefreshing] ;
        return ;
    }
    
    //网络查询
    WEAKSELF
    [self.IM findConvsWithBlock:^(NSArray *convs, NSError *error) {
        QYDebugLog(@"Conversations:[%@]",convs) ;
        for ( AVIMConversation *conv in convs) {
            [self.storage insertRoomWithConversationId:conv.conversationId] ;
        }
        
        NSMutableArray *rooms = [[_storage getRooms] mutableCopy] ;
        
        [LFUtils showNetworkIndicator] ;
        [weakSelf.IM cacheAndFillRooms:rooms callback:^(BOOL succeeded, NSError *error) {
            [LFUtils hideNetworkIndicator] ;
            [refreshControl endRefreshing] ;
            
            if ( !error ) {
                weakSelf.rooms = rooms ;
                [weakSelf calculateUnreadCount:weakSelf.rooms] ;
                [weakSelf.tableView reloadData] ;
            }
        }] ;

    }] ;
}

/**
 *  从存储里拿数据
 */
- (void)refreshByStorage {
    QYDebugLog(@"本地刷新") ;
    NSMutableArray *rooms = [[self.storage getRooms] mutableCopy] ;
    self.rooms = rooms ;
    [self calculateUnreadCount:self.rooms] ;
    [self.tableView reloadData] ;
}

/**
 *  计算Unread数，并通知delegate
 *
 *  @param rooms CDRoom数组
 */
- (void)calculateUnreadCount:(NSArray *)rooms {
    NSInteger totalUnreadCount = 0 ;
    for ( LFChatRoom *room in _rooms) {
        totalUnreadCount += room.unreadCount ;
    }
    self.totalBadge = (NSUInteger)totalUnreadCount ;
    QYDebugLog(@"总共未读 %ld 条",(long)totalUnreadCount) ;
    [self.tabBarItem setBadgeValue:[NSString stringWithFormat:@"%lu",(unsigned long)self.totalBadge]] ;
}

#pragma mark - getter && setter

- (LFStorage *)storage {
    return _storage ? : ( _storage = [LFStorage shareInstance] ) ;
}

- (LFNotify *)notify {
    return _notify ? : ( _notify = [LFNotify shareInstance] ) ;
}

- (LFIMClient *)IM {
    return _IM ? : ( _IM = [LFUser currentUser].imClient ) ;
}

#pragma mark - test 

- (IBAction)chatWithTuo:(id)sender {
    NSString *k793951781UserId = @"5613a11360b2797950f9e1f3" ;
    NSString *k931713803UserId = @"5617d84760b28e98efff5b17" ;
    NSString *userId = [[LFUser currentUser].objectId isEqualToString:k793951781UserId] ? k931713803UserId : k793951781UserId ;
    
    [[LFUser currentUser].imClient startConversationWithUserId:userId completion:^(AVIMConversation *conversation, NSError *error) {
        if ( conversation ) {
            [self.storage insertRoomWithConversationId:conversation.conversationId] ;
            AVIMTextMessage *message = [AVIMTextMessage messageWithText:@"来玩啊" attributes:nil] ;
            
            [conversation sendMessage:message options:AVIMMessageSendOptionRequestReceipt callback:^(BOOL succeeded, NSError *error) {
                if ( succeeded ) {
                    [self.storage insertMessage:message] ;
                } else {
                    QYDebugLog(@"发送失败Error:[%@]",error) ;
                    [LFUtils alertError:error] ;
                }
            }] ;
        } else {
            QYDebugLog(@"建立会话失败Error:[%@]",error) ;
        }
    }] ;
}


@end
