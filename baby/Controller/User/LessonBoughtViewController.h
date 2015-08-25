//
//  LessonViewController.h
//  baby
//
//  Created by zhang da on 14-3-3.
//  Copyright (c) 2014年 zhang da. All rights reserved.
//

#import "BBViewController.h"
#import "PullTableView.h"
#import "BoughtLessonCell.h"

@interface LessonBoughtViewController : BBViewController
<UITableViewDataSource, UITableViewDelegate, PullTableViewDelegate, UIScrollViewDelegate, BoughtLessonCellDelegate> {

    int currentPage;
    PullTableView *lessonTable;
    NSMutableArray *lessons;

}

@end
