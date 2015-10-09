//
//  AppDelegate.m
//  L-FMS-iOS
//
//  Created by 虎猫儿 on 15/9/21.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import "AppDelegate.h"

#import "LFViewControllerSBIDs.h"
#define kRegisteAndLoginSBName @"Registe&Login"

#import <AVOSCloud/AVOSCloud.h>
#import <JVFloatingDrawer/JVFloatingDrawerView.h>
#import <JVFloatingDrawer/JVFloatingDrawerSpringAnimator.h>

#import "LFAVSubclassRegister.h"
#import "LFCommon.h"
#import "LFIMClient.h"

@interface AppDelegate ()

#pragma mark - 左右侧栏

@property (nonatomic, strong, readonly) UIStoryboard *mainStoryboard ;

@end

@implementation AppDelegate

#pragma mark - getter && setter 

@synthesize mainStoryboard = _mainStoryboard ;

- (JVFloatingDrawerViewController *)drawerViewController {
    if ( !_drawerViewController ) {
        _drawerViewController = [[JVFloatingDrawerViewController alloc] init] ;
        _drawerViewController.leftDrawerWidth = 240.0f ;
        _drawerViewController.rightDrawerWidth = 120.0f ;
        
        _drawerViewController.leftViewController = [self controllerWithId:@"JVLeftDrawerTableViewControllerSBID"] ;
        _drawerViewController.rightViewController = [self controllerWithId:@"JVRightDrawerTableViewControllerSBID"] ;
        _drawerViewController.centerViewController = [self controllerWithId:@"MainTabbarVCSBID"] ;
        
        //animator
        _drawerViewController.animator = [self getADrawerAnimator] ;
        
        _drawerViewController.backgroundImage = [UIImage imageNamed:@"背景.png"] ;
    }
    return _drawerViewController ;
}

- (JVFloatingDrawerSpringAnimator *)getADrawerAnimator {
    JVFloatingDrawerSpringAnimator *animator = [[JVFloatingDrawerSpringAnimator alloc] init] ;
    
    animator.animationDelay = 0.0 ;
    animator.animationDuration = 0.8 ;
    animator.initialSpringVelocity = 9.0 ;
    animator.springDamping = 2.0 ;
    
    return animator ;
}

- (UIViewController *)controllerWithId:(NSString *)VCSBID {
    if ( !VCSBID ) return nil ;
    return [self.mainStoryboard instantiateViewControllerWithIdentifier:VCSBID] ;
}

- (UIStoryboard *)mainStoryboard {
    if(!_mainStoryboard)
        _mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil] ;
    return _mainStoryboard ;
}

+ (AppDelegate *)globalAppdelegate {
    return [UIApplication sharedApplication].delegate ;
}

#pragma mark - 界面

- (void)toMain {
    LFUser *user = [LFUser currentUser] ;
    if ( nil == user.imClient ) {
        user.imClient = [[LFIMClient alloc] init] ;
        [user.imClient openSessionWithClientID:user.objectId completion:^(BOOL succeeded, NSError *error) {            
        }] ;
    }
    
    self.window.rootViewController = self.drawerViewController ;
}

- (void)toRegiste {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:kRegisteAndLoginSBName bundle:nil] ;
    UIViewController *vc = [sb instantiateViewControllerWithIdentifier:kLFRegisteViewControllerSBID] ;
    self.window.rootViewController = vc ;
}

- (void)toLogin {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:kRegisteAndLoginSBName bundle:nil] ;
    UIViewController *vc = [sb instantiateViewControllerWithIdentifier:kLFLoginViewControllerSBID] ;
    self.window.rootViewController = vc ;
}

+ (id)getViewControllerById:(NSString *)VCSBID {
    id vc = [[[self globalAppdelegate] mainStoryboard] instantiateViewControllerWithIdentifier:VCSBID] ;
    return vc ;
}

#pragma mark - AVOSCloud 

#define AVOSAPPID  @"rx17l6bweypfcjvxj7rt6c6fybalxfqe4991jnm00qhpyhpp"
#define AVOSAPPKEY @"x0surp0ssgm5zda9b66rykzcamohkxu0a8ez4iuqyx2d7qju"

- (void)setUpAVOSCloudWithOptions:(NSDictionary *)launchOptions {
    [AVOSCloud setApplicationId:AVOSAPPID
                      clientKey:AVOSAPPKEY] ;
    //统计应用打开情况
    [AVAnalytics trackAppOpenedWithLaunchOptions:launchOptions] ;
}

#pragma makr - Life Cycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [LFAVSubclassRegister registeAllAVSubclasses] ;
    [self setUpAVOSCloudWithOptions:launchOptions] ;
    
    if ( [AVUser currentUser] ) {
        [self toMain] ;
    } else {
        [self toLogin] ;
    }
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "QianYan.L_FMS_iOS" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"L_FMS_iOS" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"L_FMS_iOS.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - 抽屉

/*
 *  控制弹回
 */
- (void)toggleLeftDrawer:(id)sender animated:(BOOL)animated {
    [self.drawerViewController toggleDrawerWithSide:JVFloatingDrawerSideLeft animated:animated completion:nil] ;
}

- (void)toggleRightDrawer:(id)sender animated:(BOOL)animated {
    [self.drawerViewController toggleDrawerWithSide:JVFloatingDrawerSideRight animated:animated completion:nil] ;
}

@end
