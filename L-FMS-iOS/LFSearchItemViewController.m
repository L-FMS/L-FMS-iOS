//
//  LFSearchItemViewController.m
//  L-FMS-iOS
//
//  Created by 虎猫儿 on 15/10/8.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import "LFSearchItemViewController.h"

#import "LFCommon.h"
#import "LFBaiduMapKit.h"
#import "AppDelegate.h"

#import "LFUserAnnotation.h"
#import "LFBMKMapViewAnnotation.h"

#import "LFItemAnnotationView.h"
#import "LFItemInfoPaopaoCustomView.h"
#import "LFItemDetailViewController.h"

#import "LFLostAFoundTableViewCell.h"

typedef NS_ENUM(NSInteger, LFSearchItemViewControllerSegnmentIndex) {
    LFSearchItemViewControllerSegnmentIndexForTable = 0 ,
    LFSearchItemViewControllerSegnmentIndexForMap   = 1 ,
} ;

@interface LFSearchItemViewController ()<UITableViewDelegate,UITableViewDataSource,BMKMapViewDelegate,LFItemInfoPaopaoCustomViewDelegate,UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl ;
@property (weak, nonatomic) IBOutlet UITableView *tableView ;
@property (weak, nonatomic) IBOutlet BMKMapView *mapView ;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *searchBarButtonItem;

@property (nonatomic) NSArray *textItems ;
@property (nonatomic) NSArray *geoPointItems ;

@property (nonatomic) LFUserAnnotation *userAnnotation ;

@end

@implementation LFSearchItemViewController

- (void)viewDidLoad {
    [super viewDidLoad] ;
    
    self.tableView.dataSource = self ;
    self.tableView.delegate = self ;
    
    [self.view bringSubviewToFront:self.tableView] ;
    
    CLLocation *userLocation = [LFUserDefaultService getUserLocationForUser:[LFUser currentUser]] ;
    if ( userLocation ) {
        [self.mapView setCenterCoordinate:userLocation.coordinate] ;
    }
    self.mapView.zoomLevel = 18 ;
//    
//    [self.tableView registerClass:[LFLostAFoundTableViewCell class] forCellReuseIdentifier:@"LFLostAFoundTableViewCellReuseId2"] ;
}

- (void)viewWillAppear:(BOOL)animated {
    self.mapView.delegate = self ;
    [super viewWillAppear:animated] ;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated] ;
    self.mapView.delegate = nil ;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning] ;
}


#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ( buttonIndex != alertView.cancelButtonIndex ) {
        UITextField *textField= [alertView textFieldAtIndex:0] ;
        NSString *text = textField.text ;
        if ( text.length > 0 ) {
            [self searchText:text] ;
        }
    }
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70 ;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //到详情界面
    Item *item = self.textItems[indexPath.row] ;
    [self toItemDetailViewControllerWithItem:item] ;
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES] ;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.textItems ? self.textItems.count : 0 ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LFLostAFoundTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LFLostAFoundTableViewCellReuseId2" forIndexPath:indexPath] ;
    
    Item *item = self.textItems[indexPath.row] ;
    cell.itemNameLabel.text = item.name ;
    cell.itemDescriptionLabel.text = item.itemDescription ;
    cell.iconImageView.image = [item isLost] ? [UIImage imageNamed:@"Lost"] : [UIImage imageNamed:@"Found"] ;
    cell.nameLabel.text = [item.user displayName] ;
    
    
    [cell.avatarImageView sd_setImageWithURL:[NSURL URLWithString:item.user.avatar.url]
                            placeholderImage:[UIImage imageNamed:@"testAvatar1"]] ;
    
    return cell ;
}



#pragma mark - BMKMapViewDelegate

/**
 *点中底图空白处会回调此接口
 *@param mapview 地图View
 *@param coordinate 空白处坐标点的经纬度
 */
- (void)mapView:(BMKMapView *)mapView onClickedMapBlank:(CLLocationCoordinate2D)coordinate {
    LFUserAnnotation *annotation = [[LFUserAnnotation alloc] initWithCLCorrdinate:coordinate] ;
    [self.mapView removeAnnotations:self.mapView.annotations] ;
    [self.mapView addAnnotation:annotation] ;
    //搜索附近的
    [self searchCoordinate:coordinate] ;
}

/**
 *根据anntation生成对应的View
 *@param mapView 地图View
 *@param annotation 指定的标注
 *@return 生成的标注View
 */
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation {
    if ( [annotation isKindOfClass:[LFBMKMapViewAnnotation class]]) {
        //item
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
    } else {
        //user
        
        BMKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"BMKAnnotationViewReuseId"] ;
        if ( !annotationView ) {
            annotationView = [[BMKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"BMKAnnotationViewReuseId"] ;
        }
        annotationView.frame = CGRectMake(0, 0, 30, 38) ;
        annotationView.image = [UIImage imageNamed:@"icon_nav_start"] ;

        return annotationView ;        
    }
}


#pragma mark - LFItemInfoPaopaoCustomViewDelegate

- (void)view:(LFItemInfoPaopaoCustomView *)view shouldShowItemDetail:(Item *)item {
    [self toItemDetailViewControllerWithItem:item] ;
}


#pragma mark - actions 

- (IBAction)searchBarButtonItemClicked:(id)sender {
    //show alertView
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"搜索物品" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"搜索", nil] ;
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput ;
    
    [alertView show] ;
    
//    [self searchText:@"手表"] ;
    
}

- (void)toItemDetailViewControllerWithItem:(Item *)item {
    if ( !item ) return ;
    
    LFItemDetailViewController *vc = [AppDelegate getViewControllerById:@"LFItemDetailViewControllerSBID"] ;
    vc.item = item ;
    vc.hidesBottomBarWhenPushed = YES ;
    [self.navigationController pushViewController:vc animated:NO] ;
}


- (IBAction)segmentedControlStateChanged:(UISegmentedControl *)sender {
    LFSearchItemViewControllerSegnmentIndex index = sender.selectedSegmentIndex ;
    switch ( index ) {
        case LFSearchItemViewControllerSegnmentIndexForTable : {
            self.searchBarButtonItem.enabled = TRUE ;
            [self.view bringSubviewToFront:self.tableView] ;
            break ;
        }
            
        case LFSearchItemViewControllerSegnmentIndexForMap : {
            [self.view bringSubviewToFront:self.mapView] ;
            self.searchBarButtonItem.enabled = FALSE ;
            break ;
        }
            
        default:
            break;
    }
}

#pragma mark - Options 

- (void)searchCoordinate:(CLLocationCoordinate2D)coordinate {
    AVGeoPoint *point = [AVGeoPoint geoPointWithLatitude:coordinate.latitude longitude:coordinate.longitude] ;
    
    AVQuery *query = [Item query] ;
    [query whereKey:@"location" nearGeoPoint:point withinKilometers:4.0] ;
    query.limit = 100 ;
    [query includeKey:@"user"] ;
    LFWEAKSELF
    [SVProgressHUD show] ;
    [query findObjectsInBackgroundWithBlock:^(NSArray *items, NSError *error) {
        [SVProgressHUD dismiss] ;
        if ( items ) {
            QYDebugLog(@"查找最近的物品成功") ;
            [weakSelf showItems:items showAtMapView:YES] ;
        } else {
            QYDebugLog(@"查找附近的物品失败 Error:[%@]",error) ;
            [LFUtils alertError:error] ;
        }
    }] ;
}

- (void)searchText:(NSString *)text {
    AVQuery *nameQuery = [Item query] ;
    [nameQuery whereKey:@"name" containsString:text] ;
    
    AVQuery *addressQuery = [Item query] ;
    [addressQuery whereKey:@"place" containsString:text] ;
    
    AVQuery *descriptionQuery = [Item query] ;
    [descriptionQuery whereKey:@"itemDescription" containsString:text] ;
    
    AVQuery *tagQuery = [Item query] ;
    [descriptionQuery whereKey:@"tags" containedIn:@[text]] ;
    
    AVQuery *query = [AVQuery orQueryWithSubqueries:@[nameQuery,addressQuery,descriptionQuery,tagQuery]] ;
    
    [query includeKey:@"user"] ;
    
    [SVProgressHUD show] ;
    LFWEAKSELF
    [query findObjectsInBackgroundWithBlock:^(NSArray *items, NSError *error) {
        [SVProgressHUD dismiss] ;
        if ( items ) {
            [weakSelf showItems:items showAtMapView:NO] ;
        } else {
            [LFUtils alertError:error] ;
        }
    }] ;
    
}

- (void)showItems:(NSArray *)items showAtMapView:(BOOL)showAtMapView {
    if ( !items ) return ;
    
    if ( showAtMapView ) {
        self.geoPointItems = items ;
        
//        [self.mapView removeAnnotations:self.mapView.annotations] ;
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
        
    } else {
     
        self.textItems = items ;
        [self.tableView reloadData] ;
        
    }
    
}

@end
