//
//  DataCenter.h
//  baby
//
//  Created by chenxin on 14-11-10.
//  Copyright (c) 2014年 zhang da. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataCenter : NSObject

+ (instancetype)shareDataCenter;

@property (nonatomic, assign) long sysMessage;
@property (nonatomic, assign) long commentMessage;
@property (nonatomic, assign) long activityMessage;

@end
