//
//  SchoolDetailViewController.m
//  baby
//
//  Created by zhang da on 14-4-15.
//  Copyright (c) 2014年 zhang da. All rights reserved.
//

#import "SchoolDetailViewController.h"
#import "UIButtonExtra.h"
#import "MapViewController.h"

#import "School.h"
#import "SchoolPicture.h"
#import "MemContainer.h"

#import "SchoolTask.h"
#import "TaskQueue.h"


@interface SchoolDetailViewController ()

@end

@implementation SchoolDetailViewController

- (void)dealloc {
    
    [super dealloc];
}

- (id)initWithSchool:(long)schoolId {
    self = [super init];
    if (self) {
        self.schoolId = schoolId;
        
        self.view.backgroundColor = [UIColor whiteColor];
        
        schoolTable = [[PullTableView alloc] initWithFrame:CGRectMake(0, 44, 320, screentContentHeight - 44)
                                                     style:UITableViewStylePlain];
        schoolTable.pullDelegate = self;
        schoolTable.delegate = self;
        schoolTable.dataSource = self;
        schoolTable.hasMore = NO;
        schoolTable.pullBackgroundColor = [Shared bbWhite];
        schoolTable.backgroundColor = [Shared bbWhite];
        [schoolTable setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
        if ([schoolTable respondsToSelector:@selector(setSeparatorInset:)]) {
            [schoolTable setSeparatorInset:UIEdgeInsetsZero];
        }
        schoolTable.separatorColor = [Shared bbLightGray];
        [self.view addSubview:schoolTable];
        [schoolTable release];
        
        banner = [[ImagePlayerView alloc] initWithFrame:CGRectMake(0, 0, 320, 200)];
        schoolTable.tableHeaderView = banner;
        [banner release];
        
        UIButton *back = [UIButton buttonWithCustomStyle:CustomButtonStyleBack];
        [back addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        [bbTopbar addSubview:back];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setViewTitle:@"分校信息"];
    bbTopbar.backgroundColor = [UIColor colorWithRed:234/255.0 green:166/255.0 blue:31/255.0 alpha:1];
    
    [self loadSchool];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma ui event
- (void)back {
    [ctr popViewControllerAnimated:YES];
}

- (void)loadSchool {
    SchoolTask *task = [[SchoolTask alloc] initSchoolDetail:self.schoolId];
    task.logicCallbackBlock = ^(bool succeeded, id userInfo) {        
        if (succeeded) {
            NSArray *schoolPictures = [SchoolPicture getPicturesForSchool:self.schoolId];
            NSMutableArray *pictures = [[NSMutableArray alloc] init];
            for (SchoolPicture *picture in schoolPictures) {
                [pictures addObject:picture.cover];
            }
            banner.banners = pictures;
            [banner updateLayout];
            [pictures release];
        }
        [schoolTable reloadData];
        [schoolTable stopLoading];
    };
    [TaskQueue addTaskToQueue:task];
    [task release];
}


#pragma table view section
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    School *school = [School getSchoolWithId:self.schoolId];
    return 2 + (school.hotline? 1:0);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [Shared bbRealWhite];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(5, 11, 50, 20)];
    title.font = [UIFont systemFontOfSize:16];
    title.textAlignment = NSTextAlignmentCenter;
    title.backgroundColor = [UIColor clearColor];
    title.textColor = [UIColor lightGrayColor];
    [cell addSubview:title];
    [title release];

    UILabel *detail = [[UILabel alloc] initWithFrame:CGRectMake(58, 5, 240, 34)];
    detail.font = [UIFont systemFontOfSize:16];
    detail.backgroundColor = [UIColor clearColor];
    detail.numberOfLines = 0;
    [cell addSubview:detail];
    [detail release];

    School *school = [School getSchoolWithId:self.schoolId];

    if (indexPath.row == 0) {
        //name
        title.text = @"名称";

        detail.text = school.title;
        detail.textColor = [UIColor blackColor];
    } else if (indexPath.row == 1) {
        //address
        title.text = @"地址";

        CGSize size = [school.address sizeWithFont:[UIFont systemFontOfSize:16]
                                 constrainedToSize:CGSizeMake(230, 1000)];
        if (size.height > 34) {
            detail.frame = CGRectMake(58, 5, 230, size.height);
        }
        detail.text = school.address;
        detail.textColor = [UIColor blackColor];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else if (indexPath.row == 2) {
        //phone
        title.text = @"热线";
        
        detail.text = school.hotline;
        detail.textColor = [UIColor blackColor];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else if (indexPath.row == 3) {
        //travel route
        title.font = [UIFont systemFontOfSize:15];
        title.text = @"乘车路线";
        title.textColor = [UIColor lightGrayColor];
        
        CGSize size = [school.travelRoute sizeWithFont:[UIFont systemFontOfSize:16]
                                     constrainedToSize:CGSizeMake(240, 1000)];
        if (size.height > 34) {
            detail.frame = CGRectMake(58, 5, 240, size.height);
        }
        detail.text = school.travelRoute? school.travelRoute: @"待完善";
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        //name
        return 44;
    } else if (indexPath.row == 1) {
        School *school = [School getSchoolWithId:self.schoolId];
        CGSize size = [school.address sizeWithFont:[UIFont systemFontOfSize:16]
                                 constrainedToSize:CGSizeMake(230, 1000)];
        //address
        return MAX(size.height + 10, 44);
    } else if (indexPath.row == 2) {
        //phone
        return 44;
    } else if (indexPath.row == 3) {
        //travel route
        School *school = [School getSchoolWithId:self.schoolId];
        CGSize size = [school.travelRoute sizeWithFont:[UIFont systemFontOfSize:16]
                                     constrainedToSize:CGSizeMake(240, 1000)];
        //address
        return MAX(size.height + 10, 44);
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 1) {
        //address show map
        School *school = [School getSchoolWithId:self.schoolId];
        
        MapViewController *mCtr = [[MapViewController alloc] initWithSchool:school];
        [ctr pushViewController:mCtr animation:ViewSwitchAnimationSwipeR2L];
        [mCtr release];
    } else if (indexPath.row == 2) {
        //phone make phone call
        School *school = [School getSchoolWithId:self.schoolId];

        if (school.hotline) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                            message:[NSString stringWithFormat:@"拨打 %@ ?", school.hotline]
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:@"拨打", nil];
            [alert show];
            [alert release];            
        }
    }

}


#pragma mark pull table view delegate
- (void)pullTableViewDidTriggerRefresh:(PullTableView*)pullTableView {
    [self loadSchool];
}

- (void)pullTableViewDidTriggerLoadMore:(PullTableView*)pullTableView {
    [self loadSchool];
}

#pragma mark uialertview delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        School *school = [School getSchoolWithId:self.schoolId];

        [[UIApplication sharedApplication] openURL:
         [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", school.hotline]]];
    }
}

@end
