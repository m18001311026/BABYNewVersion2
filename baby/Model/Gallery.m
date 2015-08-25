//
//  Gallery.m
//  baby
//
//  Created by zhang da on 14-2-5.
//  Copyright (c) 2014年 zhang da. All rights reserved.
//

#import "Gallery.h"
#import "MemContainer.h"

@implementation Gallery

@dynamic _id;
@dynamic introLength;
@dynamic age;
@dynamic cover;
@dynamic cityId;
@dynamic pictureCnt;
@dynamic userId;
@dynamic createTime;
@dynamic commentCnt;
@dynamic priority;
@dynamic del;
@dynamic introVoice;
@dynamic content;
@dynamic commentatorId;
@dynamic commentVoice;
@dynamic commentLength;
@dynamic commentTime;
@dynamic likeCnt;

@synthesize liked;

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

+ (Gallery *)getGalleryWithId:(long)_id {
    return (Gallery *)[[MemContainer me] getObject:[NSPredicate predicateWithFormat:@"_id = %ld", _id]
                                             clazz:[Gallery class]];
}

@end
