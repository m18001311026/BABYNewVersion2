//
//  LessonViewController.h
//  baby
//
//  Created by zhang da on 14-3-3.
//  Copyright (c) 2014年 zhang da. All rights reserved.
//

#import "BBViewController.h"
#import "PullTableView.h"

@interface NotificationAtViewController : BBViewController
<UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate> {

    UITableView *notificationAtTable;
    NSArray *atNotifications;
    
    int currentPage;

}

@end
