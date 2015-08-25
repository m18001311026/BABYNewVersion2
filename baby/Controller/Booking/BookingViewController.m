//
//  BookingViewController.m
//  baby
//
//  Created by zhang da on 14-4-16.
//  Copyright (c) 2014年 zhang da. All rights reserved.
//

#import "BookingViewController.h"
#import "UIButtonExtra.h"

#import "OnlineBookingViewController.h"
#import "UIBlockSheet.h"

@interface BookingViewController ()

@end

@implementation BookingViewController

- (void)dealloc {
    
    [super dealloc];
}

- (id)init {
    self = [super init];
    if (self) {
        UIButton *back = [UIButton buttonWithCustomStyle:CustomButtonStyleBack];
        [back addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        [bbTopbar addSubview:back];
        
        UIButton *byPhone = [UIButton simpleButton:@"电话预约" y:60];
        [byPhone addTarget:self action:@selector(bookingByPhone) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:byPhone];
        
        UIButton *byOnline = [UIButton simpleButton:@"在线预约" y:120];
        [byOnline addTarget:self action:@selector(bookingOnline) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:byOnline];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setViewTitle:@"预约试听"];
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

- (void)bookingByPhone {
    UIBlockSheet *sheet = [[UIBlockSheet alloc] initWithTitle:@"确认电话预约？"];
    [sheet addButtonWithTitle:@"拨打" block: ^{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", @"4008008350"]]];
    }];
    [sheet setCancelButtonWithTitle: @"取消" block: ^{}];
    [sheet showInView:self.view];
    [sheet release];
}

- (void)bookingOnline {
    OnlineBookingViewController *oCtr = [[OnlineBookingViewController alloc] init];
    [ctr pushViewController:oCtr animation:ViewSwitchAnimationSwipeR2L];
    [oCtr release];
}


@end
