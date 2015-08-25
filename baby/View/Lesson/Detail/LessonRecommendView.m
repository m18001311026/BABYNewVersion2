//
//  LessonRecommendView.m
//  baby
//
//  Created by zhang da on 14-3-25.
//  Copyright (c) 2014年 zhang da. All rights reserved.
//

#import "LessonRecommendView.h"
#import "LessonCell.h"
#import "LessonDetailViewController.h"

#import "LessonTask.h"
#import "TaskQueue.h"

#define PAGESIZE 5

@implementation LessonRecommendView

- (void)dealloc {
    [lessons release];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame lesson:(long)lessonId {
    self = [super initWithFrame:frame];
    if (self) {
        self.lessonId = lessonId;
        
        lessonTable = [[PullTableView alloc] initWithFrame:CGRectMake(0, 0, 320, frame.size.height)
                                                     style:UITableViewStylePlain];
        lessonTable.pullDelegate = self;
        lessonTable.delegate = self;
        lessonTable.dataSource = self;
        lessonTable.pullBackgroundColor = [Shared bbWhite];
        lessonTable.backgroundColor = [Shared bbWhite];
        [lessonTable setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
        lessonTable.separatorColor = [UIColor whiteColor];
        [self addSubview:lessonTable];
        [lessonTable release];
        
        lessons = [[NSMutableArray alloc] initWithCapacity:0];
        
        currentPage = 1;
        [self loadLesson];
    }
    return self;
}

- (void)loadLesson {
    LessonTask *task = [[LessonTask alloc] initSimilarLesson:self.lessonId
                                                        page:currentPage
                                                       count:PAGESIZE];
    task.logicCallbackBlock = ^(bool succeeded, id userInfo) {
        if (currentPage == 1) {
            [lessons removeAllObjects];
        }
        
        if (succeeded) {
            [lessons addObjectsFromArray:(NSArray *)userInfo];
            if ([((NSArray *)userInfo) count] < PAGESIZE) {
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
    LessonCell *lCell = (LessonCell *)cell;
    if (lessons.count > indexPath.row) {
        lCell.lessonId = [[lessons objectAtIndex:indexPath.row] longValue];
        [lCell updateLayout];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"lessoncell";
    LessonCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[[LessonCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId] autorelease];
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
    [ctr pushViewController:lCtr animation:ViewSwitchAnimationSwipeR2L];
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
