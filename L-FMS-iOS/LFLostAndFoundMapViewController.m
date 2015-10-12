//
//  LFLostAndFoundViewController.m
//  L-FMS-iOS
//
//  Created by 虎猫儿 on 15/10/3.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import "LFLostAndFoundMapViewController.h"
#import "LFItemDetailViewController.h"

#import "LFItemInfoPaopaoCustomView.h"
#import "LFBMKMapViewAnnotation.h"
#import "LFItemAnnotationView.h"

#import "LFLostAFoundTableViewCell.h"

#import "AppDelegate.h"

#import "LFCommon.h"
#import "LFBaiduMapKit.h"
#import <CoreLocation/CoreLocation.h>


typedef NS_ENUM(NSInteger, LFLostAndFoundMapViewControllerSegnmentIndex) {
    segnmentIndexForTable = 0 ,
    segnmentIndexForMap   = 1 ,
} ;

@interface LFLostAndFoundMapViewController ()<BMKLocationServiceDelegate,BMKMapViewDelegate,UITableViewDelegate,UITableViewDataSource,LFItemInfoPaopaoCustomViewDelegate>

@property (weak, nonatomic) IBOutlet BMKMapView *mapView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UIRefreshControl *refreshControl ;

@property (nonatomic) BMKLocationService *service ;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segnmentControl;

@property (nonatomic) CLLocation *userLocation ;

@property (strong) NSMutableArray *items ;
@property (strong) NSMutableDictionary *itemsDic ;

@end

@implementation LFLostAndFoundMapViewController

- (void)setUpMapView {
    self.mapView.zoomLevel = 18 ;
//    self.mapView.minZoomLevel = 18 ;
    self.mapView.maxZoomLevel = 20 ;
    
    CLLocation *userLocation = [LFUserDefaultService getUserLocationForUser:[LFUser currentUser]] ;
    self.userLocation = userLocation ;
    if ( userLocation ) {
        [self.mapView setCenterCoordinate:userLocation.coordinate] ;
    }
    
    //设置定位精确度，默认：kCLLocationAccuracyBest
    [BMKLocationService setLocationDesiredAccuracy:kCLLocationAccuracyBest] ;
    //指定最小距离更新(米)，默认：kCLDistanceFilterNone
    [BMKLocationService setLocationDistanceFilter:100.f] ;
    //初始化BMKLocationService
    self.service = [[BMKLocationService alloc] init] ;
    self.service.delegate = self ;
    //启动LocationService
    [self.service startUserLocationService] ;
    
}

- (void)setUpTableView {
    self.tableView.delegate = self ;
    self.tableView.dataSource = self ;
    [self.tableView addSubview:self.refreshControl] ;
    
}

- (void)viewDidLoad {
    [super viewDidLoad] ;
    [self.navigationController.navigationBar setTranslucent:FALSE] ;
    
    [self setUpMapView] ;
    [self setUpTableView] ;
    self.items = [NSMutableArray array] ;
    self.itemsDic = [NSMutableDictionary dictionary] ;
}

- (void)viewWillAppear:(BOOL)animated {
    self.mapView.delegate = self ;
    [super viewWillAppear:animated] ;
    [self.tabBarController.tabBar setHidden:NO] ;
}

- (void)viewWillDisappear:(BOOL)animated {
    self.mapView.delegate = nil ;
    [super viewWillAppear:animated] ;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning] ;
}


#pragma mark - getter && setter 

- (UIRefreshControl *)refreshControl {
    if ( !_refreshControl ) {
        _refreshControl = [[UIRefreshControl alloc] init] ;
        [_refreshControl addTarget:self
                            action:@selector(refresh:)
                  forControlEvents:UIControlEventValueChanged] ;
    }
    return _refreshControl ;
}

#pragma mark - IBActions

- (IBAction)showLeftDrawerBtnClicked:(id)sender {
    [[AppDelegate globalAppdelegate] toggleLeftDrawer:self animated:YES] ;
}

- (IBAction)showRightDrawerBtnClicked:(id)sender {
    [[AppDelegate globalAppdelegate] toggleRightDrawer:self animated:YES] ;
}

- (void)refresh:(id)sender {
    //拉取后端
    
    if ( !self.userLocation ) {
        [self.refreshControl endRefreshing] ;
        [LFUtils alert:@"等待定位～"] ;
        return ;
    }
    
    AVQuery *query = [Item query] ;
    AVGeoPoint *userLocation = [AVGeoPoint geoPointWithLocation:self.userLocation] ;
    [query whereKey:@"location" nearGeoPoint:userLocation] ;
    query.limit = 10 ;
//    [query includeKey:@"user"] ;
    [query includeKey:@"user.avatar"] ;
    LFWEAKSELF
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        [self.refreshControl endRefreshing] ;
        if ( objects ) {
            QYDebugLog(@"查找最近的物品成功 Items:[%@]",objects) ;
            [weakSelf addItems:objects] ;
        } else {
            QYDebugLog(@"查找最近的物品失败 Erorr:[%@]",error) ;
        }
    }] ;
    
}

#pragma mark - Helper 

- (void)addItems:(NSArray *)items {
    if ( !items ) return ;

    [items enumerateObjectsUsingBlock:^(Item *item, NSUInteger idx, BOOL *stop) {
        if ( !self.itemsDic[item.objectId] ) {
            [self.itemsDic setObject:item forKey:item.objectId] ;
            [self.items addObject:item] ;
        }
    }] ;
    
    [self.tableView reloadData] ;
    
    
    //添加地图的标记
    
    [self.mapView removeAnnotations:self.mapView.annotations] ;
    NSMutableArray *annotations = [NSMutableArray array] ;
    
    [items enumerateObjectsUsingBlock:^(Item *item, NSUInteger idx, BOOL *stop) {
        if ( item.location ) {
            CLLocation *location = [[CLLocation alloc] initWithLatitude:item.location.latitude longitude:item.location.longitude] ;
            LFBMKMapViewAnnotation *annotation = [[LFBMKMapViewAnnotation alloc] initWithCLCorrdinate:location.coordinate] ;
            annotation.item = item ;
            [annotations addObject:annotation] ;
        }
    }] ;
    [self.mapView addAnnotations:annotations] ;
    
    LFBMKMapViewAnnotation *firstAnnotation = annotations[0] ;
    [self.mapView setCenterCoordinate:firstAnnotation.coordinate] ;
}

- (void)toItemDetailViewControllerWithItem:(Item *)item {
    if ( !item ) return ;
    
    LFItemDetailViewController *vc = [AppDelegate getViewControllerById:@"LFItemDetailViewControllerSBID"] ;
    vc.item = item ;
    vc.hidesBottomBarWhenPushed = YES ;
    [self.navigationController pushViewController:vc animated:NO] ;
}

#pragma mark - UITableViewDelegate 

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70 ;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //到详情界面
    Item *item = self.items[indexPath.row] ;
    [self toItemDetailViewControllerWithItem:item] ;
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES] ;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items ? self.items.count : 0 ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LFLostAFoundTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LFLostAFoundTableViewCellReuseId" forIndexPath:indexPath] ;
    
    Item *item = self.items[indexPath.row] ;
    cell.itemNameLabel.text = item.name ;
    cell.itemDescriptionLabel.text = item.itemDescription ;
    cell.iconImageView.image = [item isLost] ? [UIImage imageNamed:@"Lost"] : [UIImage imageNamed:@"Found"] ;
    cell.nameLabel.text = [item.user displayName] ;

    
    [cell.avatarImageView sd_setImageWithURL:[NSURL URLWithString:item.user.avatar.url]
                            placeholderImage:[UIImage imageNamed:@"testAvatar1"]] ;
    
    return cell ;
}


#pragma mark - BMKLocationServiceDelegate

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation {
    QYDebugLog(@"定位成功") ;
    CLLocation *location = userLocation.location ;
    self.userLocation = location ;
    [LFUserDefaultService saveUserLocation:location.coordinate forUser:[LFUser currentUser]] ;
    
    [self.mapView setCenterCoordinate:userLocation.location.coordinate animated:YES] ;
    [self.service stopUserLocationService] ;
}

/**
 *定位失败后，会调用此函数
 *@param error 错误号
 */
- (void)didFailToLocateUserWithError:(NSError *)error {
    QYDebugLog(@"定位失败Error:[%@]",error) ;
}

#pragma mark - 地图Delegate

- (IBAction)segnmentControlChanged:(UISegmentedControl *)sender {
    LFLostAndFoundMapViewControllerSegnmentIndex index = sender.selectedSegmentIndex ;
    switch (index) {
        case segnmentIndexForTable : {
            //列表
            [self.view bringSubviewToFront:self.tableView] ;
            break ;
        }
            
        case segnmentIndexForMap : {
            //地图
            [self.view bringSubviewToFront:self.mapView] ;
            break ;
        }
            
        default:
            break;
    }
}

/**
 *根据anntation生成对应的View
 *@param mapView 地图View
 *@param annotation 指定的标注
 *@return 生成的标注View
 */
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation {
    LFItemAnnotationView *annotationView = (id)[mapView dequeueReusableAnnotationViewWithIdentifier:@"LFItemAnnotationViewReuseId"] ;
    if ( !annotationView ) {
        annotationView = [[LFItemAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"LFItemAnnotationViewReuseId"] ;
    }
    
    LFBMKMapViewAnnotation *lfAnnotation = annotation ;
    annotationView.image = lfAnnotation.annotationImage ;
    
    LFItemInfoPaopaoCustomView *customView = [[LFItemInfoPaopaoCustomView alloc] initWithItem:lfAnnotation.item] ;
    customView.delegate = self ;
    annotationView.paopaoView = [[BMKActionPaopaoView alloc] initWithCustomView:customView] ;
    
    return annotationView ;
}

#pragma mark - LFItemInfoPaopaoCustomViewDelegate

- (void)view:(LFItemInfoPaopaoCustomView *)view shouldShowItemDetail:(Item *)item {
    [self toItemDetailViewControllerWithItem:item] ;
}

@end
