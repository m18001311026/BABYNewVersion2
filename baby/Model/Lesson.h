//
//  Lesson.h
//  baby
//
//  Created by zhang da on 14-3-31.
//  Copyright (c) 2014年 zhang da. All rights reserved.
//

#import "Model.h"

@interface Lesson : Model

@property (nonatomic, assign) long _id;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *content;
@property (nonatomic, retain) NSString *cover;
@property (nonatomic, assign) int age;
@property (nonatomic, assign) int minAge;
@property (nonatomic, assign) int maxAge;
@property (nonatomic, assign) int commentCnt;
@property (nonatomic, assign) long long createTime;
@property (nonatomic, assign) int type;
@property (nonatomic, assign) float price;
@property (nonatomic, assign) int videoLength;
@property (nonatomic, retain) NSString *videoMain;
@property (nonatomic, retain) NSString *videoPreview;

+ (Lesson *)getLessonWithId:(long)_id;
- (NSString *)typeString;
- (NSString *)ageString;
- (NSString *)lengthString;

@end
