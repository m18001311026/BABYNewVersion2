//
//  SchoolPicture.m
//  baby
//
//  Created by zhang da on 14-4-15.
//  Copyright (c) 2014年 zhang da. All rights reserved.
//

#import "SchoolPicture.h"
#import "MemContainer.h"


@implementation SchoolPicture

@dynamic _id, schoolId, cover, index;

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

+ (SchoolPicture *)getPictureWithId:(long)_id {
    return (SchoolPicture *)[[MemContainer me] getObject:[NSPredicate predicateWithFormat:@"_id = %ld", _id]
                                                   clazz:[SchoolPicture class]];
}

+ (NSArray *)getPicturesForSchool:(long)schoolId {
    return [[MemContainer me] getObjects:[NSPredicate predicateWithFormat:@"schoolId = %ld", schoolId]
                                   clazz:[SchoolPicture class]
                                 orderBy:@"index", nil];
}


@end
