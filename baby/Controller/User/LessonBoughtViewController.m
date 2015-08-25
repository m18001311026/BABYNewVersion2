//
//  LessonBoughtViewController.m
//  baby
//
//  Created by zhang da on 14-3-3.
//  Copyright (c) 2014年 zhang da. All rights reserved.
//

#import "LessonBoughtViewController.h"
#import "BoughtLessonCell.h"

#import "LessonDetailViewController.h"
#import "OrderTask.h"
#import "TaskQueue.h"
#import "UIButtonExtra.h"
#import "ConfigManager.h"

#define LESSON_PAGE_SIZE 5

@interface LessonBoughtViewController ()

@property (nonatomic, assign) long playingLessonId;

@end



@implementation LessonBoughtViewController

- (void)dealloc {
    [lessons release];

    [super dealloc];
}

- (id)init {
    self = [super init];
    if (self) {
        self.view.backgroundColor = [UIColor whiteColor];
        
        lessonTable = [[PullTableView alloc] initWithFrame:CGRectMake(0, 44, 320, screentContentHeight - 44)
                                                      style:UITableViewStylePlain];
        lessonTable.pullDelegate = self;
        lessonTable.delegate = self;
        lessonTable.dataSource = self;
        lessonTable.pullBackgroundColor = [Shared bbWhite];
        lessonTable.backgroundColor = [Shared bbWhite];
        [lessonTable setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
        lessonTable.separatorColor = [UIColor whiteColor];
        [self.view addSubview:lessonTable];
        [lessonTable release];
        
        lessons = [[NSMutableArray alloc] initWithCapacity:0];
        
        currentPage = 1;
        [self loadLesson];

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setViewTitle:[ConfigManager me].runInReviewMode? @"历史记录": @"购买记录"];
    bbTopbar.backgroundColor = [UIColor colorWithRed:234/255.0 green:166/255.0 blue:31/255.0 alpha:1];
    
    UIButton *back = [UIButton buttonWithCustomStyle:CustomButtonStyleBack];
    [back addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [bbTopbar addSubview:back];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma ui event
- (void)back {
    [ctr popViewControllerAnimated:YES];
}

- (void)loadLesson {
    OrderTask *task = [[OrderTask alloc] initLessonBoughtListAtPage:currentPage
                                                              count:LESSON_PAGE_SIZE];
    task.logicCallbackBlock = ^(bool succeeded, id userInfo) {
        if (currentPage == 1) {
            [lessons removeAllObjects];
        }
        
        if (succeeded) {
            [lessons addObjectsFromArray:(NSArray *)userInfo];
            if ([((NSArray *)userInfo) count] < LESSON_PAGE_SIZE) {
                lessonTable.hasMore = NO;
            } else {
                lessonTable.hasMore = YES;
            }
        }
        
        [lessonTable reloadData];
        [lessonTable stopLoading];
    };
    [TaskQueue addTaskToQueue:task];
    [task release];
}


#pragma table view section
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return lessons.count;
}

- (void)configCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    BoughtLessonCell *lCell = (BoughtLessonCell *)cell;
    if (lessons.count > indexPath.row) {
        lCell.lessonId = [[lessons objectAtIndex:indexPath.row] longValue];
        [lCell updateLayout];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"lessoncell";
    BoughtLessonCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[[BoughtLessonCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
    }
    [self configCell:cell atIndexPath:indexPath];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 66;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    long lessonId = [[lessons objectAtIndex:indexPath.row] longValue];
    
    LessonDetailViewController *lCtr = [[LessonDetailViewController alloc] initWithLesson:lessonId];
    [ctr pushViewController:lCtr animation:ViewSwitchAnimationBounce];
    [lCtr release];
}


#pragma mark pull table view delegate
- (void)pullTableViewDidTriggerRefresh:(PullTableView*)pullTableView {
    currentPage = 1;
    [self loadLesson];
}

- (void)pullTableViewDidTriggerLoadMore:(PullTableView*)pullTableView {
    currentPage ++;
    [self loadLesson];
}


@end
