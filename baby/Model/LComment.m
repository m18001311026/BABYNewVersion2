//
//  GComment.m
//  baby
//
//  Created by zhang da on 14-3-18.
//  Copyright (c) 2014年 zhang da. All rights reserved.
//

#import "LComment.h"
#import "MemContainer.h"

@implementation LComment

@dynamic _id;
@dynamic content;
@dynamic createTime;
@dynamic lessonId;
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

+ (LComment *)getCommentWithId:(long)_id {
    
    NSLog(@"%@",(LComment *)[[MemContainer me] getObject:[NSPredicate predicateWithFormat:@"_id = %ld", _id]
                                                   clazz:[LComment class]]);
    
    return (LComment *)[[MemContainer me] getObject:[NSPredicate predicateWithFormat:@"_id = %ld", _id]
                                              clazz:[LComment class]];
}

@end
