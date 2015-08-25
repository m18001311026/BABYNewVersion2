//
//  Activity.m
//  baby
//
//  Created by zhang da on 14-6-16.
//  Copyright (c) 2014年 zhang da. All rights reserved.
//

#import "Activity.h"
#import "MemContainer.h"

@implementation Activity

@dynamic _id, title ,content, icon, priority, createTime;

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

+ (Activity *)getActivityWithId:(int)_id {
    return (Activity *)[[MemContainer me] getObject:[NSPredicate predicateWithFormat:@"_id = %ld", _id]
                                                  clazz:[Activity class]];
}

@end
