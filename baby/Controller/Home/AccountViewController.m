//
//  AccountViewController.m
//  baby
//
//  Created by zhang da on 14-3-3.
//  Copyright (c) 2014年 zhang da. All rights reserved.
//

#import "AccountViewController.h"
#import "SelfGalleryViewController.h"
#import "TaskQueue.h"
#import "ConfigManager.h"
#import "Session.h"
#import "EditViewController.h"
#import "ImagePickerController.h"
#import "FanViewController.h"
#import "FriendViewController.h"
#import "LikeGalleryViewController.h"
#import "NotificationCenterViewController.h"
#import "LessonBoughtViewController.h"
#import "ScanQRViewController.h"
#import "WelcomeViewController.h"

#import "MyQRViewController.h"

#import "UserTask.h"
#import "TaskQueue.h"
#import "CartViewController.h"
#import "Macro.h"

#import "DataCenter.h"

@interface AccountViewController ()

@property (nonatomic, assign) bool needRefresh;

@end


@implementation AccountViewController

- (void)dealloc {
    
    [super dealloc];
}

- (id)init {
    self = [super init];
    if (self) {
        
        _needRefresh = false;
        
        funcTable = [[PullTableView alloc] initWithFrame:CGRectMake(0, 44, 320, screentContentHeight - 44 - 52)
                                                   style:UITableViewStylePlain];
        funcTable.delegate = self;
        funcTable.dataSource = self;
        funcTable.pullDelegate = self;
        funcTable.hasMore = NO;
        funcTable.backgroundColor = [Shared bbRealWhite];
        funcTable.pullBackgroundColor = [Shared bbWhite];
        [funcTable setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
        funcTable.separatorColor = [Shared bbLightGray];
        [self.view addSubview:funcTable];
        [funcTable release];
        
        header = [[SelfSummaryView alloc] initWithFrame:CGRectMake(0, 0, 320, 220)
                                                forUser:[ConfigManager me].userId];
        header.delegate = self;
        [funcTable setTableHeaderView:header];
        [header updateLayout];
        [header release];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(loadUserDetail)
                                                     name:UserDidLoginNotification
                                                   object:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Custom initialization
    self.view.backgroundColor = [Shared bbRealWhite];
    
    [self setViewTitle:@"我的"];
    bbTopbar.backgroundColor = [UIColor colorWithRed:234/255.0 green:166/255.0 blue:31/255.0 alpha:1];
    
  //  bbTopbar.backgroundColor = [UIColor colorWithRed:234/255.0 green:166/255.0 blue:31/255.0 alpha:1];
    
    bbTopbar.backgroundColor= [UIColor colorWithRed:234/255.0 green:166/255.0 blue:31/255.0 alpha:1];
    
    
    UIButton *shoppingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    shoppingBtn.frame = CGRectMake(kScreen_width - 40, 7, 30, 30);
    [shoppingBtn setImage:[UIImage imageNamed:@"shopping.png"] forState:UIControlStateNormal];
    [shoppingBtn addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
//    [bbTopbar addSubview:shoppingBtn];
}


- (void)btnAction {
    //    CartViewController
    
    CartViewController *dCtr = [[CartViewController alloc] init];
    [ctr pushViewController:dCtr animation:ViewSwitchAnimationSwipeR2L];
    [dCtr release];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (self.needRefresh) {
        [self loadUserDetail];
        self.needRefresh = NO;
    }
}


#pragma ui event
- (void)loadUserDetail {
    header.userId = [ConfigManager me].userId;
    
    if ([ConfigManager me].userId > 0) {
        UserTask *task = [[UserTask alloc] initUserDetail:[ConfigManager me].userId];
        task.logicCallbackBlock = ^(bool successful, id userInfo) {
            [header updateLayout];
            funcTable.isRefreshing = NO;
        };
        [TaskQueue addTaskToQueue:task];
        [task release];
    } else {
        [header updateLayout];
        funcTable.isRefreshing = NO;
    }
}

//- (void)setShowBadgeView:(BOOL)showBadgeView {
//    if (_showBadgeView != showBadgeView) {
//        _showBadgeView = showBadgeView;
//        
//        [funcTable reloadData];
//    }
//}


#pragma table view section
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellId = @"mycell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:cellId] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.contentView.backgroundColor = [Shared bbWhite];
        cell.textLabel.textColor = [UIColor grayColor];
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        
        UIImageView *indicator = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"indicator"]];
        indicator.frame = CGRectMake(290, 7, 30, 30);
        indicator.userInteractionEnabled = NO;
        indicator.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:indicator];
        [indicator release];
        
        UITextField *badgeField = [[UITextField alloc] initWithFrame:CGRectMake(50, 5, 16, 16)];
        
        badgeField.backgroundColor = [UIColor redColor];
        badgeField.textColor = [UIColor whiteColor];
        badgeField.tag = 1000;
        badgeField.layer.cornerRadius = 8;
        badgeField.hidden = YES;
        badgeField.layer.masksToBounds = YES;
        badgeField.textAlignment = NSTextAlignmentCenter;
        badgeField.userInteractionEnabled = NO;
        badgeField.font = [UIFont systemFontOfSize:12];
        [cell.contentView addSubview:badgeField];
        [badgeField release];
    }
    
    // chenxin
    switch (indexPath.row) {
        case 0: cell.textLabel.text = @"我的二维码"; break;
        case 1: cell.textLabel.text = @"消息"; break;
//        case 2: cell.textLabel.text = [ConfigManager me].runInReviewMode? @"历史记录": @"购买记录"; break;
        case 2: cell.textLabel.text = @"我的收藏"; break;
        case 3: cell.textLabel.text = @"扫码加好友"; break;
        //case 4: cell.textLabel.text = @"视频浏览"; break;
        default: break;
    }
    
        
    if (indexPath.row == 1) {
        UITextField *badgeField = (UITextField *)[cell.contentView viewWithTag:1000];
        
        if ( [DataCenter shareDataCenter].commentMessage != 0 || [DataCenter shareDataCenter].sysMessage != 0) {
            badgeField.hidden = NO;
            
            long sum = [DataCenter shareDataCenter].commentMessage + [DataCenter shareDataCenter].sysMessage;
            NSString *msg = [[NSString alloc] initWithFormat:@"%ld", sum];
            
            CGSize textSize = [msg sizeWithFont:[UIFont systemFontOfSize:12]];
            if (textSize.width < 10) {
                textSize.width = 10;
            }
            badgeField.frame = CGRectMake(50,
                                          5,
                                          textSize.width + 6,
                                          16);
            badgeField.text = msg;
            [msg release];
            
        } else {
            badgeField.hidden = YES;
        }

    }
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        MyQRViewController *qCtr = [[MyQRViewController alloc] init];
        [ctr pushViewController:qCtr animation:ViewSwitchAnimationBounce];
        [qCtr release];
    } else if (indexPath.row == 1)
    {
        NotificationCenterViewController *nCtr = [[NotificationCenterViewController alloc] init];
        [ctr pushViewController:nCtr animation:ViewSwitchAnimationBounce];
        [nCtr release];
//    } else if (indexPath.row == 2) {
//        LessonBoughtViewController *lCtr = [[LessonBoughtViewController alloc] init];
//        [ctr pushViewController:lCtr animation:ViewSwitchAnimationBounce];
//        [lCtr release];
    }
    else if (indexPath.row == 2)
    {
        LikeGalleryViewController *lCtr = [[LikeGalleryViewController alloc] init];
        [ctr pushViewController:lCtr animation:ViewSwitchAnimationBounce];
        [lCtr release];
    } else if (indexPath.row == 3)
    {
        ScanQRViewController *sCtr = [[ScanQRViewController alloc] init];
        [ctr pushViewController:sCtr animation:ViewSwitchAnimationBounce];
        [sCtr release];
    }
    
}


#pragma mark pull table view delegate
- (void)pullTableViewDidTriggerRefresh:(PullTableView*)pullTableView {
    [self loadUserDetail];
}

- (void)pullTableViewDidTriggerLoadMore:(PullTableView*)pullTableView {
    
}


#pragma mark accountview delegate
- (void)editUserDetail {
    if ([ConfigManager me].userId) {
        EditViewController *eCtr = [[EditViewController alloc] initWithCallback:^(bool succeeded) {
            if (succeeded) {
                [self loadUserDetail];
            }
        }];
        [ctr pushViewController:eCtr animation:ViewSwitchAnimationBounce];
        [eCtr release];
    }
}

- (void)showPicture {
    if ([ConfigManager me].userId) {
        SelfGalleryViewController *sCtr = [[SelfGalleryViewController alloc] init];
        [ctr pushViewController:sCtr animation:ViewSwitchAnimationBounce];
        [sCtr release];
    }
}

- (void)showFriend {
    if ([ConfigManager me].userId) {
        FriendViewController *fCtr = [[FriendViewController alloc] initWithUser:[ConfigManager me].userId];
        [ctr pushViewController:fCtr animation:ViewSwitchAnimationBounce];
        [fCtr release];
    }
}

- (void)showFan {
    if ([ConfigManager me].userId) {
        FanViewController *fCtr = [[FanViewController alloc] initWithUser:[ConfigManager me].userId];
        [ctr pushViewController:fCtr animation:ViewSwitchAnimationBounce];
        [fCtr release];
    }
}

- (void)editUserHome {
    if ([ConfigManager me].userId) {
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"修改背景"
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                             destructiveButtonTitle:nil
                                                  otherButtonTitles:@"修改", nil];
        [sheet showInView:self.view];
        [sheet release];
    }
}

- (void)userLogin {
    self.needRefresh = YES;
    
    WelcomeViewController *wCtr = [[WelcomeViewController alloc] init];
    [ctr pushViewController:wCtr animation:ViewSwitchAnimationBounce];
    [wCtr release];
}


#pragma mark uiactionsheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        ImagePickerController *imgPicker = [[ImagePickerController alloc] initWithCallback:^(UIImage *image) {
            [UI showIndicator];
            UserTask *task = [[UserTask alloc] initEditHome:image];
            task.logicCallbackBlock = ^(bool successful, id userinfo) {
                [UI hideIndicator];
                if (successful) {
                    UserTask *task = [[UserTask alloc] initUserDetail:[ConfigManager me].userId];
                    [TaskQueue addTaskToQueue:task];
                    [task release];
                    
                    [header setImage:image];
                }
            };
            [TaskQueue addTaskToQueue:task];
            [task release];
        } editable:YES];
        [ctr pushViewController:imgPicker animation:ViewSwitchAnimationSwipeR2L];
        [imgPicker release];
    }
}


- (void)reloadData {
    [funcTable reloadData];
}

@end
