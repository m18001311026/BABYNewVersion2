//
//  Activity.h
//  baby
//
//  Created by zhang da on 14-6-16.
//  Copyright (c) 2014年 zhang da. All rights reserved.
//

#import "Model.h"

@interface Activity : Model

@property (nonatomic, assign) int _id;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *content;
@property (nonatomic, retain) NSString *icon;
@property (nonatomic, assign) long priority;
@property (nonatomic, assign) long long createTime;

+ (Activity *)getActivityWithId:(int)_id;

@end
