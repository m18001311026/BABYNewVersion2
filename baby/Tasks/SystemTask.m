//
//  SystemTask.m
//  baby
//
//  Created by zhang da on 14-8-9.
//  Copyright (c) 2014年 zhang da. All rights reserved.
//

#import "SystemTask.h"
#import "ConfigManager.h"

@implementation SystemTask


- (void)dealloc {
    [super dealloc];
}

- (id)initGetVersion {
    self = [super initWithUrl:SERVERURL method:GET];
    if (self) {
        [self addParameter:@"action" value:@"version_query"];
        
        self.responseCallbackBlock = ^(bool succeeded, id userInfo) {
            if (succeeded) {
                bool inReview = NO;
                NSDictionary *config = [userInfo objectForKey:@"config"];
                if (config) {
                    inReview = [[config objectForKey:@"inReview"] boolValue];
                }
                
                float version = [[userInfo objectForKey:@"version"] floatValue];
                
                [[ConfigManager me] updateServerVesion:version andReviewStatus:inReview];
                
                [self doLogicCallBack:succeeded info:nil];
            } else {
                [self doLogicCallBack:succeeded info:userInfo];
            }
        };
    }
    return self;
}

- (id)initPayConfig {
    self = [super initWithUrl:SERVERURL method:GET];
    if (self) {
        [self addParameter:@"action" value:@"pay_query"];
        
        self.responseCallbackBlock = ^(bool succeeded, id userInfo) {
            if (succeeded) {
                bool alipay = YES, unionPay = NO;
                
                NSDictionary *config = [userInfo objectForKey:@"pay"];
                if (config) {
                    alipay = [[config objectForKey:@"alipay"] boolValue];
                    unionPay = [[config objectForKey:@"unionpay"] boolValue];
                }
                
                [[ConfigManager me] updateAlipay:alipay unionPay:unionPay];
                
                [self doLogicCallBack:succeeded info:nil];
            } else {
                [self doLogicCallBack:succeeded info:userInfo];
            }
        };
    }
    return self;
}

@end
