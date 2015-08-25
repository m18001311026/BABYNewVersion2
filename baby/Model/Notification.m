//
//  Notification.m
//  baby
//
//  Created by zhang da on 14-4-19.
//  Copyright (c) 2014年 zhang da. All rights reserved.
//

#import "Notification.h"
#import "MemContainer.h"

@implementation Notification

@dynamic _id, title, content, image, expireDate, createTime;

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

+ (Notification *)getNotificationWithId:(int)_id {
    return (Notification *)[[MemContainer me] getObject:[NSPredicate predicateWithFormat:@"_id = %ld", _id]
                                                  clazz:[Notification class]];
}


@end
