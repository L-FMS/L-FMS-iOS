//
//  UserInformationViewController.m
//  L-FMS-iOS
//
//  Created by 虎猫儿 on 15/10/4.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import "UserInformationViewController.h"
#import "UserInfoItemTableViewCell.h"

#import "LFCommon.h"

@interface UserInformationViewController ()<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UIButton *lotoutButton;

@property (nonatomic) NSArray *titles ;

@end

@implementation UserInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad] ;
    
    [self.avatarImageView.layer setMasksToBounds:YES] ;
    [self.avatarImageView.layer setCornerRadius:self.avatarImageView.bounds.size.height/2] ;
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(avatarImageViewClicked:)] ;
    [self.avatarImageView addGestureRecognizer:tapGes] ;
    self.avatarImageView.userInteractionEnabled = YES ;

    self.title = @"账号信息" ;
    
    self.titles = @[@"昵称",@"地址",@"邮箱",@"学院",@"手机号",@"性别",@"生日"] ;
    
    [[LFUser currentUser] displayAvatarAtImageView:self.avatarImageView] ;
    
    [self.lotoutButton.layer setMasksToBounds:YES] ;
    [self.lotoutButton.layer setCornerRadius:5.0f] ;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated] ;
    [self.tabBarController.tabBar setHidden:YES] ;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning] ;
}

#pragma mark - UITableViewDataSource 

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1 ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titles.count ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseId = @"UserInfoItemTableViewCellReuseId" ;
    
    UserInfoItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId forIndexPath:indexPath] ;
    [cell setUpWithTitle:self.titles[indexPath.row] detailDesc:@"描述"] ;
    
    return cell ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60 ;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES] ;
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch ( buttonIndex ) {
        case 0 : {
            //拍照
            QYDebugLog(@"拍照") ;
            [LFUtils pickImageFromCameraAtController:self] ;
            break ;
        }
            
        case 1 : {
            QYDebugLog(@"从相册选择") ;
            [LFUtils pickImageFromPhotoLibraryAtController:self] ;
            break ;
        }
            
        case 2 : {
            
            break ;
        }
            
        default:
            break;
    }
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    QYDebugLog("选中了图片") ;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        UIImage *imageToSave = (UIImage *)[info objectForKey:UIImagePickerControllerEditedImage];
        
        imageToSave = [UIImage zrScaleFromImage:imageToSave toSize:CGSizeMake(100, 100)] ;
        NSData *imageData = UIImagePNGRepresentation(imageToSave) ;
        AVFile *avatarFile = [AVFile fileWithData:imageData] ;
        [avatarFile save] ;
        
        LFUser *currentUser = [LFUser currentUser] ;
        currentUser.avatar = avatarFile ;
        [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if ( succeeded ) {
                QYDebugLog(@"保存头像成功") ;
                //发通知改头像
            } else {
                QYDebugLog(@"保存头像失败 Error:[%@]",error) ;
            }
        }] ;
    });
    
    [picker dismissViewControllerAnimated:YES completion:nil] ;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    QYDebugLog(@"取消") ;
    [picker dismissViewControllerAnimated:YES completion:nil] ;
}

#pragma mark - IBActions 

- (void)avatarImageViewClicked:(id)sender {
    QYDebugLog(@"点击了头像，是自己能修改，别人就是查看图片") ;
    UIActionSheet *actionSheet = [self getAImagePickerActionSheet] ;
    
    [actionSheet showInView:self.view] ;
    
}

- (IBAction)logoffBtnClicked:(id)sender {
    [LFUser logOut] ;
    [LFUtils toLogin] ;
}

#pragma mark - Helper 

- (UIActionSheet *)getAImagePickerActionSheet {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"选取照片"
                                                             delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册选取", nil] ;
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque ;
    return actionSheet ;
}

@end