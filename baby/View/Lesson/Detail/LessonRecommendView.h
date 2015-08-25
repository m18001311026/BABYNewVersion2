//
//  LessonRecommendView.h
//  baby
//
//  Created by zhang da on 14-3-25.
//  Copyright (c) 2014年 zhang da. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PullTableView.h"
#import "LessonCell.h"

@interface LessonRecommendView : UIView
<UITableViewDataSource, UITableViewDelegate, PullTableViewDelegate, UIScrollViewDelegate, LessonCellDelegate> {
    
    int currentPage;
    PullTableView *lessonTable;
    NSMutableArray *lessons;
    
}

@property (nonatomic, assign) long lessonId;

- (id)initWithFrame:(CGRect)frame lesson:(long)lessonId;

@end
