//
//  SchoolTask.h
//  baby
//
//  Created by zhang da on 14-4-5.
//  Copyright (c) 2014年 zhang da. All rights reserved.
//

#import "BBNetworkTask.h"

@interface SchoolTask : BBNetworkTask

- (id)initSchoolList;
- (id)initSchoolDetail:(long)schoolId;

@end
