//
//  LessonViewController.h
//  baby
//
//  Created by zhang da on 14-3-3.
//  Copyright (c) 2014年 zhang da. All rights reserved.
//

#import "TabbarSubviewController.h"
#import "PullTableView.h"
#import "SimpleSegment.h"
#import "LessonCell.h"
#import "ImagePlayerView.h"

@class LessonHeader;

@interface LessonViewController : TabbarSubviewController
<UITableViewDataSource, UITableViewDelegate, PullTableViewDelegate,
SimpleSegmentDelegate, UIScrollViewDelegate, LessonCellDelegate, ImagePlayerViewDelegate>
{

    int currentPage;
    PullTableView *lessonTable;
    SimpleSegment *lessonType;
    ImagePlayerView *banner;

    NSMutableArray *lessons;
    NSMutableArray *recLessons;
    //六个按钮+后退按钮
    UIButton * backToHomeBtn;
    UIButton * btn1;
    UIButton * btn2;
    UIButton * btn3;
    UIButton * btn4;
    UIButton * btn5;
    UIButton * btn6;

    //----------------------
    UIView * backgroundView;
    
    UIImageView * _img;
    
}

@end
