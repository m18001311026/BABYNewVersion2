//
//  AccountViewController.h
//  baby
//
//  Created by zhang da on 14-3-3.
//  Copyright (c) 2014年 zhang da. All rights reserved.
//

//#import "BBViewController.h"
#import "TabbarSubviewController.h"
#import "PullTableView.h"
#import "TopicCell.h"
#import "TopicSimpleCell.h"

@interface TopicViewController : TabbarSubviewController
<UITableViewDataSource, UITableViewDelegate, PullTableViewDelegate,
TopicCellDelegate, TopicSimpleCellDelegate>{
    
    int currentPage;

    NSMutableArray *topics;
    NSMutableArray *simpleTopics;

    PullTableView *topicTable;
    UILabel *header;
}

@end
