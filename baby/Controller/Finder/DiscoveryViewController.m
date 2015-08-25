//
//  AccountViewController.m
//  baby
//
//  Created by zhang da on 14-3-3.
//  Copyright (c) 2014年 zhang da. All rights reserved.
//

#import "DiscoveryViewController.h"
#import "GridGalleryCell.h"
#import "GalleryViewController.h"
#import "SelfView.h"
#import "GalleryTask.h"
#import "ActivityTask.h"
#import "TaskQueue.h"
#import "ConfigManager.h"
#import "Session.h"
#import "Activity.h"
#import "Gallery.h"
#import "GalleryPictureLK.h"
#import "AudioPlayer.h"
#import "Picture.h"
#import "ActivityViewController.h"
#import "UIButtonExtra.h"

#import "DataCenter.h"
#import "UserTask.h"

#define PAGESIZE 6
#define COL_CNT 2

@interface DiscoveryViewController ()

@property (nonatomic, assign) int pictureIndex;

@end


@implementation DiscoveryViewController

- (void)dealloc {
    [galleries release];
    [activities release];
    [cityView release];

    [super dealloc];
}

- (id)init {
    self = [super init];
    if (self) {
        galleryTable = [[PullTableView alloc] initWithFrame:CGRectMake(0, 44, 320, screentContentHeight - 44)
                                                      style:UITableViewStylePlain];
        galleryTable.pullDelegate = self;
        galleryTable.delegate = self;
        galleryTable.dataSource = self;
        [galleryTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [self.view addSubview:galleryTable];
        galleryTable.pullBackgroundColor = [Shared bbWhite];
        [galleryTable release];

        banner = [[ImagePlayerView alloc] initWithFrame:CGRectMake(0, 0, 320, 200)];
        banner.delegate = self;
        galleryTable.tableHeaderView = banner;
        [banner release];
        
        cityView = [[SimpleSegment alloc] initWithFrame:CGRectMake(5, 5, 310, 29)
                                                    titles:@[@"城市", @"北京", @"上海", @"广州"]];
        cityView.selectedTextColor = [UIColor whiteColor];
        cityView.selectedBackgoundColor = [UIColor colorWithRed:234/255.0 green:166/255.0 blue:31/255.0 alpha:1];
        cityView.normalTextColor = [UIColor colorWithRed:234/255.0 green:166/255.0 blue:31/255.0 alpha:1];
        cityView.normalBackgroundColor = [UIColor whiteColor];
        cityView.borderColor = [UIColor colorWithRed:234/255.0 green:166/255.0 blue:31/255.0 alpha:1];
        cityView.delegate = self;
        cityView.layer.cornerRadius = 2;
        [cityView updateLayout];
        
        UIButton *back = [UIButton buttonWithCustomStyle:CustomButtonStyleBack];
        [back addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        [bbTopbar addSubview:back];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // Custom initialization
    self.view.backgroundColor = [Shared bbWhite];
    
    galleries = [[NSMutableArray alloc] initWithCapacity:0];
    activities = [[NSMutableArray alloc] initWithCapacity:0];
    
    currentPage = 1;
    [self loadGallery];
    
    [self setViewTitle:@"发现"];
    bbTopbar.backgroundColor = [UIColor colorWithRed:234/255.0 green:166/255.0 blue:31/255.0 alpha:1];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [DataCenter shareDataCenter].activityMessage = 0;
    
    long userId = [ConfigManager me].userId;
    
    UserTask *task1 = [[UserTask alloc] initUserDetail:userId msg:@"activity_message"];
    task1.logicCallbackBlock = ^(bool succeeded, id userInfo) {
        
        
        
    };
    [TaskQueue addTaskToQueue:task1];
    [task1 release];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma ui event
- (void)back {
    [ctr popViewControllerAnimated:YES];
}

- (void)segmentSelected:(int)index {
    currentPage = 1;
    [self loadGallery];
}

- (void)loadGallery {
    int cityId = 0;
    if (cityView.selectedIndex == 1) {
        cityId = 1010;
    } else if (cityView.selectedIndex == 2) {
        cityId = 1011;
    } else if (cityView.selectedIndex == 3) {
        cityId = 1292;
    }
    
    GalleryTask *cityTask = [[GalleryTask alloc] initCityGalleryList:cityId page:currentPage count:PAGESIZE];
    cityTask.logicCallbackBlock = ^(bool succeeded, id userInfo) {
        if (currentPage == 1) {
            [galleries removeAllObjects];
        }
        
        if (succeeded) {
            [galleries addObjectsFromArray:(NSArray *)userInfo];
            if ([((NSArray *)userInfo) count] < PAGESIZE) {
                galleryTable.hasMore = NO;
            } else {
                galleryTable.hasMore = YES;
            }
        }
        
        [galleryTable reloadData];
        [galleryTable stopLoading];
    };
    [TaskQueue addTaskToQueue:cityTask];
    [cityTask release];
    
    ActivityTask *activityTask = [[ActivityTask alloc] initAvctivityList];
    activityTask.logicCallbackBlock = ^(bool succeeded, id userInfo) {
        if (succeeded) {
            [activities removeAllObjects];
            [activities addObjectsFromArray:userInfo];
            
            NSMutableArray *pictures = [[NSMutableArray alloc] init];
            for (Activity *a in activities) {
                if (a.icon != nil) {
                    [pictures addObject:a.icon];
                }
                
            }
            banner.banners = pictures;
            [banner updateLayout];
            [pictures release];
        }
    };
    [TaskQueue addTaskToQueue:activityTask];
    [activityTask release];
}


#pragma table view section
- (void)configCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    for (int i = 0; i < COL_CNT; i++) {
        GridGalleryCell *gCell = (GridGalleryCell *)cell;
        gCell.row = indexPath.row;
        if (indexPath.row*COL_CNT + i < galleries.count) {
            long gId = [[galleries objectAtIndex:indexPath.row*COL_CNT + i] longValue];
            Gallery *g = [Gallery getGalleryWithId:gId];
            [gCell setImagePath:g.cover atCol:i];
        } else {
            [gCell setImagePath:nil atCol:i];
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return galleries.count/COL_CNT + (galleries.count%COL_CNT>0? 1: 0);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //缩略
    static NSString *cellId = @"gridgallerycell";
    GridGalleryCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[[GridGalleryCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:cellId
                                                colCnt:COL_CNT] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
    }
    [self configCell:cell atIndexPath:indexPath];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 320.0f/COL_CNT;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *bg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 31)];
    bg.backgroundColor = [Shared bbWhite];
    [bg addSubview:cityView];
    return [bg autorelease];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 39;
}


#pragma mark pull table view delegate
- (void)pullTableViewDidTriggerRefresh:(PullTableView*)pullTableView {
    currentPage = 1;
    [self loadGallery];
}

- (void)pullTableViewDidTriggerLoadMore:(PullTableView*)pullTableView {
    currentPage ++;
    [self loadGallery];
}


#pragma mark grid gallery view cell
- (void)galleryTouchedAtRow:(int)row andCol:(int)col {
    if (galleries.count > row*COL_CNT + col) {
        NSNumber *g = [galleries objectAtIndex:row*COL_CNT + col];
        
        GalleryViewController *gVC = [[GalleryViewController alloc] initWithGallery:[g longValue]];
        [ctr pushViewController:gVC animation:ViewSwitchAnimationBounce];
        [gVC release];
    }
}


//#pragma mark accountview delegate
//- (void)editUserDetail:(SelfView *)caller {
//    EditViewController *eCtr = [[EditViewController alloc] init];
//    [ctr pushViewController:eCtr animation:ViewSwitchAnimationBounce];
//    [eCtr release];
//}


#pragma mark image player delegate
- (void)handleTouchAtIndex:(int)index {
    if (index < activities.count) {
        Activity *a = [activities objectAtIndex:index];
        
        ActivityViewController *aVC = [[ActivityViewController alloc] initWithActivity:a];
        [ctr pushViewController:aVC animation:ViewSwitchAnimationBounce];
        [aVC release];
    }
}

@end
