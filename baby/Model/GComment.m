//
//  GComment.m
//  baby
//
//  Created by zhang da on 14-3-18.
//  Copyright (c) 2014年 zhang da. All rights reserved.
//

#import "GComment.h"
#import "MemContainer.h"

@implementation GComment

@dynamic _id;
@dynamic content;
@dynamic createTime;
@dynamic galleryId;
@dynamic userId;
@dynamic voice;
@dynamic voiceLength;
@dynamic replyTo;

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

+ (GComment *)getCommentWithId:(long)_id
{
    return (GComment *)[[MemContainer me] getObject:[NSPredicate predicateWithFormat:@"_id = %ld", _id]
                                              clazz:[GComment class]];
}

@end
