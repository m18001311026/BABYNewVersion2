//
//  HomeViewController.m
//  CustomTabbarController
//
//  Created by zhang da on 12-8-14.
//  Copyright (c) 2012年 zhang da. All rights reserved.
//

#import "RootViewController.h"
#import "UIColorExtra.h"
#import "UploadViewController.h"
#import "RotateMenuView.h"
#import "RotateNormalMenuItemButton.h"
#import "LocationManager.h"

#import "ConfigManager.h"
#import "GeoTask.h"
#import "SystemTask.h"
#import "TaskQueue.h"

#import "AccountViewController.h"

#import "FinderViewController.h"
#import "DataCenter.h"
#import "UserTask.h"

#import "User.h"
#import "THObserver.h"
#import "Macro.h"
#import "UIColor+Application.h"

@implementation RootViewController {
    AccountViewController *_accountVC;
    FinderViewController *_finderVC;
    TabbarItem *_item2;
    TabbarItem *_item4;
    TabbarItem *_item5;
}
- (void)dealloc {
    
    [_item2 release];
    [_item4 release];
    [_item5 release];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[DataCenter shareDataCenter] removeObserver:self forKeyPath:@"newsysNotifications"];
    [[DataCenter shareDataCenter] removeObserver:self forKeyPath:@"newuserNotifications"];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {

        
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushToMessage) name:@"pushToMessage" object:nil];
        self.tabbar.backgroundColor = [UIColor whiteColor];
    //    self.tabbar.alpha=0.5;
        //chulijianTabbar颜色设置
        float tabbarItemwidth = kScreenWidth/5;
        
        UIColor *normalColor = [UIColor colorWithRed:83.0/255 green:83.0/255 blue:83.0/255 alpha:1];
        //---------------------
        TabbarItem *item1 = [[TabbarItem alloc] initWithFrame:CGRectMake(0*tabbarItemwidth, 2, tabbarItemwidth, 42)
                                                        title:@"宝盒"
                                                  normalImage:@"home_tab_onlineedu_normal.png"
                                            hightlightedImage:@"home_tab_onlineedu_selected.png"
                                                  normalColor:normalColor
                                            hightlightedColor:[UIColor applicationYellowColor]
                                                        index:0];
        [self addItem:item1];
        [item1 release];
        [self setViewController:@"LessonViewController" params:nil atIndex:0];
        
        //----------------------
        
        //----------------------
        _item2 = [[TabbarItem alloc] initWithFrame:CGRectMake(1*tabbarItemwidth, 2, tabbarItemwidth, 42)
                                                        title:@"作品"
                                                  normalImage:@"home_tab_my_normal.png"
                                            hightlightedImage:@"home_tab_my_selected.png"
                                                  normalColor:normalColor
                                            hightlightedColor:[UIColor applicationYellowColor]
                                                        index:1];
        [self addItem:_item2];
//        [self setViewController:@"AccountViewController" params:nil atIndex:1];
//        _accountVC = (AccountViewController*)[self viewControllerAtIndex:1];
        [self setViewController:@"HomeViewController" params:nil atIndex:1];
        //---------------------
        TabbarItem *item3 = [[TabbarItem alloc] initWithFrame:CGRectMake(2*tabbarItemwidth-5, 4, tabbarItemwidth+10, 42+10)
                                                        title:@""
                                                  normalImage:@"home_tab_publish_selected.png"
                                            hightlightedImage:@"tab_post_h.png"
                                                  normalColor:normalColor
                                            hightlightedColor:[UIColor r:83 g:83 b:83]
                                                        index:2];
        [self addItem:item3];
        [item3 release];
        //---------------------------
        _item4 = [[TabbarItem alloc] initWithFrame:CGRectMake(3*tabbarItemwidth, 2, tabbarItemwidth, 42)
                                                        title:@"发现"
                                                  normalImage:@"faxian.png.png"
                                            hightlightedImage:@"hfaxian.png.png"
                                                  normalColor:normalColor
                                            hightlightedColor:[UIColor applicationYellowColor]
                                                        index:3];
        [_item4 setBadge:nil];
        [self addItem:_item4];
        [_item4 release];
        [self setViewController:@"FinderViewController" params:nil atIndex:3];
        _finderVC = (FinderViewController *)[self viewControllerAtIndex:3];
       //--------------------------
        
        TabbarItem *item5 = [[TabbarItem alloc] initWithFrame:CGRectMake(4*tabbarItemwidth, 2, tabbarItemwidth, 42)
                                                        title:@"我的"
                                                  normalImage:@"home_tab_home_normal.png"
                                            hightlightedImage:@"home_tab_home_selected.png"
                                                  normalColor:normalColor
                                            hightlightedColor:[UIColor applicationYellowColor]
                                                        index:4];
        [_item5 setBadge:nil];
        [self addItem:item5];

        _item5=item5;
        [item5 release];
        [self setViewController:@"AccountViewController" params:nil atIndex:4];
        _accountVC = (AccountViewController*)[self viewControllerAtIndex:4];

        // _finderVC = (FinderViewController *)[self viewControllerAtIndex:4];

        // [self setViewController:@"HomeViewController" params:nil atIndex:4];
        
        //tabbar.hidden=YES;

        
        //----------------------------
        self.selectedPage = 0;
        
        
        [self uploadLocation];
        [self updateConfig];
        
        [NSTimer scheduledTimerWithTimeInterval:30
                                         target:self
                                       selector:@selector(timeAction)
                                       userInfo:nil
                                        repeats:YES];
        [self timeAction];
        
        
        [[DataCenter shareDataCenter] addObserver:self forKeyPath:@"sysMessage" options:NSKeyValueObservingOptionNew context:nil];
        [[DataCenter shareDataCenter] addObserver:self forKeyPath:@"commentMessage" options:NSKeyValueObservingOptionNew context:nil];
        [THObserver observerForObject:[DataCenter shareDataCenter] keyPath:@"activityMessage" oldAndNewBlock:^(id oldValue, id newValue) {
            //msg出处
            
            NSString *msg = [NSString stringWithFormat:@"%ld", [DataCenter shareDataCenter].activityMessage];
            if ([msg intValue] == 0)
            {
                _item5 = nil;
            }
            else
            {
                [_item5 setBadge:msg];
            }
            
            [_finderVC reloadData];
            
        }];
        
    }
    

    
    
    
    
    
    return self;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    UIButton * logoTobtn=[UIButton buttonWithType:UIButtonTypeCustom];
    logoTobtn.backgroundColor=[UIColor blackColor];
    logoTobtn.frame=CGRectMake(0, 480-49, 320, 49);
    
    
    [self.view addSubview:logoTobtn];
    
    [super viewWillAppear:animated];
    
  //  [self prefersStatusBarHidden];
    
}
- (BOOL)prefersStatusBarHidden
{
    return YES;
}



- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    
    if (([DataCenter shareDataCenter].commentMessage != 0) || ([DataCenter shareDataCenter].sysMessage != 0)) {
        // 显示小圆点
        
        NSLog(@"dataCenterInfo   %ld",[DataCenter shareDataCenter].commentMessage);
        
        long sum = [DataCenter shareDataCenter].commentMessage + [DataCenter shareDataCenter].sysMessage;
        NSString *msg = [[[NSString alloc] initWithFormat:@"%ld", sum] autorelease];
        [_item5 setBadge:msg];
        
        [_accountVC reloadData];
    } else {
        // 隐藏小圆点
        [_item5 setBadge:nil];
        [_accountVC reloadData];
    }
    
}

- (BOOL)tabbarItemShouldSelectAtIndex:(int)index {
    if (index == 2) {
        UploadViewController *uCtr = [[UploadViewController alloc] init];
        [ctr pushViewController:uCtr animation:ViewSwitchAnimationFade];
        [uCtr release];
        return NO;
    }
    return YES;
}

- (float)tabbarHeight
{
    return 49;
}

- (BOOL)subTabbarShouldScroll
{
    return NO;
}

- (void)newGalleryAdd
{
    self.selectedPage = 0;
}

- (void)newCommentAdd {
    self.selectedPage = 0;
}

- (void)uploadLocation {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        NSURL *url = [NSURL URLWithString:@"http://int.dpool.sina.com.cn/iplookup/iplookup.php?format=json"];
        NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url
                                                     cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                 timeoutInterval:10];
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        [request release];
        
        if (data) {
            id result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSString *city = [(NSDictionary *)result objectForKey:@"city"];
            NSLog(@"%@", city);
            
            GeoTask *task = [[GeoTask alloc] initUploadCity:city];
            [TaskQueue addTaskToQueue:task];
            [task release];   
        }
    });
}

- (void)updateConfig {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        SystemTask *vtask = [[SystemTask alloc] initGetVersion];
        [TaskQueue addTaskToQueue:vtask];
        [vtask release];
        
        SystemTask *ptask = [[SystemTask alloc] initPayConfig];
        [TaskQueue addTaskToQueue:ptask];
        [ptask release];
    });
}

- (void)timeAction
{
    
    long userId = [ConfigManager me].userId;
    
    UserTask *task = [[UserTask alloc] initUserDetail:userId];
    task.logicCallbackBlock = ^(bool succeeded, id userInfo) {
        
        if (succeeded) {
            
            User *user = (User *)userInfo;
            
            [DataCenter shareDataCenter].sysMessage = user.systemMessage;
            [DataCenter shareDataCenter].commentMessage = user.commentMessage;
            [DataCenter shareDataCenter].activityMessage = user.activityMessage;
        }
        
    };
    [TaskQueue addTaskToQueue:task];
    [task release];
    
}

-(void)pushToMessage
{
    NSLog(@"pushToMessage");
    self.selectedPage = 1;
}

@end
