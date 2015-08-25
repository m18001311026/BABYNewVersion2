//
//  LessonTask.h
//  baby
//
//  Created by zhang da on 14-3-31.
//  Copyright (c) 2014年 zhang da. All rights reserved.
//

#import "BBNetworkTask.h"

@interface LessonTask : BBNetworkTask

- (id)initGetLesson:(int)type age:(int)age page:(int)page count:(int)count;
- (id)initSimilarLesson:(int)lessonId page:(int)page count:(int)count;

- (id)initLCommentList:(long)lessonId page:(int)page count:(int)count;
- (id)initDeleteLComment:(long)commentId;

- (id)initRecommendLessonList;

@end
