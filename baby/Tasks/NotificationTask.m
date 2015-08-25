//
//  SchoolTask.m
//  baby
//
//  Created by zhang da on 14-4-5.
//  Copyright (c) 2014年 zhang da. All rights reserved.
//

#import "NotificationTask.h"
#import "Notification.h"
#import "MemContainer.h"

@implementation NotificationTask

- (id)initNotificationListAtPage:(int)page count:(int)count {
    self = [super initWithUrl:SERVERURL method:POST];
    if (self) {
        [self addParameter:@"action" value:@"notification_Query"];
        [self addParameter:@"page" value:[NSString stringWithFormat:@"%d", page]];
        [self addParameter:@"count" value:[NSString stringWithFormat:@"%d", count]];
        
        self.responseCallbackBlock = ^(bool succeeded, id userInfo) {
            NSArray *notifications = [userInfo objectForKey:@"notifications"];
            
            if (notifications && notifications.count > 0) {
                NSMutableArray *notificationIds = [[NSMutableArray alloc] initWithCapacity:0];
                for (NSDictionary *notificationDict in notifications) {
                    Notification *n = (Notification *)[[MemContainer me] instanceFromDict:notificationDict
                                                                                    clazz:[Notification class]];
                    [notificationIds addObject:@(n._id)];
                }
                [self doLogicCallBack:YES info:[notificationIds autorelease]];
            } else {
                [self doLogicCallBack:YES info:nil];
            }

        };
    }
    return self;
}

@end
