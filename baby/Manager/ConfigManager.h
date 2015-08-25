//
//  ConfigManager.h
//  baby
//
//  Created by zhang da on 14-3-2.
//  Copyright (c) 2014年 zhang da. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Session;

@interface ConfigManager : NSObject

+ (ConfigManager *)me;

- (void)setSession:(Session *)session;
- (Session *)getSession;
- (long)userId;

- (void)updateServerVesion:(float)version andReviewStatus:(bool)inReview;
- (float)serverVersion;
- (bool)inReview;
- (bool)runInReviewMode;

- (bool)enableAlipay;
- (bool)enableUnionPay;
- (void)updateAlipay:(bool)alipay unionPay:(bool)unionPay;

+ (NSString *)getCurrentVersion;

@end
