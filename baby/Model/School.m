//
//  School.m
//  baby
//
//  Created by zhang da on 14-4-5.
//  Copyright (c) 2014年 zhang da. All rights reserved.
//

#import "School.h"
#import "MemContainer.h"


@implementation School

@dynamic  _id, cityId, address, hotline, title, cover, travelRoute, latitude, longitude;

+ (NSString *)primaryKey {
    return @"_id";
}

+ (NSDictionary *)mapping {
    static NSDictionary *map = nil;
    if (!map) {
        map = [@{
                 @"_id": @"id",
                 } retain];
    }
    return map;
}

+ (School *)getSchoolWithId:(long)_id {
    return (School *)[[MemContainer me] getObject:[NSPredicate predicateWithFormat:@"_id = %ld", _id]
                                            clazz:[School class]];
}

@end
