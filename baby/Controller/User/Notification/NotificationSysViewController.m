//
//  LessonViewController.m
//  baby
//
//  Created by zhang da on 14-3-3.
//  Copyright (c) 2014年 zhang da. All rights reserved.
//

#import "NotificationSysViewController.h"
#import "UIButtonExtra.h"
#import "NotificationDetailViewController.h"

#import "NotificationTask.h"
#import "TaskQueue.h"

#import "Notification.h"
#import "DataCenter.h"
#import "UserTask.h"
#import "ConfigManager.h"

#define TITLE 90900
#define DETAIL 89808
#define TIME 99999

#define POPDETAIL 90909
#define POPTITLE 77777

#define N_PAGE_SIZE 10

@interface NotificationSysViewController () {
    
    UITableView *notificationTable;
    
    NSArray *notifications;
    
    int currentPage;
    
}


@end



@implementation NotificationSysViewController

- (void)dealloc {
    [notifications release];
    [super dealloc];
}

- (id)init {
    self = [super init];
    if (self) {
        self.view.backgroundColor = [UIColor whiteColor];
        
        notificationTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, 320, screentContentHeight - 44)
                                                      style:UITableViewStylePlain];
        notificationTable.delegate = self;
        notificationTable.dataSource = self;
        notificationTable.backgroundColor = [Shared bbWhite];
        [notificationTable setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
        if ([notificationTable respondsToSelector:@selector(setSeparatorInset:)]) {
            [notificationTable setSeparatorInset:UIEdgeInsetsZero];
        }
        notificationTable.separatorColor = [Shared bbLightGray];
        [self.view addSubview:notificationTable];
        [notificationTable release];
        
        notifications = [NSArray array];
        
        UIButton *back = [UIButton buttonWithCustomStyle:CustomButtonStyleBack];
        [back addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        [bbTopbar addSubview:back];

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setViewTitle:@"系统通知"];
    bbTopbar.backgroundColor = [UIColor colorWithRed:234/255.0 green:166/255.0 blue:31/255.0 alpha:1];
    
    [self loadNotification];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [DataCenter shareDataCenter].sysMessage = 0;
    
    long userId = [ConfigManager me].userId;
    UserTask *task1 = [[UserTask alloc] initUserDetail:userId msg:@"system_message"];
    task1.logicCallbackBlock = ^(bool succeeded, id userInfo) {
        
        
        
    };
    [TaskQueue addTaskToQueue:task1];
    [task1 release];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    
}


#pragma ui event
- (void)back {
    [ctr popViewControllerAnimated:YES];
}


- (void)loadNotification {
//    NotificationTask *task = [[NotificationTask alloc] initNotificationListAtPage:1 count:100];
//    task.logicCallbackBlock = ^(bool succeeded, id userInfo) {
//        
//        if (succeeded) {
//
//        }
//        
//    };
//    [TaskQueue addTaskToQueue:task];
//    [task release];
    
    NotificationTask *task = [[NotificationTask alloc] initNotificationListAtPage:1 count:1000];
    task.logicCallbackBlock = ^(bool succeeded, id userInfo) {
        
        if (succeeded) {
            if ([(NSArray *)userInfo count] > 0) {
                
                notifications = [userInfo copy];
                [notificationTable reloadData];
                
            }
        }
        
    };
    [TaskQueue addTaskToQueue:task];
    [task release];

}


#pragma table view section
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return notifications.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"notifiCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [Shared bbRealWhite];
        
        UIImageView *avatar = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
        avatar.image = [UIImage imageNamed:@"baby_logo.png"];
        avatar.clipsToBounds = YES;
        avatar.layer.cornerRadius = 20;
        avatar.layer.borderColor = [UIColor colorWithRed:234/255.0 green:166/255.0 blue:31/255.0 alpha:1].CGColor;
        avatar.layer.borderWidth = 2;
        [cell.contentView addSubview:avatar];
        [avatar release];
        
        UILabel *titel = [[UILabel alloc] initWithFrame:CGRectMake(60, 12, 190, 15)];
        titel.font = [UIFont systemFontOfSize:14];
        titel.textColor = [UIColor blackColor];
        titel.tag = TITLE;
        titel.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:titel];
        [titel release];
        
        UILabel *time = [[UILabel alloc] initWithFrame:CGRectMake(255, 12, 60, 13)];
        time.font = [UIFont systemFontOfSize:12];
        time.tag = TIME;
        time.textColor = [UIColor colorWithRed:234/255.0 green:166/255.0 blue:31/255.0 alpha:1];
        time.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:time];
        [time release];
        
        UILabel *detail = [[UILabel alloc] initWithFrame:CGRectMake(60, 34, 250, 15)];
        detail.font = [UIFont systemFontOfSize:13];
        detail.textColor = [UIColor grayColor];
        detail.tag = DETAIL;
        detail.textAlignment = UITextAlignmentLeft;
        detail.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:detail];
        [detail release];

    }
    
    UILabel *title = (UILabel *)[cell.contentView viewWithTag:TITLE];
    UILabel *detail = (UILabel *)[cell.contentView viewWithTag:DETAIL];
    UILabel *time = (UILabel *)[cell.contentView viewWithTag:TIME];
    
    
    if (notifications.count > 0) {
        int notificationId = [[notifications objectAtIndex:indexPath.row] intValue];
        Notification *note = [Notification getNotificationWithId:notificationId];
        
        title.text = note.title;
        detail.text = note.content;
        time.text = [TOOL dateString:[TOOL dateFromUnixTime:note.createTime]];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if (notifications.count > indexPath.row) {
        int notificationId = [[notifications objectAtIndex:indexPath.row] intValue];
        Notification *note = [Notification getNotificationWithId:notificationId];
        
        NotificationDetailViewController *nCtr = [[NotificationDetailViewController alloc] initWithNotification:note];
        [ctr pushViewController:nCtr animation:ViewSwitchAnimationSwipeR2L];
        [nCtr release];
    }
    
}


#pragma mark pull table view delegate
/*
- (void)pullTableViewDidTriggerRefresh:(PullTableView*)pullTableView {
    currentPage = 1;
    [self loadNotification];
}

- (void)pullTableViewDidTriggerLoadMore:(PullTableView*)pullTableView {
    currentPage ++;
    [self loadNotification];
}
*/

@end
