//
//  ScanQRViewController.m
//  baby
//
//  Created by zhang da on 14-4-19.
//  Copyright (c) 2014年 zhang da. All rights reserved.
//

#import "ScanQRViewController.h"
#import "UIButtonExtra.h"
#import "ImageView.h"
#import "User.h"
#import "ScanView.h"

#import "UserTask.h"
#import "LKTask.h"
#import "TaskQueue.h"
#import "RegexManager.h"

#define URL_TAG 898989
#define PHONE_TAG 78788


@interface ScanQRViewController ()

@property (nonatomic, assign) long userId;
@property (nonatomic, retain) NSString *scanContent;

@end


@implementation ScanQRViewController




- (id)init {
    self = [super init];
    if (self) {
        ZBarImageScanner *scanner = [[ZBarImageScanner alloc] init];
        [scanner setSymbology:ZBAR_I25 config:ZBAR_CFG_ENABLE to:0];
        ZBarReaderView *reader = [[ZBarReaderView alloc] initWithImageScanner:scanner];
        [scanner release];
        reader.tracksSymbols = NO;
        
        reader.readerDelegate = self;
        reader.tracksSymbols = NO;
        //reader.frame = CGRectMake(0, 44, 320, 320);
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
            reader.frame = CGRectMake(0, 44, 320, 364);
        } else {
            reader.frame = CGRectMake(0, 44, 320, 320);
        }
        
        reader.torchMode = 0;
        dispatch_async(dispatch_get_main_queue(), ^{
            [reader start];
        });
        [self.view addSubview:reader];
        [reader release];
        
        mask = [[ScanView alloc] initWithFrame:CGRectMake(40, 40, 240, 240)];
        [reader addSubview:mask];
        mask.layer.borderColor = [UIColor greenColor].CGColor;
        mask.layer.borderWidth = 2;
        [mask release];
        [mask startAnimation];

        UILabel *info = [[UILabel alloc] initWithFrame:CGRectMake(0, 341, 320, 14)];
        info.font = [UIFont systemFontOfSize:12];
        info.textAlignment = NSTextAlignmentCenter;
        info.text = @"将二维码放入框内，即可自动扫描";
        info.backgroundColor = [UIColor clearColor];
        info.textColor = [UIColor whiteColor];
        [self.view addSubview:info];
        [info release];
        
        avatar = [[ImageView alloc] init];
        avatar.frame = CGRectMake(20, 384, 60, 60);
        avatar.clipsToBounds = YES;
        avatar.image = [UIImage imageNamed:@"baby_logo.png"];
        avatar.layer.cornerRadius = 30;
        avatar.layer.borderColor = [UIColor colorWithRed:234/255.0 green:166/255.0 blue:31/255.0 alpha:1].CGColor;
        avatar.layer.borderWidth = 2;
        [self.view addSubview:avatar];
        [avatar release];
        
        addFriendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        addFriendBtn.frame = CGRectMake(100, 395, 200, 40);
        addFriendBtn.backgroundColor = [UIColor colorWithRed:234/255.0 green:166/255.0 blue:31/255.0 alpha:1];
        [addFriendBtn setTitle:@"请扫描二维码" forState:UIControlStateNormal];
        [addFriendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        addFriendBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        addFriendBtn.layer.cornerRadius = 4.0;
        addFriendBtn.layer.masksToBounds = YES;
        addFriendBtn.titleLabel.textAlignment = UITextAlignmentCenter;
        [addFriendBtn addTarget:self action:@selector(addFriend) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:addFriendBtn];

    }
    return self;
}

- (void)dealloc
{
    self.scanContent = nil;
    [mask stopAnimation];
    [super dealloc];
}



- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [Shared bbRealWhite];
    
    [self setViewTitle:@"扫码加好友"];
    bbTopbar.backgroundColor = [UIColor colorWithRed:234/255.0 green:166/255.0 blue:31/255.0 alpha:1];
    
    UIButton *back = [UIButton buttonWithCustomStyle:CustomButtonStyleBack];
    [back addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [bbTopbar addSubview:back];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark ui event
- (void)back
{
    [ctr popViewControllerAnimated:YES];
}

- (void) readerView:(ZBarReaderView *)readerView
     didReadSymbols:(ZBarSymbolSet *)symbols
          fromImage:(UIImage *)image
{
    
    NSString *uidString = nil;
    
    if (symbols)
    {
        for (ZBarSymbol *symbol in symbols)
        {
            uidString = symbol.data;
            break;
        }
    }
    
    if (uidString)
    {
        long userId = (long)[uidString longLongValue];
        
        if ([RegexManager isPhoneNum:uidString]) {
            self.scanContent = uidString;
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                            message:[NSString stringWithFormat:@"拨打 %@ ?", uidString]
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:@"拨打", nil];
            alert.tag = PHONE_TAG;
            [alert show];
            [alert release];
        } else if ([RegexManager isUrl:uidString]) {
            self.scanContent = uidString;
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                            message:[NSString stringWithFormat:@"打开 %@ ?", uidString]
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:@"打开", nil];
            alert.tag = URL_TAG;
            [alert show];
            [alert release];
        } else if (userId > 0 ) {
            [mask stopAnimation];
            
            UserTask *task = [[UserTask alloc] initUserDetail:userId];
            [UI showIndicator];
            task.logicCallbackBlock = ^(bool successful, id userInfo) {
                if (successful) {
                    self.userId = userId;
                    
                    User *user = [User getUserWithId:userId];
                    if (user.avatarMid) {
                        avatar.imagePath = user.avatarMid;
                    }
                    [addFriendBtn setTitle:[NSString stringWithFormat:@"关注  %@", user.showName]
                                  forState:UIControlStateNormal];
                } else {
                    [UI showAlert:@"用户信息无效"];
                }
                [UI hideIndicator];
                [mask startAnimation];
            };
            [TaskQueue addTaskToQueue:task];
            [task release];
        } else {
            [UI showAlert:@"请扫描宝贝计画内的二维码"];
        }
    }
    
}
- (void)addFriend {
    if (self.userId) {
        LKTask *task = [[LKTask alloc] initUserRelation:self.userId follow:YES];
        [UI showIndicator];
        
        NSLog(@"uuuuuuuuuuuuuuuuuuuuuu%ld",self.userId);
        
        
        task.logicCallbackBlock = ^(bool successful, id userInfo) {
            if (successful) {
                [UI showAlert:@"关注成功"];
                
                
                
                //扫码获取的被扫码者ID
                NSLog(@"user camera   %ld",_userId);
                //扫码获取的被扫码者ID
                
                } else {
                [UI showAlert:@"关注失败，请稍后重试"];
            }
            [UI hideIndicator];
        };
        [TaskQueue addTaskToQueue:task];
        [task release];
    }
    else
    {
        [UI showAlert:@"请先扫描二维码"];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        if (alertView.tag == URL_TAG) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.scanContent]];
        } else if (alertView.tag == PHONE_TAG) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", self.scanContent]]];
        }
    }
    self.scanContent = nil;
}

@end
