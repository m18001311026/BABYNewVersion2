//
//  MoreViewController.m
//  baby
//
//  Created by zhang da on 14-4-1.
//  Copyright (c) 2014年 zhang da. All rights reserved.
//

#import "SettingViewController.h"
#import "UIButtonExtra.h"
#import "ConfigManager.h"
#import "WelcomeViewController.h"

#import "SchoolViewController.h"
#import "DiscoveryViewController.h"
#import "TopicViewController.h"
#import "BookingViewController.h"
#import "ScanQRViewController.h"

#define TITLE_TAG 77777
#define ROW_HEIGHT 44


@interface SettingViewController ()

@end

@implementation SettingViewController


- (void)dealloc {
    [super dealloc];
}

- (id)init {
    self = [super init];
    if (self) {
        self.view.backgroundColor = [Shared bbRealWhite];
        
        moreTable = [[UITableView alloc] initWithFrame:CGRectMake(0,
                                                                  44,
                                                                  320,
                                                                  ROW_HEIGHT)
                                                 style:UITableViewStylePlain];
        moreTable.delegate = self;
        moreTable.dataSource = self;
        moreTable.backgroundColor = [Shared bbRealWhite];
        moreTable.scrollEnabled = NO;
        if ([moreTable respondsToSelector:@selector(setSeparatorInset:)]) {
            [moreTable setSeparatorInset:UIEdgeInsetsZero];
        }
        [moreTable setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
        moreTable.separatorColor = [Shared bbLightGray];
        //[moreTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [self.view addSubview:moreTable];
        [moreTable release];
        
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
    
    [self setViewTitle:@"设置"];
    bbTopbar.backgroundColor = [UIColor colorWithRed:234/255.0 green:166/255.0 blue:31/255.0 alpha:1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

- (void)back {
    [ctr popViewControllerAnimated:YES];
}


#pragma table view section
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"morecell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(10, 13, 280, 18)];
        title.tag = TITLE_TAG;
        title.font = [UIFont systemFontOfSize:16];
        title.textColor = [UIColor grayColor];
        title.backgroundColor = [UIColor clearColor];
        [cell addSubview:title];
        [title release];
    }
    
    UILabel *title = (UILabel *)[cell viewWithTag:TITLE_TAG];
    
    switch (indexPath.row) {
        case 0:
            title.text = @"重置缓存";
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
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"重置缓存"
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                         destructiveButtonTitle:nil
                                              otherButtonTitles:@"重置", nil];
    [sheet showInView:self.view];
    [sheet release];
}


#pragma mark uiactionsheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [IMG resetCache];
        [UI showAlert:@"重置成功"];
    }
}


@end
