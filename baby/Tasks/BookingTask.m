//
//  BookingTask.m
//  baby
//
//  Created by zhang da on 14-5-5.
//  Copyright (c) 2014年 zhang da. All rights reserved.
//

#import "BookingTask.h"

@implementation BookingTask

- (id)initBooking:(NSDate *)time school:(long)schoolId name:(NSString *)name mobile:(NSString *)mobile {
    self = [super initWithUrl:SERVERURL method:POST];
    if (self) {
        [self addParameter:@"action" value:@"booking_Add"];
        [self addParameter:@"booking_time" value:[TOOL fullString:time]];
        [self addParameter:@"school_id" value:[NSString stringWithFormat:@"%ld", schoolId]];
        [self addParameter:@"name" value:name];
        [self addParameter:@"mobile" value:mobile];

        self.responseCallbackBlock = ^(bool succeeded, id userInfo) {
            if (succeeded) {
                [self doLogicCallBack:YES info:nil];
            } else {
                [self doLogicCallBack:NO info:userInfo];
            }
        };
    }
    return self;
}

@end
