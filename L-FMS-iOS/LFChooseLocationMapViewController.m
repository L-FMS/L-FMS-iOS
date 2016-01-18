//
//  LFChooseLocationMapViewController.m
//  L-FMS-iOS
//
//  Created by 虎猫儿 on 15/10/10.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import "LFChooseLocationMapViewController.h"
#import "LFChooseLocationTableViewController.h"

#import "LFCommon.h"
#import "LFBaiduMapKit.h"
#import "LFUserAnnotation.h"

#import "LFChooseLocationNotificationCenter.h"

#define kChooseLocationMapVC2ChooseLocationTableVCSegueId @"ChooseLocationMapVC2ChooseLocationTableVCSegueId"


static CLLocation *locatedUserLocation = nil;

@interface LFChooseLocationMapViewController ()<UISearchBarDelegate,BMKSuggestionSearchDelegate,BMKLocationServiceDelegate,BMKMapViewDelegate,LFChooseLocationTableViewControllerDelegate> {
    BOOL _isChoosed;
    CLLocationCoordinate2D _chosedCorrdinate;
}

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet BMKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *ensureBtn;

@property (nonatomic) BMKLocationService *service;

@end

@implementation LFChooseLocationMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.searchBar.delegate = self;
    
    self.mapView.zoomLevel = 18;
    self.mapView.minZoomLevel = 18;
    self.mapView.maxZoomLevel = 20;
    
    if (!locatedUserLocation) {
        //设置定位精确度，默认：kCLLocationAccuracyBest
        [BMKLocationService setLocationDesiredAccuracy:kCLLocationAccuracyBest];
        //指定最小距离更新(米)，默认：kCLDistanceFilterNone
        [BMKLocationService setLocationDistanceFilter:100.f];
        //初始化BMKLocationService
        self.service = [[BMKLocationService alloc] init];
        self.service.delegate = self;
        //启动LocationService
        [self.service startUserLocationService];
    } else {
        [self.mapView setCenterCoordinate:locatedUserLocation.coordinate];
    }
    
    _isChoosed = NO;
    [self.ensureBtn setEnabled:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    self.mapView.delegate = self;
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    self.mapView.delegate = nil;
    [super viewWillDisappear:animated];
}

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.searchBar resignFirstResponder];
    NSString *text = self.searchBar.text;
    if (text.length != 0) {
        [self searchPlace:text];
    }
}

#pragma mark - UIResponder

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.searchBar resignFirstResponder];
}

#pragma mark - Helper

- (void)searchPlace:(NSString *)place {
    assert(place);
    QYDebugLog(@"Text:[%@]",place);
    BMKSuggestionSearch *search = [[BMKSuggestionSearch alloc] init];
    search.delegate = self;
    BMKSuggestionSearchOption *option = [[BMKSuggestionSearchOption alloc] init];
    option.cityname = @"上海市";
    option.keyword = place;
    BOOL flag = [search suggestionSearch:option];
    if (flag) {
        NSLog(@"成功");
    } else {
        NSLog(@"失败");
    }
}

- (void)setSelectedWithCoordinate:(CLLocationCoordinate2D)coordinate {
    _isChoosed = YES;
    _chosedCorrdinate = coordinate;
    [self.ensureBtn setEnabled:YES];
}

#pragma mark - BMKSuggestionSearchDelegate

/**
 *返回suggestion搜索结果
 *@param searcher 搜索对象
 *@param result 搜索结果
 *@param error 错误号，@see BMKSearchErrorCode
 */
- (void)onGetSuggestionResult:(BMKSuggestionSearch*)searcher result:(BMKSuggestionResult*)result errorCode:(BMKSearchErrorCode)error {
    if (error == BMK_SEARCH_NO_ERROR) {
        //处理
        [self performSegueWithIdentifier:kChooseLocationMapVC2ChooseLocationTableVCSegueId sender:result];
    } else {
        QYDebugLog(@"抱歉未找到结果");
    }
}

#pragma mark - BMKLocationServiceDelegate

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation {
    QYDebugLog(@"定位成功");
    locatedUserLocation = userLocation.location;
    LFUserAnnotation *annotation = [[LFUserAnnotation alloc] initWithCLCorrdinate:userLocation.location.coordinate];
    [self.mapView removeAnnotations:self.mapView.annotations];
    [self.mapView addAnnotation:annotation];
    
    [self setSelectedWithCoordinate:userLocation.location.coordinate];
    
    [self.mapView setCenterCoordinate:userLocation.location.coordinate animated:YES];
    [self.service stopUserLocationService];
}

/**
 *定位失败后，会调用此函数
 *@param error 错误号
 */
- (void)didFailToLocateUserWithError:(NSError *)error {
    QYDebugLog(@"定位失败Error:[%@]",error);
}

#pragma mark - BMKMapViewDelegate

/**
 *点中底图空白处会回调此接口
 *@param mapview 地图View
 *@param coordinate 空白处坐标点的经纬度
 */
- (void)mapView:(BMKMapView *)mapView onClickedMapBlank:(CLLocationCoordinate2D)coordinate {
    LFUserAnnotation *annotation = [[LFUserAnnotation alloc] initWithCLCorrdinate:coordinate];
    [self.mapView removeAnnotations:self.mapView.annotations];
    [self.mapView addAnnotation:annotation];
    [self setSelectedWithCoordinate:coordinate];
    
    QYDebugLog(@"点击了地图:[%f,%f]",coordinate.latitude,coordinate.longitude);
}

#pragma mark -

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:kChooseLocationMapVC2ChooseLocationTableVCSegueId]) {
        LFChooseLocationTableViewController *vc = segue.destinationViewController;
        vc.delegate = self;
        vc.searchResult = sender;
    }
}

#pragma mark - 

- (void)viewController:(LFChooseLocationTableViewController *)vc didChooseLocation:(CLLocation *)location {
    [vc.navigationController popViewControllerAnimated:YES];
    LFUserAnnotation *annotation = [[LFUserAnnotation alloc] initWithCLCorrdinate:location.coordinate];
    [self.mapView removeAnnotations:self.mapView.annotations];
    [self.mapView addAnnotation:annotation];
    [self.mapView setCenterCoordinate:location.coordinate];
    [self setSelectedWithCoordinate:location.coordinate];
}

#pragma mark - IBActions 

- (IBAction)ensureBtnClicked:(id)sender {
    QYDebugLog(@"确定了");
    if ([self.delegate respondsToSelector:@selector(viewController:didClickedLocation:)]) {
        CLLocation *location = [[CLLocation alloc] initWithLatitude:_chosedCorrdinate.latitude longitude:_chosedCorrdinate.longitude];
        [self.delegate viewController:self didClickedLocation:location];
    }
    [self.navigationController popViewControllerAnimated:YES];
}


@end
