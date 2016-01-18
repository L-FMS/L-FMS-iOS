//
//  LFChooseLocationTableViewController.m
//  L-FMS-iOS
//
//  Created by 虎猫儿 on 15/10/10.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import "LFChooseLocationTableViewController.h"

#import <BaiduMapAPI/BMapKit.h>
#import <BaiduMapAPI/BMKMapView.h>

#import "LFCommon.h"

#import "LFChooseLocationNotificationCenter.h"
#import <CoreLocation/CoreLocation.h>

@interface LFChooseLocationTableViewController ()

@end

@implementation LFChooseLocationTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSValue *value = self.searchResult.ptList[indexPath.row];
    CLLocationCoordinate2D coor;
    [value getValue:&coor];
    CLLocation *location = [[CLLocation alloc] initWithLatitude:coor.latitude longitude:coor.longitude];
    if ([self.delegate respondsToSelector:@selector(viewController:didChooseLocation:)]) {
        [self.delegate viewController:self didChooseLocation:location];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.searchResult ? self.searchResult.keyList.count : 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseId = @"LFChooseLocationTableViewCellReuseId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseId];
    }
    
    cell.textLabel.text = self.searchResult.keyList[indexPath.row];
    cell.detailTextLabel.text = self.searchResult.cityList[indexPath.row];
    
    return cell;
}


@end
