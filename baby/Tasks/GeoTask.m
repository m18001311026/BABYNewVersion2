//
//  GeoTask.m
//  baby
//
//  Created by zhang da on 14-3-2.
//  Copyright (c) 2014年 zhang da. All rights reserved.
//

#import "GeoTask.h"
#import "City.h"
#import "MemContainer.h"
#import "NSDictionaryExtra.h"
#import "ConfigManager.h"
#import "Session.h"

@implementation GeoTask

- (void)dealloc {
    [super dealloc];
}

- (id)initGetCityList {
    self = [super initWithUrl:SERVERURL method:GET];
    if (self) {
        [self addParameter:@"action" value:@"city_query"];

        self.responseCallbackBlock = ^(bool succeeded, id userInfo) {
            if (succeeded) {
                NSArray *provinceList = (NSArray *)[userInfo objForKey:@"provinces"];
                for (NSDictionary *pDict in provinceList) {
                    NSArray *cityList = (NSArray *)[pDict objForKey:@"cities"];
                    if (cityList) {
                        for (NSDictionary *cDict in cityList) {
                            City *city = (City *)[City instanceFromDict:cDict];
                            [[MemContainer me] putObject:city];
                        }
                    }
                }
                [self doLogicCallBack:succeeded info:nil];
            } else {
                [self doLogicCallBack:succeeded info:userInfo];
            }
        };
    }
    return self;
}

- (id)initUploadCity:(NSString *)cityName {
    self = [super initWithUrl:SERVERURL method:POST session:[[ConfigManager me] getSession].session];
    if (self) {
        [self addParameter:@"action" value:@"user_City"];
        [self addParameter:@"city_name" value:cityName];
        self.responseCallbackBlock = ^(bool succeeded, id userInfo) {
            if (succeeded) {
                NSDictionary *dict = (NSDictionary *)userInfo;
                [self doLogicCallBack:YES info:dict];
            } else {
                [self doLogicCallBack:NO info:userInfo];
            }
        };
    }
    return self;
}


@end
