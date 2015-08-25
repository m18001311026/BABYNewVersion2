//
//  DataCenter.m
//  baby
//
//  Created by chenxin on 14-11-10.
//  Copyright (c) 2014年 zhang da. All rights reserved.
//

#import "DataCenter.h"

@implementation DataCenter

+ (instancetype)shareDataCenter {
    
    static DataCenter *object;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        object = [[DataCenter alloc] init];
        
        object.sysMessage      = 0;
        object.commentMessage  = 0;
        object.activityMessage = 0;
        
    });
    
    return object;
}

@end
