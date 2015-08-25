//
//  UserViewController.h
//  baby
//
//  Created by zhang da on 14-3-23.
//  Copyright (c) 2014年 zhang da. All rights reserved.
//

#import "BBViewController.h"
#import "PullTableView.h"
#import "UserVoiceInfoView.h"
#import "UserView.h"

@interface UserViewController : BBViewController
<UITableViewDataSource, UITableViewDelegate,
PullTableViewDelegate, UserVoiceInfoViewDelegate, UserViewDelegate>{
    
    int currentPage;
    NSMutableArray *galleries;
    PullTableView *galleryTable;
    
}

@property (nonatomic, assign) long userId;

- (id)initWithUser:(long)userId;

@end
