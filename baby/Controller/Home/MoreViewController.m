//
//  MoreViewController.m
//  baby
//
//  Created by zhang da on 14-4-1.
//  Copyright (c) 2014年 zhang da. All rights reserved.
//

#import "MoreViewController.h"
#import "UIButtonExtra.h"
#import "ConfigManager.h"
#import "WelcomeViewController.h"

#import "SchoolViewController.h"
#import "DiscoveryViewController.h"
#import "TopicViewController.h"
#import "BookingViewController.h"
#import "SettingViewController.h"
#import "FeedbackViewController.h"
#import "AboutViewController.h"
#import "InviteViewController.h"

#import "Macro.h"
#define IMAGE_TAG 88888
#define TITLE_TAG 77777
#define ROW_HEIGHT 44


@interface MoreViewController ()

@end

@implementation MoreViewController


- (void)dealloc {
    [super dealloc];
}

- (id)init {
    self = [super init];
    if (self) {
        
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"morebg.jpg"]];
        
        moreTable = [[UITableView alloc] initWithFrame:CGRectMake(5,
                                                                  iOS7? 20: 0,
                                                                  260,
                                                                  ROW_HEIGHT*9 + 1)
                                                 style:UITableViewStylePlain];
        moreTable.delegate = self;
        moreTable.dataSource = self;
        moreTable.backgroundColor = [UIColor clearColor];
        if ([moreTable respondsToSelector:@selector(setSeparatorInset:)]) {
            [moreTable setSeparatorInset:UIEdgeInsetsZero];
        }
        [moreTable setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
        moreTable.separatorColor = [UIColor whiteColor];
        [self.view addSubview:moreTable];
        moreTable.tableFooterView = [[[UIView alloc] init] autorelease];
        [moreTable release];
        
        logout = [UIButton simpleButton:@"注销" y:screentHeight - 48];
        logout.frame = CGRectMake(10, screentHeight - (iOS7? 0: 20) - 48, 250, 36);
        [logout addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:logout];

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (BOOL)showTopbar {
    return NO;
}


#pragma table view section
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"morecell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(5, 7, 30, 30)];
        img.userInteractionEnabled = NO;
        img.tag = IMAGE_TAG;
        [cell addSubview:img];
        [img release];
        
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(44, 13, 280, 18)];
        title.tag = TITLE_TAG;
        title.font = [UIFont systemFontOfSize:16];
        title.textColor = [UIColor whiteColor];
        title.backgroundColor = [UIColor clearColor];
        [cell addSubview:title];
        [title release];
    }
    
    UIImageView *image = (UIImageView *)[cell viewWithTag:IMAGE_TAG];
    UILabel *title = (UILabel *)[cell viewWithTag:TITLE_TAG];
    
    switch (indexPath.row) {
       /* case 0:
            image.image = [UIImage imageNamed:@"discovery.png"];
            title.text = @"发现";
            break;*/
       /* case 1:
            image.image = [UIImage imageNamed:@"category.png"];
            title.text = @"分类";
            break;*/
//        case 0:
//            image.image = [UIImage imageNamed:@"school.png"];
//            title.text = @"全国分校";
//            break;
//        case 0:
//            image.image = [UIImage imageNamed:@"discovery.png"];
//            title.text = @"活动";
//            break;
//        case 0:
//            image.image = [UIImage imageNamed:@"invite.png"];
//            title.text = @"邀请好友";
//            break;
        case 0:
            image.image = [UIImage imageNamed:@"setting.png"];
            title.text = @"设置";
            break;
        case 1:
            image.image = [UIImage imageNamed:@"feedback.png"];
            title.text = @"意见反馈";
            break;
        case 2:
            image.image = [UIImage imageNamed:@"comment.png"];
            title.text = @"五星评价";
            break;
        case 3:
            image.image = [UIImage imageNamed:@"about.png"];
            title.text = @"关于";
            break;
        default:
            break;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ROW_HEIGHT;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    /*
    if (indexPath.row == 0) {
        DiscoveryViewController *dCtr = [[DiscoveryViewController alloc] init];
        [ctr pushViewController:dCtr animation:ViewSwitchAnimationBounce];
        [dCtr release];
    }*/
  /*  if (indexPath.row == 1) {
        TopicViewController *tCtr = [[TopicViewController alloc] init];
        [ctr pushViewController:tCtr animation:ViewSwitchAnimationBounce];
        [tCtr release];
    }*/
    /*
    if (indexPath.row == 0) {
        SchoolViewController *sCtr = [[SchoolViewController alloc] init];
        [ctr pushViewController:sCtr animation:ViewSwitchAnimationBounce];
        [sCtr release];
    }
    
    if (indexPath.row == 1) {
        BookingViewController *bCtr = [[BookingViewController alloc] init];
        [ctr pushViewController:bCtr animation:ViewSwitchAnimationBounce];
        [bCtr release];
    }
     */
//    if (indexPath.row == 0) {
//        InviteViewController *iCtr = [[InviteViewController alloc] init];
//        [ctr pushViewController:iCtr animation:ViewSwitchAnimationBounce];
//        [iCtr release];
//    }
    if (indexPath.row == 0) {
        SettingViewController *sCtr = [[SettingViewController alloc] init];
        [ctr pushViewController:sCtr animation:ViewSwitchAnimationBounce];
        [sCtr release];
    }
    if (indexPath.row == 1) {
        FeedbackViewController *sCtr = [[FeedbackViewController alloc] init];
        [ctr pushViewController:sCtr animation:ViewSwitchAnimationBounce];
        [sCtr release];
    }
    if (indexPath.row == 2) {
        NSString *rateUrl = [NSString stringWithFormat:
                             @"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=%@"
                             @"&onlyLatestVersion=true&pageNumber=0&sortOrdering=1&type=Purple+Software", APPID];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:rateUrl]];
    }
    if (indexPath.row == 3) {
        AboutViewController *sCtr = [[AboutViewController alloc] init];
        [ctr pushViewController:sCtr animation:ViewSwitchAnimationBounce];
        [sCtr release];
    }
}

- (void)logout {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                    message:@"确认注销？"
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"注销", nil];
    [alert show];
    [alert release];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        //[self.view removeFromSuperview];
        
        WelcomeViewController *wCtr = [[WelcomeViewController alloc] init];
        [ctr pushViewController:wCtr animation:ViewSwitchAnimationBounce];
        [wCtr release];
    }
}


@end
