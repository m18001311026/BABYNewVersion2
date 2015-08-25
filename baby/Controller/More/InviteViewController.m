//
//  InviteViewController.m
//  baby
//
//  Created by zhang da on 14-5-8.
//  Copyright (c) 2014年 zhang da. All rights reserved.
//

#import "InviteViewController.h"
#import "UIButtonExtra.h"
#import <ShareSDK/ShareSDK.h>
#import "ShareManager.h"
#import "ContactShareViewController.h"

#define IMAGE_TAG 88888
#define TITLE_TAG 77777
#define ROW_HEIGHT 44

@interface InviteViewController ()

@end

@implementation InviteViewController

- (void)dealloc {
    [super dealloc];
}

- (id)init {
    self = [super init];
    if (self) {
        self.view.backgroundColor = [Shared bbRealWhite];
        
        inviteTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, 320, screentContentHeight - 44)
                                                 style:UITableViewStylePlain];
        inviteTable.delegate = self;
        inviteTable.dataSource = self;
        inviteTable.backgroundColor = [UIColor clearColor];
        if ([inviteTable respondsToSelector:@selector(setSeparatorInset:)]) {
            [inviteTable setSeparatorInset:UIEdgeInsetsZero];
        }
        [inviteTable setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
        inviteTable.separatorColor = [Shared bbLightGray];
        [self.view addSubview:inviteTable];
        [inviteTable release];

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Custom initialization
    self.view.backgroundColor = [UIColor whiteColor];

    [self setViewTitle:@"邀请好友"];
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
- (void)back {
    [ctr popViewControllerAnimated:YES];
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
        title.textColor = [UIColor grayColor];
        title.backgroundColor = [UIColor clearColor];
        [cell addSubview:title];
        [title release];
    }
    
    UIImageView *image = (UIImageView *)[cell viewWithTag:IMAGE_TAG];
    UILabel *title = (UILabel *)[cell viewWithTag:TITLE_TAG];
    
    switch (indexPath.row) {
        case 0:
            image.image = [UIImage imageNamed:@"weixin.png"];
            title.text = @"微信";
            break;
        case 1:
            image.image = [UIImage imageNamed:@"sinaweibo.png"];
            title.text = @"新浪微博";
            break;
        case 2:
            image.image = [UIImage imageNamed:@"qq.png"];
            title.text = @"QQ";
            break;
        case 3:
            image.image = [UIImage imageNamed:@"sms.png"];
            title.text = @"通讯录";
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
    if (indexPath.row == 3) {
        ContactShareViewController *cCtr = [[ContactShareViewController alloc] init];
        [ctr pushViewController:cCtr animation:ViewSwitchAnimationSwipeR2L];
        [cCtr release];
        return;
    }
    
    ShareType type = ShareTypeSinaWeibo;
    if (indexPath.row == 0) {
        type = ShareTypeWeixiSession;
    } else if (indexPath.row == 1) {
        type = ShareTypeSinaWeibo;
    } else if (indexPath.row == 2) {
        type = ShareTypeQQ;
    } else if (indexPath.row == 3) {
        type = ShareTypeSMS;
    }
    [[ShareManager me] inviteFrom:type
                          content:[NSString stringWithFormat:@"快来加入宝贝计画吧！%@", HOMEPAGE]
                            title:@"宝贝计画"
                            image:[UIImage imageNamed:@"icon_120"]
                          pageUrl:HOMEPAGE];
}


@end
