//
//  User.h
//  baby
//
//  Created by zhang da on 14-2-4.
//  Copyright (c) 2014年 zhang da. All rights reserved.
//

#import "Model.h"

@interface User : Model


@property (nonatomic, assign) long _id;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *nickName;
@property (nonatomic, retain) NSString *avatarBig;
@property (nonatomic, retain) NSString *avatarMid;
@property (nonatomic, retain) NSString *avatarSmall;
@property (nonatomic, retain) NSString *homeCover;
@property (nonatomic, assign) int cityId;
@property (nonatomic, assign) long fanCnt;
@property (nonatomic, assign) long friendCnt;
@property (nonatomic, assign) long galleryCnt;
@property (nonatomic, assign) long long creatTime;
@property (nonatomic, assign) long long birthday;
@property (nonatomic, assign) bool gender;
@property (nonatomic, assign) bool isTeacher;
@property (nonatomic, retain) NSString *qq;
@property (nonatomic, retain) NSString *weixin;
@property (nonatomic, assign) long commentMessage;
@property (nonatomic, assign) long aMessage;
@property (nonatomic, assign) long friendMessage;
@property (nonatomic, assign) long activityMessage;
@property (nonatomic, assign) long systemMessage;
@property (nonatomic, assign) long user_id;



@property (nonatomic, retain) NSString * kidId;

@property (nonatomic, retain) NSNumber *following;

+ (User *)getUserWithId:(long)_id;

- (NSString *)showName;
- (int)age;

@end
