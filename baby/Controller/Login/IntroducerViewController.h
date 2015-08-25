//
//  IntroducerViewController.h
//  baby
//
//  Created by zhang da on 14-6-14.
//  Copyright (c) 2014年 zhang da. All rights reserved.
//

#import "BBViewController.h"
#import "PullTableView.h"

typedef void ( ^FinishPickIntroducer )(NSString *introducer);

@interface IntroducerViewController : BBViewController
<UITableViewDataSource, UITableViewDelegate, PullTableViewDelegate> {
    NSMutableArray *introducers;
    PullTableView *introTable;
}

@property (nonatomic, copy) FinishPickIntroducer callback;

- (id)initWIthCallback:(FinishPickIntroducer)callback;

@end
