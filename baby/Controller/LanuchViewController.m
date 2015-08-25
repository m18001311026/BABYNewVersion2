//
//  LanuchViewController.m
//  baby
//
//  Created by chenxin on 14-11-8.
//  Copyright (c) 2014年 zhang da. All rights reserved.
//

#import "LanuchViewController.h"
#import <sys/utsname.h>
#import "AccountViewController.h"

// (chenxin)

@interface LanuchViewController () {
    //进入应用页面
    UIImageView *imgView;
}

@end

@implementation LanuchViewController

- (void)dealloc {
    
    [imgView release];
    
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(pushToMessage) name:@"pushToMessage" object:nil];
    
    NSString *dveiceName = [self getDeviceAndOSInfo];
    
    NSString *imageName;
    if ([dveiceName isEqualToString:@"iPhone3,1"] || [dveiceName isEqualToString:@"iPhone3,2"] || [dveiceName isEqualToString:@"iPhone4,1"]) {
        imageName = @"640-960-pic.jpg";
    }
    else if ([dveiceName isEqualToString:@"iPhone5,1"] || [dveiceName isEqualToString:@"iPhone5,2"] || [dveiceName isEqualToString:@"iPhone5,3"] || [dveiceName isEqualToString:@"iPhone5,4"] || [dveiceName isEqualToString:@"iPhone6,1"] || [dveiceName isEqualToString:@"iPhone6,2"]) {
        imageName = @"640-1136-pic.jpg";
    }
    else if ([dveiceName isEqualToString:@"iPhone7,1"]) {
        imageName = @"750-1334-pic.jpg";
    }
    else if ([dveiceName isEqualToString:@"iPhone7,2"]) {
        imageName = @"1242-2208-pic.jpg";
    } else {
        imageName = @"640-960-pic.jpg";
    }
    
    imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    imgView.frame = CGRectMake(0, 0, 320, kScreen_height);
    [self.view addSubview:imgView];
    
    [self showLanchView];
    //chulijianLanch
}


- (NSString *)getDeviceAndOSInfo
{
    //here use sys/utsname.h
    struct utsname systemInfo;
    uname(&systemInfo);
    //get the device model and the system version
    return [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//chulijianzhousan
- (void)timerAction {
    self.view.hidden = YES;
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [[UIApplication sharedApplication] setIdleTimerDisabled: NO];
    self.afterLanuchView();
}

- (void)showLanchView {
    
    self.view.hidden = YES;
    
    [[UIApplication sharedApplication].delegate.window bringSubviewToFront:self.view];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(timerAction) userInfo:nil repeats:NO];

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)pushToMessage
{
    
}
@end
