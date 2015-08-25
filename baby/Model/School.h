//
//  School.h
//  baby
//
//  Created by zhang da on 14-4-5.
//  Copyright (c) 2014年 zhang da. All rights reserved.
//

#import "Model.h"

@interface School : Model

@property (nonatomic, assign) long _id;
@property (nonatomic, assign) int cityId;
@property (nonatomic, retain) NSString *address;
@property (nonatomic, retain) NSString *hotline;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *cover;
@property (nonatomic, retain) NSString *travelRoute;
@property (nonatomic, retain) NSString *latitude;
@property (nonatomic, retain) NSString *longitude;

+ (School *)getSchoolWithId:(long)_id;

@end
