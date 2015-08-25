//
//  City.m
//  baby
//
//  Created by zhang da on 14-3-2.
//  Copyright (c) 2014年 zhang da. All rights reserved.
//

#import "City.h"

@implementation City

@dynamic _id, name, type;

+ (NSString *)primaryKey {
    return @"_id";
}

@end
