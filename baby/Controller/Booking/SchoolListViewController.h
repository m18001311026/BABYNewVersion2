//
//  LessonViewController.h
//  baby
//
//  Created by zhang da on 14-3-3.
//  Copyright (c) 2014年 zhang da. All rights reserved.
//

#import "BBViewController.h"
#import "PullTableView.h"
#import "SchoolCell.h"

typedef void ( ^SchoolChoose )(long schoolId);

@interface SchoolListViewController : BBViewController
<UITableViewDataSource, UITableViewDelegate, PullTableViewDelegate,
UIScrollViewDelegate, SchoolCellDelegate> {

    PullTableView *schoolTable;
    NSMutableArray *schools;

}

- (id)initWithCallback:(SchoolChoose)callback;

@end
