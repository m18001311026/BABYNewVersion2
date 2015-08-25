//
//  FanViewController.m
//  baby
//
//  Created by zhang da on 14-3-3.
//  Copyright (c) 2014年 zhang da. All rights reserved.
//

#import "FanViewController.h"
#import "UserCell.h"
#import "UIButtonExtra.h"

#import "UserViewController.h"
#import "UserTask.h"
#import "LKTask.h"
#import "TaskQueue.h"

#import "User.h"


#define FAN_PAGE_SIZE 5

@interface FanViewController ()

@property (nonatomic, assign) long playingLessonId;

@end



@implementation FanViewController

- (void)dealloc {
    [fans release];

    [super dealloc];
}

- (id)initWithUser:(long)userId {
    self = [super init];
    if (self) {
        self.userId = userId;
        self.view.backgroundColor = [UIColor whiteColor];
        
        fanTable = [[PullTableView alloc] initWithFrame:CGRectMake(0, 44, 320, screentContentHeight - 44)
                                                  style:UITableViewStylePlain];
        fanTable.pullDelegate = self;
        fanTable.delegate = self;
        fanTable.dataSource = self;
        fanTable.pullBackgroundColor = [Shared bbWhite];
        fanTable.backgroundColor = [Shared bbWhite];
        [fanTable setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
        fanTable.separatorColor = [UIColor whiteColor];
        [self.view addSubview:fanTable];
        [fanTable release];
        
        fans = [[NSMutableArray alloc] initWithCapacity:0];
        
        currentPage = 1;
        [self loadFans];

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setViewTitle:@"粉丝"];
    bbTopbar.backgroundColor = [UIColor colorWithRed:234/255.0 green:166/255.0 blue:31/255.0 alpha:1];
    
    UIButton *back = [UIButton buttonWithCustomStyle:CustomButtonStyleBack];
    [back addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [bbTopbar addSubview:back];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma ui event
- (void)back {
    [ctr popViewControllerAnimated:YES];
}

- (void)segmentSelected:(int)index {
    currentPage = 1;
    fanTable.isRefreshing = YES;
    [self loadFans];
}

- (void)loadFans {
    UserTask *task = [[UserTask alloc] initFanList:self.userId
                                              page:currentPage
                                             count:FAN_PAGE_SIZE];
    task.logicCallbackBlock = ^(bool succeeded, id userInfo) {
        if (currentPage == 1) {
            [fans removeAllObjects];
        }
        
        if (succeeded) {
            [fans addObjectsFromArray:(NSArray *)userInfo];
            if ([((NSArray *)userInfo) count] < FAN_PAGE_SIZE) {
                fanTable.hasMore = NO;
            } else {
                fanTable.hasMore = YES;
            }
        }
        
        [fanTable reloadData];
        [fanTable stopLoading];
    };
    [TaskQueue addTaskToQueue:task];
    [task release];
}

- (void)startPlayPreview {
    if (self.playingLessonId > 0) {
        
    }
}

- (void)stopPlayPreview {

}


#pragma table view section
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return fans.count;
}

- (void)configCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    UserCell *uCell = (UserCell *)cell;
    if (fans.count > indexPath.row) {
        uCell.userId = [[fans objectAtIndex:indexPath.row] longValue];
        [uCell updateLayout];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"UserCell";
    UserCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[[UserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
    }
    [self configCell:cell atIndexPath:indexPath];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 74;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    long fansId = [[fans objectAtIndex:indexPath.row] longValue];
    
    UserViewController *uCtr = [[UserViewController alloc] initWithUser:fansId];
    [ctr pushViewController:uCtr animation:ViewSwitchAnimationSwipeR2L];
    [uCtr release];
}


#pragma mark pull table view delegate
- (void)pullTableViewDidTriggerRefresh:(PullTableView*)pullTableView {
    currentPage = 1;
    [self loadFans];
}

- (void)pullTableViewDidTriggerLoadMore:(PullTableView*)pullTableView {
    currentPage ++;
    [self loadFans];
}


#pragma mark usecell delegate
- (void)relationEditTouched:(int)userId {
    User *user = [User getUserWithId:userId];
    if (user.following) {
        LKTask *task = [[LKTask alloc] initUserRelation:userId
                                                 follow:![user.following boolValue]];
        task.logicCallbackBlock = ^(bool successful, id userInfo) {
            if (successful) {
                [fanTable reloadData];
            }
        };
        [TaskQueue addTaskToQueue:task];
        [task release];
    }
}


@end
