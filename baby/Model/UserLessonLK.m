//
//  GalleryPictureLK.m
//  baby
//
//  Created by zhang da on 14-3-21.
//  Copyright (c) 2014年 zhang da. All rights reserved.
//

#import "UserLessonLK.h"
#import "MemContainer.h"

@implementation UserLessonLK

@dynamic _id, userId, lessonId, status, index;

+ (NSString *)primaryKey {
    return @"_id";
}

+ (NSDictionary *)mapping {
    static NSDictionary *map = nil;
    if (!map) {
        map = [@{
                 @"_id": @"id"
                 } retain];
    }
    return map;
}

+ (UserLessonLK *)getUserLessonLK:(long)userId lesson:(long)lessonId {
    return [[MemContainer me] getObject:[NSPredicate predicateWithFormat:@"userId = %ld and lessonId = %ld", userId, lessonId]
                                  clazz:[UserLessonLK class]];
}

@end
