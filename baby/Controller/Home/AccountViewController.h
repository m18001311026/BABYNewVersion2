//
//  AccountViewController.h
//  baby
//
//  Created by zhang da on 14-3-3.
//  Copyright (c) 2014年 zhang da. All rights reserved.
//

#import "TabbarSubviewController.h"
#import "SelfSummaryView.h"
#import "PullTableView.h"

@class AccountViewController;

@interface AccountViewController : TabbarSubviewController
<UITableViewDataSource, UITableViewDelegate, PullTableViewDelegate, SelfSummaryViewDelegate, UIActionSheetDelegate>{
    
    PullTableView *funcTable;
    SelfSummaryView *header;
    
}

@property (nonatomic, assign) BOOL showBadgeView;

- (void)reloadData;

@end
