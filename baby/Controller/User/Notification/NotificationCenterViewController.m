//
//  LessonViewController.m
//  baby
//
//  Created by zhang da on 14-3-3.
//  Copyright (c) 2014年 zhang da. All rights reserved.
//

#import "NotificationCenterViewController.h"
#import "UIButtonExtra.h"
#import "NotificationSysViewController.h"
#import "NotificationAtViewController.h"
#import "NotificationCommentViewController.h"

#import "NotificationTask.h"
#import "TaskQueue.h"

#import "Notification.h"
#import "DataCenter.h"

#define TITLE 90900
#define DETAIL 89808
#define TIME 99999

#define POPDETAIL 90909
#define POPTITLE 77777

@interface NotificationCenterViewController ()

@end



@implementation NotificationCenterViewController {
    
    UITextField *userBadgeView;
    UITextField *sysBadgeView;
    
    UIButton *_sysBtn;
    UIButton *_userBtn;
}

- (void)dealloc {

    [userBadgeView release];
    [sysBadgeView release];
    [super dealloc];
}

- (id)init {
    self = [super init];
    if (self) {
        self.view.backgroundColor = [Shared bbRealWhite];

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
    
    [self setViewTitle:@"消息中心"];
    bbTopbar.backgroundColor = [UIColor colorWithRed:234/255.0 green:166/255.0 blue:31/255.0 alpha:1];
    
    // 评论通知按钮
    _userBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _userBtn.tag = 1001;
    _userBtn.frame = CGRectMake(0,44, kScreen_width, 44);
    [_userBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_userBtn];
    
    userBadgeView = [[UITextField alloc] init];
    
    userBadgeView.backgroundColor = [UIColor redColor];
    userBadgeView.textColor = [UIColor whiteColor];
    //        userBadgeView.layer.borderColor = [UIColor whiteColor].CGColor;
    //        userBadgeView.layer.borderWidth = 1;
    userBadgeView.layer.cornerRadius = 8;
    userBadgeView.layer.masksToBounds = YES;
    userBadgeView.textAlignment = NSTextAlignmentCenter;
    userBadgeView.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    userBadgeView.userInteractionEnabled = NO;
    userBadgeView.font = [UIFont systemFontOfSize:12];
    [_userBtn addSubview:userBadgeView];
    
    UILabel *userLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 70, 44)];
    userLabel.text = @"评论通知";
    userLabel.font = [UIFont systemFontOfSize:16];
    userLabel.textColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1];
    [_userBtn addSubview:userLabel];
    [userLabel release];
    
    UIView *userLineView = [[UIView alloc] initWithFrame:CGRectMake(10, 43.5, kScreen_width, 0.5)];
    userLineView.backgroundColor = [UIColor blackColor];
    [_userBtn addSubview:userLineView];
    [userLineView release];

    
    // 系统通知按钮
    _sysBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _sysBtn.tag = 1002;
    _sysBtn.frame = CGRectMake(0, 88, kScreen_width, 44);
    [_sysBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_sysBtn];
    
    
    sysBadgeView.backgroundColor = [UIColor redColor];
    sysBadgeView.textColor = [UIColor whiteColor];
    //        sysBadgeView.layer.borderColor = [UIColor whiteColor].CGColor;
    //        sysBadgeView.layer.borderWidth = 1;
    sysBadgeView.layer.cornerRadius = 8;
    sysBadgeView.layer.masksToBounds = YES;
    sysBadgeView.textAlignment = NSTextAlignmentCenter;
    sysBadgeView.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    sysBadgeView.userInteractionEnabled = NO;
    sysBadgeView.font = [UIFont systemFontOfSize:12];
    [_sysBtn addSubview:sysBadgeView];
    
    UILabel *sysLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 70, 44)];
    sysLabel.text = @"系统通知";
    sysLabel.font = [UIFont systemFontOfSize:16];
    sysLabel.textColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1];
    [_sysBtn addSubview:sysLabel];
    [sysLabel release];
    
    
    UIView *sysLineView = [[UIView alloc] initWithFrame:CGRectMake(10, 43.5, kScreen_width, 0.5)];
    sysLineView.backgroundColor = [UIColor blackColor];
    [_sysBtn addSubview:sysLineView];
    [sysLineView release];
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    long sysbadge = [DataCenter shareDataCenter].sysMessage;
    long userbadge = [DataCenter shareDataCenter].commentMessage;
    
    if (userbadge != 0) {
        
        NSString *text;
        
//        if (userbadge.longValue > 99) {
//            text = @"99+";
//        } else {
            text = [NSString stringWithFormat:@"%ld", userbadge];
//        }
        
        CGSize textSize = [text sizeWithFont:[UIFont systemFontOfSize:12]];
        
        
        if (textSize.width < 10) {
            textSize.width = 10;
        }
        userBadgeView.frame = CGRectMake(75,
                                         5,
                                         textSize.width + 6,
                                         16);
        userBadgeView.text = text;
        
        userBadgeView.hidden = NO;
    } else {
        userBadgeView.hidden = YES;
    }

    
    if (sysBadgeView == nil) {
        sysBadgeView = [[UITextField alloc] init];
            }
    if (sysbadge != 0) {
        
        NSString *text;
        
//        if (sysbadge.integerValue > 99) {
//            text = @"99+";
//        } else {
            text = [NSString stringWithFormat:@"%ld", sysbadge];
//        }
        
        CGSize textSize = [text sizeWithFont:[UIFont systemFontOfSize:12]];
        
        
        if (textSize.width < 10) {
            textSize.width = 10;
        }
        sysBadgeView.frame = CGRectMake(75,
                                      5,
                                      textSize.width + 6,
                                      16);
        sysBadgeView.text = text;
        
        sysBadgeView.hidden = NO;
    } else {
        sysBadgeView.hidden = YES;
    }
    
}


#pragma ui event

- (void)back {
    [ctr popViewControllerAnimated:YES];
}

- (void)btnClick:(UIButton *)btn {
    
    if (btn.tag == 1001) {

        NotificationCommentViewController *nctr = [[NotificationCommentViewController alloc] init];
        [ctr pushViewController:nctr animation:ViewSwitchAnimationSwipeR2L];
        [nctr release];
    } else if (btn.tag == 1002) {
        NotificationSysViewController *nctr = [[NotificationSysViewController alloc] init];
        [ctr pushViewController:nctr animation:ViewSwitchAnimationSwipeR2L];
        [nctr release];

    }
}

@end
