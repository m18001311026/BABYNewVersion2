//
//  Lesson.m
//  baby
//
//  Created by zhang da on 14-3-31.
//  Copyright (c) 2014年 zhang da. All rights reserved.
//

#import "Lesson.h"
#import "MemContainer.h"

@implementation Lesson

@dynamic _id, title, content, cover, age, minAge, maxAge, commentCnt, createTime, type, price, videoLength, videoMain, videoPreview;

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

+ (Lesson *)getLessonWithId:(long)_id {
    return (Lesson *)[[MemContainer me] getObject:[NSPredicate predicateWithFormat:@"_id = %ld", _id]
                                            clazz:[Lesson class]];
}

- (NSString *)typeString {
    if (self.type == 0) {
        return @"变变变";
    } else if (self.type == 1) {
        return @"绘本";
    } else {
        return @"其他";
    }
}

- (NSString *)ageString {
    if (self.minAge > 0 && self.maxAge > 0) {
        return [NSString stringWithFormat:@"（%d-%d岁）", self.minAge, self.maxAge];
    } else if (self.age > 0) {
        return [NSString stringWithFormat:@"（%d岁）", self.age];
    } else {
        return @"";
    }
}

- (NSString *)lengthString {
    if (self.videoLength > 0) {
        return [NSString stringWithFormat:@"%d分钟", self.videoLength/60];
    } else {
        return @"暂无";
    }
}


@end
