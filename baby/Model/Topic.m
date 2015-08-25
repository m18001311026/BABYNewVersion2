//
//  Topic.m
//  baby
//
//  Created by zhang da on 14-4-15.
//  Copyright (c) 2014年 zhang da. All rights reserved.
//

#import "Topic.h"
#import "MemContainer.h"

@implementation Topic

@dynamic _id, icon, content, hot, createTime, priority;

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

+ (Topic *)getTopicWithId:(long)_id {
    return (Topic *)[[MemContainer me] getObject:[NSPredicate predicateWithFormat:@"_id = %ld", _id]
                                           clazz:[Topic class]];
}


@end
