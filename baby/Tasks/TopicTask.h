//
//  TopicTask.h
//  baby
//
//  Created by zhang da on 14-4-15.
//  Copyright (c) 2014年 zhang da. All rights reserved.
//

#import "BBNetworkTask.h"

@interface TopicTask : BBNetworkTask

- (id)initTopicListAtPage:(int)page count:(int)count;
- (id)initTopicList;

@end
