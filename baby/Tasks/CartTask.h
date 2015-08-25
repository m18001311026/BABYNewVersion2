//
//  CartTask.h
//  baby
//
//  Created by zhang da on 14-3-31.
//  Copyright (c) 2014年 zhang da. All rights reserved.
//

#import "BBNetworkTask.h"

@interface CartTask : BBNetworkTask

- (id)initEditLesson:(long)lessonId relation:(bool)relation;
- (id)initLessonRelationQuery:(long)lessonId;
- (id)initLessonCart;

@end
