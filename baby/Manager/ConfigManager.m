//
//  ConfigManager.m
//  baby
//
//  Created by zhang da on 14-3-2.
//  Copyright (c) 2014年 zhang da. All rights reserved.
//

#import "ConfigManager.h"
#import "Session.h"

@interface ConfigManager () {
    float _serverVesion;
    bool _inReview;
    
    bool _enableAlipay, _enableUnionPay;
}

@end


@implementation ConfigManager

static ConfigManager *_me = nil;

+ (ConfigManager *)me {
    if (!_me) {
        @synchronized([ConfigManager class]) {
            if (!_me) {
                _me = [[ConfigManager alloc] init];
            }
        }
    }
    return _me;
}

- (id)init {
    self = [super init];
    if (self) {
        _serverVesion = [[[NSUserDefaults standardUserDefaults] valueForKey:@"SERVER_VER"] floatValue];
        if ([[NSUserDefaults standardUserDefaults] valueForKey:@"IN_REVIEW"]) {
            _inReview = [[[NSUserDefaults standardUserDefaults] valueForKey:@"IN_REVIEW"] boolValue];
        } else {
            _inReview = YES;
        }
    }
    return self;
}

- (void)setSession:(Session *)session {
    [[NSUserDefaults standardUserDefaults] setObject:[session exportData] forKey:@"bb.config.session"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


- (Session *)getSession {
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"bb.config.session"];
    if (dict) {
        Session *session = (Session *)[Session instanceFromDict:dict];
        if (![session expired]) {
            return session;
        }
    }
    return nil;
}

- (long)userId {
    return [self getSession].userId;
}

- (void)updateServerVesion:(float)version andReviewStatus:(bool)inReview {
    _serverVesion = version;
    [[NSUserDefaults standardUserDefaults] setValue:@(version) forKey:@"SERVER_VER"];
    
    _inReview = inReview;
    [[NSUserDefaults standardUserDefaults] setValue:@(inReview) forKey:@"IN_REVIEW"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (float)serverVersion {
    return _serverVesion;
}

- (bool)inReview {
    return _inReview;
}

- (bool)runInReviewMode {
    NSString *current = [ConfigManager getCurrentVersion];
    float local = [current floatValue];
    return local > _serverVesion && _inReview;
}

- (bool)enableAlipay {
    return _enableAlipay;
}

- (bool)enableUnionPay {
    return _enableUnionPay;
}

- (void)updateAlipay:(bool)alipay unionPay:(bool)unionPay {
    _enableAlipay = alipay;
    _enableUnionPay = unionPay;
}

+ (NSString *)getCurrentVersion {
	NSDictionary *softwareInfo = [[NSDictionary alloc] initWithContentsOfFile:
								  [NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] bundlePath], @"Info.plist"]];
    NSString *version = [[softwareInfo objectForKey:@"CFBundleShortVersionString"] retain];
    [softwareInfo release];

    return [version autorelease];
}

@end
