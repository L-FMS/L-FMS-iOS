//
//  AppDelegate.h
//  L-FMS-iOS
//
//  Created by 虎猫儿 on 15/9/21.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@class JVFloatingDrawerViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate> 

+ (AppDelegate *)globalAppdelegate;

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

#pragma mark - 界面

- (void)toMain;
- (void)toRegiste;
- (void)toLogin;

+ (id)getViewControllerById:(NSString *)VCSBID;

/**
 *  整体的ViewController
 */
@property (nonatomic, strong) JVFloatingDrawerViewController *drawerViewController;

#pragma mark - 抽屉

- (void)toggleLeftDrawer:(id)sender animated:(BOOL)animated;
- (void)toggleRightDrawer:(id)sender animated:(BOOL)animated;

@end

