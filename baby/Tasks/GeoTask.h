//
//  GeoTask.h
//  baby
//
//  Created by zhang da on 14-3-2.
//  Copyright (c) 2014年 zhang da. All rights reserved.
//

#import "BBNetworkTask.h"

@interface GeoTask : BBNetworkTask

- (id)initGetCityList;
- (id)initUploadCity:(NSString *)cityName;

@end
