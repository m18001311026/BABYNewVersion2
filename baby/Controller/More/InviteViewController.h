//
//  InviteViewController.h
//  baby
//
//  Created by zhang da on 14-5-8.
//  Copyright (c) 2014年 zhang da. All rights reserved.
//

#import "BBViewController.h"

@interface InviteViewController : BBViewController
<UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate> {
    UITableView *inviteTable;
}

@end
