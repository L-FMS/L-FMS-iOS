//
//  LFChatRoomViewController.m
//  L-FMS-iOS
//
//  Created by 虎猫儿 on 15/10/7.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import "LFChatRoomViewController.h"
#import <AVOSCloudIM/AVOSCloudIM.h>
#import "LFCommon.h"

//MessageDisplayKit
#import <MessageDisplayKit/XHDisplayTextViewController.h>
#import <MessageDisplayKit/XHDisplayMediaViewController.h>
#import <MessageDisplayKit/XHDisplayLocationViewController.h>
#import <MessageDisplayKit/XHAudioPlayerHelper.h>

//L && F
#import "LFCommon.h"
#import "LFIMClient.h"
#import "LFStorage.h"
#import "LFNotify.h"
#import "LFCacheService.h"


//Marco

#define ONE_PAGE_SIZE 20

@interface LFChatRoomViewController () <XHAudioPlayerHelperDelegate>

//AVIMConversation实例
@property (nonatomic, strong) AVIMConversation *conversation ;




//当前选中的Cell
@property (nonatomic, strong) XHMessageTableViewCell *currentSelectedCell ;

@property LFIMClient *IM ;

//是否正在加载Msg Flag
@property BOOL isLoadingMsg ;

/**
 *  message数组[Type : AVIMMessage]
 */
@property NSMutableArray *msgs ;

//存储
@property LFStorage *storage ;

//Notification
@property LFNotify *notify ;

@end






@implementation LFChatRoomViewController

#pragma mark - init 

- (instancetype)init {
    if ( self = [super init] ) {
        [self setUp] ;
    }
    return self ;
}

- (instancetype)initWithConersation:(AVIMConversation *)conv {
    if ( self = [super init] ) {
        self.conversation = conv ;
        [self setUp] ;
    }
    return self ;
}

- (void)setUp {
    // 配置输入框UI的样式
    self.allowsSendFace = NO ;
    self.isLoadingMsg = NO ;
    self.IM = [LFUser currentUser].imClient ;
    self.notify = [LFNotify shareInstance] ;
    self.storage = [LFStorage shareInstance] ;
}

#pragma mark - Life Cycle

- (void)setUpChatRoomBackgroundImage {
    if ( [LFUserDefaultService getChatRoomBackgroundSwitch] ) {
        UIImage *backgroundImage = [UIImage imageNamed:@"testChatRoomBackgroundImg"] ;
        UIImageView *backgroundView =[[UIImageView alloc] initWithImage:backgroundImage] ;
        backgroundView.contentMode = UIViewContentModeScaleAspectFill ;
        
        [self.messageTableView setBackgroundView:backgroundView] ;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad] ;
    [self setUpChatRoomBackgroundImage] ;
    
    self.messageInputView.inputTextView.placeHolder = @"发送文本消息" ;
    
    self.messageSender = [LFUser currentUser].name ;
    
    self.title = self.conversation.title ;
    
    [self.storage insertRoomWithConversationId:self.conversation.conversationId] ;
    [self.storage clearUnreadWithConvid:self.conversation.conversationId] ;
    [self.notify addMsgObserver:self selector:@selector(loadMessage)] ;
    
    [self loadMessagesWithLoadMore:NO] ;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated] ;
    //停止播放
    [[XHAudioPlayerHelper shareInstance] stopAudio] ;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated] ;
    [self.storage clearUnreadWithConvid:self.conversation.conversationId] ;
    
    [[XHAudioPlayerHelper shareInstance] setDelegate:nil] ;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning] ;
}

- (void)dealloc {
    [self.notify removeMsgObserver:self] ;
}


#pragma mark - Observer 

- (void)loadMessage {
    
}

#pragma mark - actions






#pragma mark - XHMessageTableViewCellDelegate

//点击cell的时候
- (void)multiMediaMessageDidSelectedOnMessage:(id<XHMessageModel>)message atIndexPath:(NSIndexPath *)indexPath onMessageTableViewCell:(XHMessageTableViewCell *)messageTableViewCell {
    UIViewController *disPlayViewController ;
    switch (message.messageMediaType) {
        case XHBubbleMessageMediaTypeVideo:
        case XHBubbleMessageMediaTypePhoto: {
            DLog(@"message : %@", message.photo) ;
            DLog(@"message : %@", message.videoConverPhoto) ;
            XHDisplayMediaViewController *messageDisplayTextView = [[XHDisplayMediaViewController alloc] init] ;
            messageDisplayTextView.message = message ;
            disPlayViewController = messageDisplayTextView ;
            break ;
        }
            break ;
        case XHBubbleMessageMediaTypeVoice: {
            DLog(@"message : %@", message.voicePath) ;
            // Mark the voice as read and hide the red dot.
            message.isRead = YES ;
            messageTableViewCell.messageBubbleView.voiceUnreadDotImageView.hidden = YES ;
            
            [[XHAudioPlayerHelper shareInstance] setDelegate:(id<NSFileManagerDelegate>)self] ;
            if (_currentSelectedCell) {
                [_currentSelectedCell.messageBubbleView.animationVoiceImageView stopAnimating] ;
            }
            if (_currentSelectedCell == messageTableViewCell) {
                [messageTableViewCell.messageBubbleView.animationVoiceImageView stopAnimating] ;
                [[XHAudioPlayerHelper shareInstance] stopAudio] ;
                self.currentSelectedCell = nil ;
            } else {
                self.currentSelectedCell = messageTableViewCell ;
                [messageTableViewCell.messageBubbleView.animationVoiceImageView startAnimating] ;
                [[XHAudioPlayerHelper shareInstance] managerAudioWithFileName:message.voicePath toPlay:YES] ;
            }
            break ;
        }
        case XHBubbleMessageMediaTypeEmotion:
            DLog(@"facePath : %@", message.emotionPath) ;
            break ;
        case XHBubbleMessageMediaTypeLocalPosition: {
            DLog(@"facePath : %@", message.localPositionPhoto) ;
            XHDisplayLocationViewController *displayLocationViewController = [[XHDisplayLocationViewController alloc] init] ;
            displayLocationViewController.message = message ;
            disPlayViewController = displayLocationViewController ;
            break ;
        }
        default:
            break ;
    }
    if (disPlayViewController) {
        [self.navigationController pushViewController:disPlayViewController animated:YES] ;
    }
}

//点击文本出现文本详细。
- (void)didDoubleSelectedOnTextMessage:(id<XHMessageModel>)message atIndexPath:(NSIndexPath *)indexPath {
    DLog(@"text : %@", message.text) ;
    XHDisplayTextViewController *displayTextViewController = [[XHDisplayTextViewController alloc] init] ;
    displayTextViewController.message = message ;
    [self.navigationController pushViewController:displayTextViewController animated:YES] ;
}

//点击头像
- (void)didSelectedAvatarOnMessage:(id<XHMessageModel>)message atIndexPath:(NSIndexPath *)indexPath {
    DLog(@"indexPath : %@", indexPath) ;
}

#pragma mark - XHAudioPlayerHelperDelegate

- (void)didAudioPlayerStopPlay:(AVAudioPlayer *)audioPlayer {
    if (!_currentSelectedCell) {
        return ;
    }
    [_currentSelectedCell.messageBubbleView.animationVoiceImageView stopAnimating] ;
    self.currentSelectedCell = nil ;
}



#pragma mark - XHMessageTableViewControllerDelegate


- (BOOL)shouldLoadMoreMessagesScrollToTop {
    return YES ;
}

//向前加载
- (void)loadMoreMessagesScrollTotop {
    [self loadMessagesWithLoadMore:YES] ;
}

/**
 * 发送文本消息的回调方法
 *
 * @param text   目标文本字符串
 * @param sender 发送者的名字
 * @param date   发送时间
 */
- (void)didSendText:(NSString *)text fromSender:(NSString *)sender onDate:(NSDate *)date {
    if( [text length] > 0 ) {
        AVIMTextMessage *message = [AVIMTextMessage messageWithText:text attributes:nil] ;
        [self sendMsg:message originFilePath:nil] ;
        [self finishSendMessageWithBubbleMessageType:XHBubbleMessageMediaTypeText] ;
    }
}

/**
 * 发送图片消息的回调方法
 *
 * @param photo  目标图片对象，后续有可能会换
 * @param sender 发送者的名字
 * @param date   发送时间
 */
- (void)didSendPhoto:(UIImage *)photo fromSender:(NSString *)sender onDate:(NSDate *)date {
    [self sendImage:photo] ;
    [self finishSendMessageWithBubbleMessageType:XHBubbleMessageMediaTypePhoto] ;
}

/**
 * 发送视频消息的回调方法
 *
 * @param videoPath 目标视频本地路径
 * @param sender    发送者的名字
 * @param date      发送时间
 */
- (void)didSendVideoConverPhoto:(UIImage *)videoConverPhoto videoPath:(NSString *)videoPath fromSender:(NSString *)sender onDate:(NSDate *)date {
    //    AVIMVideoMessage *sendVideoMessage=[AVIMVideoMessage messageWithText:nil attachedFilePath:videoPath attributes:nil] ;
    //    WEAKSELF
    //    [self.conversation sendMessage:sendVideoMessage callback:^(BOOL succeeded, NSError *error) {
    //        if([weakSelf filterError:error]){
    //            [weakSelf insertAVIMTypedMessage:sendVideoMessage] ;
    //            [weakSelf finishSendMessageWithBubbleMessageType:XHBubbleMessageMediaTypeVideo] ;
    //        }
    //    }] ;
}

/**
 * 发送语音消息的回调方法
 *
 * @param voicePath        目标语音本地路径
 * @param voiceDuration    目标语音时长
 * @param sender           发送者的名字
 * @param date             发送时间
 */
- (void)didSendVoice:(NSString *)voicePath voiceDuration:(NSString *)voiceDuration fromSender:(NSString *)sender onDate:(NSDate *)date {
    
    DLog(@"%@",voicePath) ;
    [self sendFileMsgWithPath:voicePath type:kAVIMMessageMediaTypeAudio] ;
}

///**
// * 地理位置
// */
//- (void)didSendGeoLocationsPhoto:(UIImage *)geoLocationsPhoto geolocations:(NSString *)geolocations location:(CLLocation *)location fromSender:(NSString *)sender onDate:(NSDate *)date {
//    XHMessage *geoLocationsMessage = [[XHMessage alloc] initWithLocalPositionPhoto:geoLocationsPhoto geolocations:geolocations location:location sender:sender timestamp:date] ;
////    geoLocationsMessage.avatarUrl = [self avatarUrlByClientId:sender] ;
//    [self addMessage:geoLocationsMessage] ;
//    [self finishSendMessageWithBubbleMessageType:XHBubbleMessageMediaTypeLocalPosition] ;
//}

/**
 * 是否显示时间轴Label的回调方法
 *
 * @param indexPath 目标消息的位置IndexPath
 *
 * @return 根据indexPath获取消息的Model的对象，从而判断返回YES or NO来控制是否显示时间轴Label
 */

- (BOOL)shouldDisplayTimestampForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row==0 || indexPath.row>=self.messages.count){
        return YES ;
    }else{
        XHMessage *message=[self.messages objectAtIndex:indexPath.row] ;
        XHMessage *previousMessage=[self.messages objectAtIndex:indexPath.row-1] ;
        NSInteger interval=[message.timestamp timeIntervalSinceDate:previousMessage.timestamp] ;
        if(interval>60*3){
            return YES ;
        }else{
            return NO ;
        }
    }
}

/**
 * 配置Cell的样式或者字体
 *
 * @param cell      目标Cell
 * @param indexPath 目标Cell所在位置IndexPath
 */
- (void)configureCell:(XHMessageTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
}

/**
 * 协议回掉是否支持用户手动滚动
 *
 * @return 返回YES or NO
 */
- (BOOL)shouldPreventScrollToBottomWhileUserScrolling {
    return YES ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    XHMessageTableViewCell *messageTableViewCell = (id)[super tableView:tableView cellForRowAtIndexPath:indexPath] ;
    messageTableViewCell.backgroundColor = [UIColor clearColor] ;
    messageTableViewCell.contentView.backgroundColor = [UIColor clearColor] ;
    
    return messageTableViewCell;
}


#pragma mark - Helper 

- (void)loadMessagesWithLoadMore:(BOOL)isLoadMore {
    if ( ![self.IM isOpened] ) {
        QYDebugLog(@"没有网络") ;
        return ;
    }
    
    if( _isLoadingMsg ) {
        WEAKSELF
        [LFUtils runAfterSecs:1.0 block:^{
            [weakSelf loadMessagesWithLoadMore:isLoadMore] ;
        }] ;
        return ;
    }
    
    _isLoadingMsg = YES ;
    WEAKSELF
    [LFUtils runInGlobalQueue:^{
        int64_t maxTimestamp = (((int64_t)[[NSDate date] timeIntervalSince1970]) + 10 ) *1000 ;
        int64_t timestamp ;
        NSUInteger limit = 0 ;
        NSString *messageId ;
        //默认加载 20 个
        limit = ONE_PAGE_SIZE ;
        
        //不加载更多消息
        if( NO == isLoadMore && self.msgs.count > ONE_PAGE_SIZE ){
            limit = self.msgs.count ;
        }
        
        //默认时间戳
        timestamp = maxTimestamp ;
        if ( YES == isLoadMore && self.messages.count > 0 ) {
            //如果是加载更多更新时间戳 和 MessageId
            XHMessage *firstMsg = self.messages[0] ;
            NSDate *date = firstMsg.timestamp ;
            timestamp = [date timeIntervalSince1970] * 1000 ;
            
            AVIMTypedMessage *msg = self.msgs[0] ;
            messageId = msg.messageId ;
        }
        
        //获取Messages
        NSMutableArray *messages ;
        if ( NO == isLoadMore ) {
            //本地获取
            messages = [[self.storage getMsgsWithConvid:self.conversation.conversationId
                                               maxTime:timestamp
                                                  limit:limit] mutableCopy] ;
            
        } else {
            //服务器拉取
            NSError *error ;
            NSArray *remoteMessages = [self.IM queryMsgsWithConv:self.conversation
                                                           msgId:messageId
                                                         maxTime:timestamp
                                                           limit:limit
                                                           error:&error] ;
            if ( error ) {
                [LFUtils alertError:error] ;
                
                return  ;
            }
            
            messages = [remoteMessages mutableCopy] ;
        }
        

#warning 废弃
        //    {
        //        NSMutableArray *msgs = [[_storage getMsgsWithConvid:self.conversation.conversationId maxTime:timestamp limit:limit] mutableCopy] ;
        //         注释上面一行，取消掉下面几行的注释，消息记录将从远程服务器获取
        //
        //        NSError *error ;
        //
        //        NSArray *arrayMsgs = [_IM queryMsgsWithConv:self.conversation msgId:msgId maxTime:timestamp limit:limit error:&error] ;
        //        if( error ){
        //            [SPUtils alertError:error] ;
        //            return ;
        //        }
        //        NSMutableArray *msgs = [arrayMsgs mutableCopy] ;
        //    }
        
        [self cacheMsgs:messages callback:^(BOOL succeeded, NSError *error) {
            
            [LFUtils runInMainQueue:^{
                
                if ( !error ) {
                    NSMutableArray *xhMessages = [[weakSelf getXHMessages:messages] mutableCopy] ;
                    if( NO == isLoadMore ){
                        weakSelf.messages = xhMessages ;
                        weakSelf.msgs = messages ;
                        [weakSelf.messageTableView reloadData] ;
                        [weakSelf scrollToBottomAnimated:NO] ;
                        _isLoadingMsg = NO ;
                    } else {
                        NSMutableArray *newMsgs = [NSMutableArray arrayWithArray:messages] ;
                        [newMsgs addObjectsFromArray:_msgs] ;
                        _msgs = newMsgs ;
                        [weakSelf insertOldMessages:xhMessages completion:^{
                            _isLoadingMsg = NO ;
                        }] ;
                    }
                }
                
            }] ;
            
        }] ;
        
        
    }] ;
}

/**
 * 缓存AVIMTypedMessage消息，如果msg时图片或者视频，就保存到本地Documentation/files/ 路径下,文件名是msg.messageId
 *
 * @param msgs     需要缓存的消息数组Array(AVIMTypedMessage)
 * @param callback 回调
 */
- (void)cacheMsgs:(NSArray *)msgs callback:(AVBooleanResultBlock)callback{
    __block NSMutableSet *userIds = [NSMutableSet set] ;
    for( AVIMTypedMessage *message in msgs ) {
        [userIds addObject:message.clientId] ;
        
        if ( kAVIMMessageMediaTypeImage == message.mediaType ||
             kAVIMMessageMediaTypeAudio == message.mediaType ) {
            //如果是图片或者音频

            NSString *path = [self getPathByObjectId:message.messageId] ;
            NSFileManager *manager = [NSFileManager defaultManager] ;
            if( [manager fileExistsAtPath:path] == NO ){
                NSData *data = [message.file getData] ;
                [data writeToFile:path atomically:YES] ;
            }
        }
    }
    
    [LFCacheService cacheUsersWithIds:userIds callback:callback] ;
}

/**
 * [同步]把AVIMTypedMessage数组转换成XHMessages数组
 *
 * @param msgs AVIMTypedMessage数组
 *
 * @return 转换成的XHMessages数组
 */
- (NSArray *)getXHMessages:(NSArray *)messages {
    NSMutableArray *xhMessages = [NSMutableArray array] ;
    for( AVIMTypedMessage *avMessage in messages ) {
        
        XHMessage *xhMessage = [self getXHMessageFromAVMessage:avMessage] ;
        
        if( xhMessage ){
            [xhMessages addObject:xhMessage] ;
        }
    }
    return xhMessages ;
}

- (NSDate*)getTimestampDate:(int64_t)timestamp{
    return [NSDate dateWithTimeIntervalSince1970:timestamp/1000] ;
}

- (XHMessage *)getXHMessageFromAVMessage:(AVIMTypedMessage *)avMessage {
    XHMessage *message ;
    AVIMMessageMediaType messageType = avMessage.mediaType ;
    
    LFUser *fromUser = [[LFCacheService shareInstance] getUserById:avMessage.clientId] ;
    
    NSDate *timestamp = [self getTimestampDate:avMessage.sendTimestamp] ;
    
    NSString *displayName = fromUser.name ;
    
    switch ( messageType ) {
        case kAVIMMessageMediaTypeText : {
            //文本
            AVIMTextMessage *textMessage = (AVIMTextMessage *)avMessage ;
            
            message = [[XHMessage alloc] initWithText:textMessage.text sender:displayName timestamp:timestamp] ;
            break ;
        }
        case kAVIMMessageMediaTypeImage : {
            //图片
            AVIMImageMessage *imageMessage = (AVIMImageMessage *)avMessage ;
            message = [[XHMessage alloc] initWithPhoto:nil thumbnailUrl:imageMessage.file.url originPhotoUrl:nil sender:displayName timestamp:timestamp] ;
            break ;
        }
        case kAVIMMessageMediaTypeAudio:{
            //音频
            NSError *error ;
            NSString *path = [self fetchDataOfMessageFile:avMessage.file fileName:avMessage.messageId error:&error] ;
            AVIMAudioMessage *audioMessage = (AVIMAudioMessage *)avMessage ;
            message = [[XHMessage alloc] initWithVoicePath:path voiceUrl:nil voiceDuration:[NSString stringWithFormat:@"%.1f",audioMessage.duration] sender:displayName timestamp:timestamp] ;
            break ;
        }
            
//        case kAVIMMessageMediaTypeVideo:{
//            //视频
//            AVIMVideoMessage *receiveVideoMessage=(AVIMVideoMessage*)typedMessage ;
//            NSString *format=receiveVideoMessage.format ;
//            NSError *error ;
//            NSString *path=[self fetchDataOfMessageFile:typedMessage.file fileName:[NSString stringWithFormat:@"%@.%@",typedMessage.messageId,format] error:&error] ;
//            message = [[XHMessage alloc] initWithVideoConverPhoto:[XHMessageVideoConverPhotoFactory videoConverPhotoWithVideoPath:path] videoPath:path videoUrl:nil sender:displayName timestamp:timestamp] ;
//            break ;
//        }
//        case kAVIMMessageMediaTypeLocation:{
//            AVIMLocationMessage *locationMsg = (AVIMLocationMessage *)typedMessage ;
//            UIImage *LocalPostionPhoto = [UIImage imageNamed:@"Fav_Cell_Loc"] ;
//            NSString *geoLocations = locationMsg.text ;
//            CLLocation *location = [[CLLocation alloc] initWithLatitude:locationMsg.latitude longitude:locationMsg.longitude] ;
//            message = [[XHMessage alloc] initWithLocalPositionPhoto:LocalPostionPhoto geolocations:geoLocations location:location sender:fromUser.username timestamp:timestamp] ;
//            break ;
//        }
            
        default : {
            message = [[XHMessage alloc] initWithText:@"未知消息" sender:displayName timestamp:timestamp] ;
            break ;
        }
    }
    
    //设置头像
    {
        message.sender = fromUser.name ;
        message.avatarUrl = fromUser.avatar.url ;
        message.avatar = message.avatarUrl ? [UIImage imageNamed:@"testAvatar1"] : nil ;
    }
    
    //设置message的bubbleMessageType
    if (avMessage.ioType == AVIMMessageIOTypeIn )
        message.bubbleMessageType = XHBubbleMessageTypeReceiving ;
    else
        message.bubbleMessageType = XHBubbleMessageTypeSending ;
    
    
    if (avMessage.status == AVIMMessageStatusSent) {
        avMessage.status = AVIMMessageStatusDelivered ;
    }
    
    return message ;
}

/**
 *  [同步]获取 path/files/ ＋ objectId 路径字符串
 *
 *  @param objectId 物品objectId
 *
 *  @return path/files/ ＋ objectId 路径字符串
 */
- (NSString *)getPathByObjectId:(NSString *)objectId {
    return [[self getFilesPath] stringByAppendingFormat:@"%@",objectId] ;
}

- (NSString *)getFilesPath {
    NSString *appPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] ;
    NSString *filesPath = [appPath stringByAppendingString:@"/files/"] ;
    NSFileManager *manager = [NSFileManager defaultManager] ;
    NSError *error ;
    BOOL isDir = YES ;
    if( [manager fileExistsAtPath:filesPath isDirectory:&isDir] ==NO ){
        [manager createDirectoryAtPath:filesPath withIntermediateDirectories:YES attributes:nil error:&error] ;
        if( error ){
            [NSException raise:@"error when create dir" format:@"error"];
        }
    }
    return filesPath ;
}

/**
 *  [同步]获取 path/files/ + temp temp路径字符串
 *
 *  @return path/files/ + temp temp路径字符串
 */
- (NSString*)tmpPath {
    return [[self getFilesPath] stringByAppendingFormat:@"tmp"];
}

//保存AVFile到本地，fileName ＝ fileName ; 返回，文件路径
- (NSString *)fetchDataOfMessageFile:(AVFile *)file fileName:(NSString*)fileName error:(NSError**)error {
    NSString *path = [[self getFilesPath] stringByAppendingString:fileName] ;
    NSData *data = [file getData:error] ;
    if( *error == nil ) {
        [data writeToFile:path atomically:YES] ;
    }
    return path ;
}

/**
 * [异步]发送AVIMTypedMessage消息的开始。发送成功之后，把tempPath的文件move到messageId相关的路径。
 *
 * @param msg  AVIMTypedMessage
 * @param path 文件路径
 */
- (void)sendMsg:(AVIMTypedMessage *)msg originFilePath:(NSString *)path {
    
    WEAKSELF
    [self.conversation sendMessage:msg options:AVIMMessageSendOptionRequestReceipt callback:^(BOOL succeeded, NSError *error) {
        if( error ){
            // 赋值一个临时的messageId，因为发送失败，messageId，sendTimestamp不能从服务端获取
            // resend 成功的时候再改过来
            msg.messageId = [weakSelf.IM uuid] ;
            msg.sendTimestamp = [[NSDate date] timeIntervalSince1970] * 1000 ;
        }
        if( path && error == nil ) {
            //move file to new Path
            NSString *newPath = [self getPathByObjectId:msg.messageId] ;
            NSError *error1 ;
            [[NSFileManager defaultManager] moveItemAtPath:path toPath:newPath error:&error1] ;
            DLog(@"%@",newPath) ;
        }
        
        [self.storage insertMessage:msg] ;

        [self loadMessagesWithLoadMore:NO] ;
    }] ;
}

/**
 * [同步]发送图片，并保存图片到本地temp路径。
 *
 * @param image 图片
 */
- (void)sendImage:(UIImage*)image{
    NSData *imageData = UIImageJPEGRepresentation(image, 0.6) ;
    NSString *path = [self tmpPath] ;
    
    NSError *error ;
    [imageData writeToFile:path options:NSDataWritingAtomic error:&error] ;
    if(error==nil){
        [self sendFileMsgWithPath:path type:kAVIMMessageMediaTypeImage] ;
    }else{
        [LFUtils alert:@"write image to file error"] ;
    }
}

/**
 * [同步]发送本地图片或者语音。
 *
 * @param path 原路径
 * @param type AVIMMessageMediaType
 */
- (void)sendFileMsgWithPath:(NSString*)path type:(AVIMMessageMediaType)type{
    AVIMTypedMessage *msg ;
    if(type==kAVIMMessageMediaTypeImage){
        msg=[AVIMImageMessage messageWithText:nil attachedFilePath:path attributes:nil] ;
    }else{
        msg=[AVIMAudioMessage messageWithText:nil attachedFilePath:path attributes:nil] ;
    }
    [self sendMsg:msg originFilePath:path] ;
}

@end
