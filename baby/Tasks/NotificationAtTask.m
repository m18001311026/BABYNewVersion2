//
//  NotificationAtTask.m
//  baby
//
//  Created by zhang da on 14-6-16.
//  Copyright (c) 2014年 zhang da. All rights reserved.
//

#import "NotificationAtTask.h"
#import "NotificationAt.h"
#import "ConfigManager.h"
#import "Session.h"
#import "User.h"
#import "Gallery.h"
#import "MemContainer.h"


@implementation NotificationAtTask

- (id)initAtListAtPage:(int)page count:(int)count {
    self = [super initWithUrl:SERVERURL method:POST session:[[ConfigManager me] getSession].session];
    if (self) {
        [self addParameter:@"action" value:@"notificationat_Query"];
        [self addParameter:@"page" value:[NSString stringWithFormat:@"%d", page]];
        [self addParameter:@"count" value:[NSString stringWithFormat:@"%d", count]];
        [self addParameter:@"user_id" value:[NSString stringWithFormat:@"%ld", [ConfigManager me].userId]];

        self.responseCallbackBlock = ^(bool succeeded, id userInfo) {
            NSArray *notifications = [userInfo objectForKey:@"notifications"];
            
            if (notifications && notifications.count > 0) {
                NSMutableArray *notificationList = [[NSMutableArray alloc] initWithCapacity:0];
                
                for (NSDictionary *notificationDict in notifications) {
                    NSDictionary *userDict = [notificationDict objectForKey:@"user"];
                    if (userDict) {
                        [[MemContainer me] instanceFromDict:userDict clazz:[User class]];
                    }
                    NSDictionary *galleryDict = [notificationDict objectForKey:@"gallery"];
                    if (galleryDict) {
                        [[MemContainer me] instanceFromDict:galleryDict clazz:[Gallery class]];
                    }
                    
                    NotificationAt *n = (NotificationAt *)[[MemContainer me] instanceFromDict:notificationDict
                                                                                        clazz:[NotificationAt class]];
                    [notificationList addObject:n];
                }
                [self doLogicCallBack:YES info:[notificationList autorelease]];
            } else {
                [self doLogicCallBack:YES info:nil];
            }
            
        };
    }
    return self;
}

@end
