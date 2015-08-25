//
//  SchoolDetailViewController.h
//  baby
//
//  Created by zhang da on 14-4-15.
//  Copyright (c) 2014年 zhang da. All rights reserved.
//

#import "BBViewController.h"
#import "PullTableView.h"
#import "ImagePlayerView.h"

@interface SchoolDetailViewController : BBViewController
<UITableViewDataSource, UITableViewDelegate, PullTableViewDelegate, ImagePlayerViewDelegate> {
    
    PullTableView *schoolTable;
    ImagePlayerView *banner;
    
}

@property (nonatomic, assign) long schoolId;

- (id)initWithSchool:(long)schoolId;

@end
