//
//  SchoolTask.h
//  baby
//
//  Created by zhang da on 14-4-5.
//  Copyright (c) 2014年 zhang da. All rights reserved.
//

#import "BBNetworkTask.h"

// 获取系统通知（消息）

@interface NotificationTask : BBNetworkTask

- (id)initNotificationListAtPage:(int)page count:(int)count;

@end
