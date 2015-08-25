//
//  NotificationCommentViewController.m
//  baby
//
//  Created by chenxin on 14-11-18.
//  Copyright (c) 2014年 zhang da. All rights reserved.
//

#import "NotificationCommentViewController.h"
#import "UIButtonExtra.h"
#import "GalleryViewController.h"

#import "NotificationAtTask.h"
#import "TaskQueue.h"

#import "NotificationAt.h"
#import "User.h"
#import "ImageView.h"

#import "DataCenter.h"
#import "GComment.h"
#import "GalleryTask.h"
#import "ConfigManager.h"
#import "Shared.h"
#import "UserTask.h"

@interface NotificationCommentViewController ()<UITableViewDataSource, UITableViewDelegate> {
    UITableView *tableView;
    NSArray *comments;
    
    int currentPage;
}

@end

@implementation NotificationCommentViewController


- (void)dealloc {
    
    [super dealloc];
}

- (id)init {
    self = [super init];
    if (self) {
        self.view.backgroundColor = [UIColor whiteColor];
        
        tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, 320, screentContentHeight - 44)
                                                           style:UITableViewStylePlain];
        //        notificationAtTable.pullDelegate = self;
        tableView.delegate = self;
        tableView.dataSource = self;
        //        notificationAtTable.pullBackgroundColor = [Shared bbWhite];
        tableView.backgroundColor = [Shared bbWhite];
        [tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
        if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [tableView setSeparatorInset:UIEdgeInsetsZero];
        }
        tableView.separatorColor = [Shared bbLightGray];
        [self.view addSubview:tableView];
        [tableView release];
        
        comments = [[NSMutableArray alloc] initWithCapacity:0];
        
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
    
    [self setViewTitle:@"评论通知"];
    bbTopbar.backgroundColor = [UIColor colorWithRed:234/255.0 green:166/255.0 blue:31/255.0 alpha:1];
    
    [self loadNotification];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [DataCenter shareDataCenter].commentMessage = 0;
    
    long userId = [ConfigManager me].userId;
    
    UserTask *task1 = [[UserTask alloc] initUserDetail:userId msg:@"comment_message"];
    task1.logicCallbackBlock = ^(bool succeeded, id userInfo) {
        
        
        
    };
    [TaskQueue addTaskToQueue:task1];
    [task1 release];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma ui event

- (void)loadNotification {

    long userId = [ConfigManager me].userId;
    if (userId > 0) {
        
        GalleryTask *task = [[GalleryTask alloc] initGCommentList:[ConfigManager me].userId];
        task.logicCallbackBlock = ^(bool succeeded, id userInfo) {
            
            if (succeeded) {
                
                if ([(NSArray *)userInfo count] > 0) {
                    
                    comments = [userInfo copy];
                    [tableView reloadData];
                    
                }
            }
            
        };
        [TaskQueue addTaskToQueue:task];
        [task release];
        
    }

}

- (void)back {
    [ctr popViewControllerAnimated:YES];
}

#pragma table view section
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return comments.count;
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
        titel.tag = 1001;
        titel.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:titel];
        [titel release];
        
        UILabel *time = [[UILabel alloc] initWithFrame:CGRectMake(255, 12, 60, 13)];
        time.font = [UIFont systemFontOfSize:12];
        time.tag = 1002;
        time.textColor = [UIColor colorWithRed:234/255.0 green:166/255.0 blue:31/255.0 alpha:1];
        time.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:time];
        [time release];
        
        UILabel *detail = [[UILabel alloc] initWithFrame:CGRectMake(60, 34, 250, 15)];
        detail.font = [UIFont systemFontOfSize:13];
        detail.textColor = [UIColor grayColor];
        detail.tag = 1003;
        detail.textAlignment = UITextAlignmentLeft;
        detail.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:detail];
        [detail release];
        
    }
    
//    UILabel *title = (UILabel *)[cell.contentView viewWithTag:1001];
    UILabel *time = (UILabel *)[cell.contentView viewWithTag:1002];
    UILabel *detail = (UILabel *)[cell.contentView viewWithTag:1003];
    
    if (comments.count > indexPath.row) {
        GComment *note = [comments objectAtIndex:indexPath.row];
        
        User *user = [User getUserWithId:note.userId];
        
        if (user != nil) {
//            title.text = [NSString stringWithFormat:@"%@ \n在TA的新画里面提到了你", [user showName]];
        }
        
        time.text = [TOOL dateString:[TOOL dateFromUnixTime:note.createTime]];
        
        detail.text = note.content;
        if (note.voiceLength>3) {
            detail.text = @"语音评论，点击查看";
        }

        time.text = [TOOL dateString:[TOOL dateFromUnixTime:note.createTime]];
        
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (comments.count > indexPath.row) {
        GComment *note = [comments objectAtIndex:indexPath.row];
        
        GalleryViewController *gCtr = [[GalleryViewController alloc] initWithGallery:note.galleryId];
        [ctr pushViewController:gCtr animation:ViewSwitchAnimationSwipeR2L];
        [gCtr release];
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
