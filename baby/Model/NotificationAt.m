//
//  NotificationAt.m
//  baby
//
//  Created by zhang da on 14-6-16.
//  Copyright (c) 2014年 zhang da. All rights reserved.
//

#import "NotificationAt.h"

@implementation NotificationAt

@dynamic _id;
@dynamic galleryId;
@dynamic fromUserId;
@dynamic toUserId;
@dynamic createTime;

+ (NSDictionary *)mapping {
    static NSDictionary *map = nil;
    if (!map) {
        map = [@{
                 @"_id": @"id",
                 } retain];
    }
    return map;
}

+ (NSString *)primaryKey {
    return @"_id";
}

@end
