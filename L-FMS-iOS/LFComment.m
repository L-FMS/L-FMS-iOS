//
//  LFComment.m
//  L-FMS-iOS
//
//  Created by 虎猫儿 on 15/10/9.
//  Copyright (c) 2015年 虎猫儿. All rights reserved.
//

#import "LFComment.h"
#import "LFCommon.h"

@implementation LFComment

@dynamic content ;
@dynamic item ;
@dynamic author ;
@dynamic replyTo ;
@dynamic replyToUsers ;

+ (NSString *)parseClassName {
    return @"Comment" ;
}

@end

#import <objc/runtime.h>

static const void *kLFCommentcellHeightKey = &kLFCommentcellHeightKey ;

@implementation LFComment(LFCommentNoticeTableViewController)

@dynamic cellHeight ;

- (void)setCellHeight:(NSNumber *)cellHeight {
    objc_setAssociatedObject(self, kLFCommentcellHeightKey, cellHeight, OBJC_ASSOCIATION_COPY_NONATOMIC) ;
}

- (NSNumber *)cellHeight {
    return objc_getAssociatedObject(self, kLFCommentcellHeightKey) ;
}

@end