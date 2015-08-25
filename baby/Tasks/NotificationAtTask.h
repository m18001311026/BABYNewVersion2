//
//  NotificationAtTask.h
//  baby
//
//  Created by zhang da on 14-6-16.
//  Copyright (c) 2014年 zhang da. All rights reserved.
//

#import "BBNetworkTask.h"

// 获取我的消息

@interface NotificationAtTask : BBNetworkTask

- (id)initAtListAtPage:(int)page count:(int)count;
- (id)initAtList;

@end
