//
//  Topic.h
//  baby
//
//  Created by zhang da on 14-4-15.
//  Copyright (c) 2014年 zhang da. All rights reserved.
//

#import "Model.h"

@interface Topic : Model

@property (nonatomic, assign) long _id;
@property (nonatomic, retain) NSString *icon;
@property (nonatomic, retain) NSString *content;
@property (nonatomic, retain) NSDate *createTime;
@property (nonatomic, assign) int hot;
@property (nonatomic, assign) int priority;

+ (Topic *)getTopicWithId:(long)_id;

@end
