//
//  MyQRViewController.m
//  baby
//
//  Created by zhang da on 14-4-18.
//  Copyright (c) 2014年 zhang da. All rights reserved.
//

#import "MyQRViewController.h"
#import "UIButtonExtra.h"
#import "zbar.h"
#import "ConfigManager.h"
#import "UIImage+MDQRCode.h"
#import "ImageView.h"

#import "UserTask.h"
#import "TaskQueue.h"
#import "User.h"

@interface MyQRViewController () {
    ImageView *avatar;
    UIImageView *qrView;
    UIImageView *bgView;
    
    UILabel *userNameLabel, *ageLabel;
}

@end


@implementation MyQRViewController

- (void)dealloc {
    
    [super dealloc];
}

- (id)init {
    self = [super init];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    avatar = [[ImageView alloc] init];
    avatar.frame = CGRectMake(20, 54, 50, 50);
    avatar.clipsToBounds = YES;
    avatar.layer.cornerRadius = 25;
    avatar.layer.borderColor = [UIColor colorWithRed:234/255.0 green:166/255.0 blue:31/255.0 alpha:1].CGColor;
    avatar.layer.borderWidth = 2;
    [self.view addSubview:avatar];
    [avatar release];
    
    userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 60, 46+30, 16)];
    userNameLabel.backgroundColor = [UIColor clearColor];
    userNameLabel.font = [UIFont systemFontOfSize:15];
    userNameLabel.textColor = [UIColor darkGrayColor];
    [self.view addSubview:userNameLabel];
    [userNameLabel release];
    
    ageLabel = [[UILabel alloc] initWithFrame:CGRectMake(81, 84, 46, 14)];
    ageLabel.backgroundColor = [UIColor clearColor];
    ageLabel.font = [UIFont systemFontOfSize:12];
    ageLabel.textColor = [UIColor grayColor];
    [self.view addSubview:ageLabel];
    [ageLabel release];

    bgView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 119, 280, 280)];
    bgView.backgroundColor = [UIColor clearColor];
    //bgView.image = [UIImage imageNamed:@"qrbg"];
    [self.view addSubview:bgView];
    [bgView release];
    
//    qrView = [[UIImageView alloc] initWithFrame:CGRectMake(60, 48, 164, 164)];
    qrView = [[UIImageView alloc] initWithFrame:CGRectMake(40, 28, 204, 204)];
    qrView.backgroundColor = [UIColor clearColor];
    [bgView addSubview:qrView];
    [qrView release];
    
    UILabel *info = [[UILabel alloc] initWithFrame:
                     CGRectMake(20, bgView.frame.origin.y + bgView.frame.size.height + (screentContentHeight - bgView.frame.origin.y - bgView.frame.size.height - 14)/2, 280, 14)];
    info.textAlignment = NSTextAlignmentCenter;
    info.backgroundColor = [UIColor clearColor];
    info.textColor = [UIColor lightGrayColor];
    info.font = [UIFont systemFontOfSize:13];
    info.text = @"扫一扫二维码图案，添加我为好友";
    [self.view addSubview:info];
    [info release];
    
    self.view.backgroundColor = [Shared bbRealWhite];

    [self setViewTitle:@"我的二维码"];
    bbTopbar.backgroundColor = [UIColor colorWithRed:234/255.0 green:166/255.0 blue:31/255.0 alpha:1];
    
    UIButton *back = [UIButton buttonWithCustomStyle:CustomButtonStyleBack];
    [back addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [bbTopbar addSubview:back];
    
//    qrView.image = [UIImage mdQRCodeForString:[NSString stringWithFormat:@"%ld", [ConfigManager me].userId]
//                                         size:1000
//                                    fillColor:[UIColor colorWithRed:1.0f green:53/255.0f blue:186/255.0f alpha:1]];
    qrView.image = [UIImage mdQRCodeForString:[NSString stringWithFormat:@"%ld", [ConfigManager me].userId]
                                         size:1000
                                    fillColor:[UIColor blackColor]];
    
    [self updateLayout];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark ui event
- (void)back {
    [ctr popViewControllerAnimated:YES];
}

- (void)updateLayout {
    if ([ConfigManager me].userId) {
        User *user = [User getUserWithId:[ConfigManager me].userId];
        if (user) {
            avatar.imagePath = user.avatarMid;
            userNameLabel.text = [user showName];
            ageLabel.text = [NSString stringWithFormat:@"%d岁", user.age];
        } else {
            UserTask *task = [[UserTask alloc] initUserDetail:[ConfigManager me].userId];
            task.logicCallbackBlock = ^(bool successful, id userInfo) {
                if (successful) {
                    User *user = [User getUserWithId:[ConfigManager me].userId];
                    avatar.imagePath = user.avatarMid;
                    userNameLabel.text = [user showName];
                    ageLabel.text = [NSString stringWithFormat:@"%d岁", user.age];
                }
            };
            [TaskQueue addTaskToQueue:task];
            [task release];
        }
    }
}


@end
