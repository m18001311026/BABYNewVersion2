//
//  GalleryPictureLK.h
//  baby
//
//  Created by zhang da on 14-3-21.
//  Copyright (c) 2014年 zhang da. All rights reserved.
//

#import "Model.h"

@interface UserLessonLK : Model

@property (nonatomic, assign) long _id;
@property (nonatomic, assign) long userId;
@property (nonatomic, assign) long lessonId;
@property (nonatomic, assign) int status;
@property (nonatomic, assign) int index;

+ (UserLessonLK *)getUserLessonLK:(long)userId lesson:(long)lessonId;

@end
