//
//  LFCacheService.m
//  L-FMS-iOS
//
//  Created by 虎猫儿 on 15/10/6.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import "LFCacheService.h"

#import "LFCommon.h"

@interface LFCacheService ()

@property (strong) NSMutableDictionary *cachedUsers ;//by Id

@end

@implementation LFCacheService

+ (instancetype)shareInstance {
    static LFCacheService *sharedInstance = nil ;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[LFCacheService alloc] init] ;
    });
    return sharedInstance ;
}

- (instancetype)init {
    if ( self = [super init] ) {
        [self setUp] ;
    }
    return self ;
}

- (void)setUp {
    self.cachedUsers = [NSMutableDictionary dictionary] ;
}

#pragma mark - User

- (void)cacheUser:(LFUser *)user {
    [self.cachedUsers setObject:user forKey:user.objectId] ;
}

- (LFUser *)getUserById:(NSString *)userId {
    if ( !userId ) return nil ;
    return self.cachedUsers[userId] ;
}




#warning 以下垃圾代码。。

- (void)cacheUsers:(NSArray *)users {
    [users enumerateObjectsUsingBlock:^(LFUser *user, NSUInteger idx, BOOL *stop) {
        [self cacheUser:user] ;
    }] ;
}

+ (void)cacheUsersWithIds:(NSSet*)userIds callback:(AVBooleanResultBlock)callback {
    NSMutableSet *uncachedUserIds = [NSMutableSet set] ;
    for( NSString* userId in userIds ){
        LFUser *user = [[LFCacheService shareInstance] getUserById:userId] ;
        
        if( nil == user )
            [uncachedUserIds addObject:userId] ;
    }
    
    if( [uncachedUserIds count] > 0 ){
        [self findUsersByIds:[uncachedUserIds allObjects] callback:^(NSArray *users, NSError *error) {
            if( users ){
                [[self shareInstance] cacheUsers:users] ;
                callback(YES,error) ;
            } else
                callback(NO,error);
            
        }];
    }else{
        callback(YES,nil);
    }
}

+ (void)findUsersByIds:(NSArray*)userIds callback:(AVArrayResultBlock)callback {
    if( userIds.count > 0 ){
        AVQuery *q = [LFUser query] ;
        [q setCachePolicy:kAVCachePolicyNetworkElseCache] ;
        [q whereKey:@"objectId" containedIn:userIds] ;
        
        [q findObjectsInBackgroundWithBlock:^(NSArray *users, NSError *error) {
            [[LFCacheService shareInstance] cacheUsers:users] ;
            callback(users,error) ;
        }] ;
    } else {
        callback(@[],nil) ;
    }
}

@end
