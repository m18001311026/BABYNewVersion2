//
//  LessonViewController.h
//  baby
//
//  Created by zhang da on 14-3-6.
//  Copyright (c) 2014年 zhang da. All rights reserved.
//

#import "BBViewController.h"
#import "IndicatorSegment.h"
#import "LessonDetailView.h"
#import "UPPayPluginDelegate.h"

@class LessonCommentView, LessonRecommendView, LessonHeader;

@interface LessonDetailViewController : BBViewController
<IndicatorSegmentDelegate, LessonDetailViewDelegate, UPPayPluginDelegate> {
    LessonHeader *header;

    IndicatorSegment *segment;
    
    LessonDetailView *detail;
    LessonCommentView *comment;
    LessonRecommendView *lessons;
}

@property (nonatomic, assign) long lessonId;

- (id)initWithLesson:(long)lessonId;

@end
