//
//  MoreViewController.m
//  baby
//
//  Created by zhang da on 14-4-1.
//  Copyright (c) 2014年 zhang da. All rights reserved.
//

#import "AboutViewController.h"
#import "UIButtonExtra.h"
#import "ConfigManager.h"
#import "WelcomeViewController.h"

#import "SchoolViewController.h"
#import "DiscoveryViewController.h"
#import "TopicViewController.h"
#import "BookingViewController.h"
#import "ScanQRViewController.h"

#import "IntroViewController.h"
#import "CoreLessonViewController.h"
#import "ChangeViewController.h"
#import "PaintingBookViewController.h"
#import "IceViewController.h"


#define TITLE_TAG 77777
#define ROW_HEIGHT 44


@interface AboutViewController ()

@end

@implementation AboutViewController


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
                                                                  ROW_HEIGHT*5)
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
    [self setViewTitle:@"关于"];
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
    return 5;
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
        case 0: title.text = @"简介"; break;
        case 1: title.text = @"核心课程"; break;
        case 2: title.text = @"冰山理论"; break;
        case 3: title.text = @"变变变"; break;
        case 4: title.text = @"绘本"; break;
        default: break;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ROW_HEIGHT;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0: {
            IntroViewController *iCtr = [[IntroViewController alloc] init];
            [ctr pushViewController:iCtr animation:ViewSwitchAnimationSwipeR2L];
            [iCtr release];
            break;
        };
        case 1: {
            CoreLessonViewController *cCtr = [[CoreLessonViewController alloc] init];
            [ctr pushViewController:cCtr animation:ViewSwitchAnimationSwipeR2L];
            [cCtr release];
            break;
        }
        case 2: {
            IceViewController *iCtr = [[IceViewController alloc] init];
            [ctr pushViewController:iCtr animation:ViewSwitchAnimationSwipeR2L];
            [iCtr release];
            break;
        };
        case 3: {
            ChangeViewController *cCtr = [[ChangeViewController alloc] init];
            [ctr pushViewController:cCtr animation:ViewSwitchAnimationSwipeR2L];
            [cCtr release];
            break;
        }
        case 4: {
            PaintingBookViewController *pCtr = [[PaintingBookViewController alloc] init];
            [ctr pushViewController:pCtr animation:ViewSwitchAnimationSwipeR2L];
            [pCtr release];
            break;
        }
        default:
            break;
    }
}

@end
