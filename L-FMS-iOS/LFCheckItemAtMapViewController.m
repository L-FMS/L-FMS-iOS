//
//  LFCheckItemAtMapViewController.m
//  L-FMS-iOS
//
//  Created by 虎猫儿 on 15/10/11.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import "LFCheckItemAtMapViewController.h"

#import "LFCommon.h"
#import "LFBaiduMapKit.h"
#import <CoreLocation/CoreLocation.h>

#import "LFSingleItemAnnotation.h"

@interface LFCheckItemAtMapViewController ()<BMKMapViewDelegate>

@property (weak, nonatomic) IBOutlet BMKMapView *mapView ;

@end

@implementation LFCheckItemAtMapViewController

- (void)showAnnotation {
    if ( self.itemLocation ) {
        CLLocationCoordinate2D coordinate = self.itemLocation.coordinate ;
        [self.mapView setCenterCoordinate:coordinate] ;
        LFSingleItemAnnotation *itemAnnotation = [[LFSingleItemAnnotation alloc] initWithItem:self.item location:self.itemLocation];
        [self.mapView addAnnotation:itemAnnotation] ;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad] ;
    self.mapView.zoomLevel = 18 ;
    [self showAnnotation] ;
}


- (void)viewWillAppear:(BOOL)animated {
    self.mapView.delegate = self ;
    [super viewWillAppear:animated] ;
}

- (void)viewWillDisappear:(BOOL)animated {
    self.mapView.delegate = nil ;
    [super viewWillDisappear:animated] ;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning] ;
}

@end
