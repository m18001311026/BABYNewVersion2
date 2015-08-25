//
//  IntroducerTask.m
//  baby
//
//  Created by zhang da on 14-6-14.
//  Copyright (c) 2014年 zhang da. All rights reserved.
//

#import "IntroducerTask.h"

@implementation IntroducerTask

- (id)initIntroducerList {
    self = [super initWithUrl:SERVERURL method:POST];
    if (self) {
        [self addParameter:@"action" value:@"introducer_Query"];
        
        self.responseCallbackBlock = ^(bool succeeded, id userInfo) {
            if (succeeded) {
                NSDictionary *dict = (NSDictionary *)userInfo;
                NSArray *introducers = [userInfo objectForKey:@"introducers"];
                
                if (introducers && introducers.count > 0) {
                    NSMutableArray *introduceList = [[NSMutableArray alloc] initWithCapacity:0];
                    for (NSDictionary *dict in introducers) {
                        [introduceList addObject:dict[@"title"]];
                    }
                    [self doLogicCallBack:YES info:[introduceList autorelease]];
                } else {
                    [self doLogicCallBack:YES info:dict];
                }
            } else {
                [self doLogicCallBack:NO info:userInfo];
            }
        };
    }
    return self;
}

@end
