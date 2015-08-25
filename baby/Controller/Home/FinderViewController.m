//
//  FinderViewController.m
//  baby
//
//  Created by chenxin on 14-11-11.
//  Copyright (c) 2014年 zhang da. All rights reserved.
//

#import "FinderViewController.h"
#import "TopicViewController.h"
#import "DiscoveryViewController.h"
#import "CartViewController.h"
#import "Shared.h"
#import "UIColor+Application.h"
#import "WebViewController.h"
#import "DataCenter.h"
#import "UIColor+Application.h"

@interface FinderViewController ()

@end

@implementation FinderViewController {
    UITableView *_tableView;
}

- (void)dealloc {
    [_tableView release];
    
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setViewTitle:@"发现"];
    self.view.backgroundColor = [UIColor applicationLightYellowColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, kScreen_width, kScreen_height - 64 - 49) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.sectionFooterHeight = 14;
    _tableView.sectionHeaderHeight = 0;
    _tableView.backgroundColor = [UIColor applicationLightYellowColor];
    [self.view addSubview:_tableView];
    
    UIView *tableViewHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_width, 14)];
    _tableView.tableHeaderView = tableViewHeaderView;
    [tableViewHeaderView release];
    
    bbTopbar.backgroundColor = [UIColor colorWithRed:234/255.0 green:166/255.0 blue:31/255.0 alpha:1];
    UIButton *shoppingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    shoppingBtn.frame = CGRectMake(kScreen_width - 40, 7, 30, 30);
    [shoppingBtn setImage:[UIImage imageNamed:@"shopping.png"] forState:UIControlStateNormal];
    [shoppingBtn addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
    //    [bbTopbar addSubview:shoppingBtn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)reloadData {
    [_tableView reloadData];
}

- (void)btnAction {
    //    CartViewController
    
    CartViewController *dCtr = [[CartViewController alloc] init];
    [ctr pushViewController:dCtr animation:ViewSwitchAnimationSwipeR2L];
    [dCtr release];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellId = @"UITableView";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId] autorelease];
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 7, 30, 30)];
        imgView.tag = 1000;
        imgView.userInteractionEnabled = NO;
        [cell.contentView addSubview:imgView];
        [imgView release];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(44, 13, 280, 18)];
        titleLabel.tag = 1001;
        titleLabel.font = [UIFont systemFontOfSize:16];
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:titleLabel];
        [titleLabel release];
        
    }
    
    UIImageView *imgView = (UIImageView *)[cell.contentView viewWithTag:1000];
    UILabel *titleLabel = (UILabel *)[cell.contentView viewWithTag:1001];
    
    if (indexPath.section == 0) {
        
        imgView.image = [UIImage imageNamed:@"zp.png"];
        titleLabel.text = @"作品";
        
    } else if (indexPath.section == 1) {
        imgView.image = [UIImage imageNamed:@"hot11.png"];
        titleLabel.text = @"变变变";
        
        if ([DataCenter shareDataCenter].activityMessage != 0) {
            NSString *msg = [NSString stringWithFormat:@"%ld", [DataCenter shareDataCenter].activityMessage];
            
            UITextField *badgeField = [[UITextField alloc] init];
            
            badgeField.backgroundColor = [UIColor redColor];
            badgeField.textColor = [UIColor whiteColor];
            badgeField.layer.cornerRadius = 8;
            badgeField.layer.masksToBounds = YES;
            badgeField.textAlignment = NSTextAlignmentCenter;
            badgeField.userInteractionEnabled = NO;
            badgeField.font = [UIFont systemFontOfSize:12];
            CGSize textSize = [msg sizeWithFont:[UIFont systemFontOfSize:12]];
            if (textSize.width < 10) {
                textSize.width = 10;
            }
            badgeField.frame = CGRectMake(70,
                                          5,
                                          textSize.width + 6,
                                          16);
            badgeField.text = msg;
            [cell.contentView addSubview:badgeField];
            [badgeField release];
        }
        
    }
    return cell;
}
#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        TopicViewController *tVC = [[TopicViewController alloc] init];
        [ctr pushViewController:tVC animation:ViewSwitchAnimationSwipeR2L];
        [tVC release];
    } else if (indexPath.section == 1) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/us/app/bian-bian-bian/id1022761408?l=zh&ls=1&mt=8"]];
    } else if (indexPath.section == 2) {
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://m.bbjhart.com/index.jsp"]];
        
    } else if (indexPath.section == 3) {
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://m.wsq.qq.com/251961196"]];
        
    } else if (indexPath.section == 4) {
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://m.bbjhart.com/col.jsp?id=119"]];
        
    }
    
}

@end
