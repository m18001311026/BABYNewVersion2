//
//  LessonViewController.h
//  baby
//
//  Created by zhang da on 14-3-3.
//  Copyright (c) 2014年 zhang da. All rights reserved.
//

#import "BBViewController.h"
#import "PullTableView.h"
#import "UserCell.h"

@interface FanViewController : BBViewController
<UITableViewDataSource, UITableViewDelegate, PullTableViewDelegate, UIScrollViewDelegate, UserCellDelegate> {

    int currentPage;
    PullTableView *fanTable;
    NSMutableArray *fans;
}

@property (nonatomic, assign) long userId;

- (id)initWithUser:(long)userId;

@end
