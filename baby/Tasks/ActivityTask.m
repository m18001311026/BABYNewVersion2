//
//  ActivityTask.m
//  baby
//
//  Created by zhang da on 14-6-16.
//  Copyright (c) 2014年 zhang da. All rights reserved.
//

#import "ActivityTask.h"
#import "Activity.h"
#import "MemContainer.h"

@implementation ActivityTask

- (id)initAvctivityList {
    self = [super initWithUrl:SERVERURL method:POST];
    if (self) {
        [self addParameter:@"action" value:@"activity_Query"];
        self.responseCallbackBlock = ^(bool succeeded, id userInfo) {
            NSArray *activities = [userInfo objectForKey:@"activities"];
            
            if (activities && activities.count > 0) {
                NSMutableArray *activityList = [[NSMutableArray alloc] initWithCapacity:0];
                for (NSDictionary *actDict in activities) {
                    Activity *a = (Activity *)[[MemContainer me] instanceFromDict:actDict
                                                                            clazz:[Activity class]];
                    [activityList addObject:a];
                }
                [self doLogicCallBack:YES info:[activityList autorelease]];
            } else {
                [self doLogicCallBack:YES info:nil];
            }
            
        };
    }
    return self;
}

@end
