//
//  SchoolPicture.h
//  baby
//
//  Created by zhang da on 14-4-15.
//  Copyright (c) 2014年 zhang da. All rights reserved.
//

#import "Model.h"

@interface SchoolPicture : Model

@property (nonatomic, assign) int _id;
@property (nonatomic, assign) long schoolId;
@property (nonatomic, retain) NSString *cover;
@property (nonatomic, assign) int index;

+ (SchoolPicture *)getPictureWithId:(long)_id;
+ (NSArray *)getPicturesForSchool:(long)schoolId;

@end
