//
//  LessonViewController.m
//  baby
//
//  Created by zhang da on 14-3-3.
//  Copyright (c) 2014年 zhang da. All rights reserved.
//

#import "NotificationAtViewController.h"
#import "UIButtonExtra.h"
#import "GalleryViewController.h"

#import "NotificationAtTask.h"
#import "TaskQueue.h"

#import "NotificationAt.h"
#import "User.h"
#import "ImageView.h"

#import "DataCenter.h"

#define AVATAR 90901
#define TITLE 90900
#define TIME 99999

#define POPDETAIL 90909
#define POPTITLE 77777

#define N_PAGE_SIZE 5


@interface NotificationAtViewController ()

@end


@implementation NotificationAtViewController

- (void)dealloc {
    [atNotifications release];
    [super dealloc];
}

- (id)init {
    self = [super init];
    if (self) {
        self.view.backgroundColor = [UIColor whiteColor];
        
        notificationAtTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, 320, screentContentHeight - 44)
                                                      style:UITableViewStylePlain];
        notificationAtTable.delegate = self;
        notificationAtTable.dataSource = self;
        notificationAtTable.backgroundColor = [Shared bbWhite];
        [notificationAtTable setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
        if ([notificationAtTable respondsToSelector:@selector(setSeparatorInset:)]) {
            [notificationAtTable setSeparatorInset:UIEdgeInsetsZero];
        }
        notificationAtTable.separatorColor = [Shared bbLightGray];
        [self.view addSubview:notificationAtTable];
        [notificationAtTable release];
        
        atNotifications = [[NSMutableArray alloc] initWithCapacity:0];
        
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
    
    [self setViewTitle:@"@消息"];
    bbTopbar.backgroundColor = [UIColor colorWithRed:234/255.0 green:166/255.0 blue:31/255.0 alpha:1];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma ui event
- (void)back {
    [ctr popViewControllerAnimated:YES];
}

/*
- (void)loadNotification {
    NotificationAtTask *task = [[NotificationAtTask alloc] initAtListAtPage:currentPage count:N_PAGE_SIZE];
    task.logicCallbackBlock = ^(bool succeeded, id userInfo) {
        if (currentPage == 1) {
            [atNotifications removeAllObjects];
        }
        
        if (succeeded) {
            [atNotifications addObjectsFromArray:(NSArray *)userInfo];
            notificationAtTable.hasMore = ((NSArray *)userInfo).count >= N_PAGE_SIZE;
        }
        
        [notificationAtTable reloadData];
        [notificationAtTable stopLoading];
    };
    [TaskQueue addTaskToQueue:task];
    [task release];
}
*/

#pragma table view section
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return atNotifications.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"notifiCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [Shared bbRealWhite];
        
        ImageView *avatar = [[ImageView alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
        avatar.clipsToBounds = YES;
        avatar.layer.cornerRadius = 20;
        avatar.layer.borderColor = [UIColor colorWithRed:234/255.0 green:166/255.0 blue:31/255.0 alpha:1].CGColor;
        avatar.layer.borderWidth = 2;
        avatar.tag = AVATAR;
        [cell.contentView addSubview:avatar];
        [avatar release];
        
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(60, 5, 190, 50)];
        title.font = [UIFont systemFontOfSize:14];
        title.textColor = [UIColor grayColor];
        title.numberOfLines = 2;
        title.tag = TITLE;
        title.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:title];
        [title release];
        
        UILabel *time = [[UILabel alloc] initWithFrame:CGRectMake(255, 23, 60, 13)];
        time.font = [UIFont systemFontOfSize:12];
        time.tag = TIME;
        time.textColor = [UIColor colorWithRed:234/255.0 green:166/255.0 blue:31/255.0 alpha:1];
        time.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:time];
        [time release];
    }
    
    UILabel *title = (UILabel *)[cell.contentView viewWithTag:TITLE];
    UILabel *time = (UILabel *)[cell.contentView viewWithTag:TIME];
    ImageView *avatar = (ImageView *)[cell.contentView viewWithTag:AVATAR];
    
    if (atNotifications.count > indexPath.row) {
        NotificationAt *note = [atNotifications objectAtIndex:indexPath.row];
        
        User *user = [User getUserWithId:note.fromUserId];
        
        avatar.imagePath = user.avatarMid;
        title.text = [NSString stringWithFormat:@"%@ \n在TA的新画里面提到了你", [user showName]];
        time.text = [TOOL dateString:[TOOL dateFromUnixTime:note.createTime]];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if (atNotifications.count > indexPath.row) {
        NotificationAt *note = [atNotifications objectAtIndex:indexPath.row];

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
