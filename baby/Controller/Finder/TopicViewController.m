//
//  TopicViewController.m
//  baby
//
//  Created by zhang da on 14-3-3.
//  Copyright (c) 2014年 zhang da. All rights reserved.
//

#import "TopicViewController.h"
#import "GalleryViewController.h"

#import "TopicTask.h"
#import "TaskQueue.h"
#import "ConfigManager.h"
#import "Topic.h"

#import "TopicGalleryViewController.h"
#import "UIButtonExtra.h"
#import "UIColorExtra.h"

#define COL_CNT 2
#define SIMPLE_COL_CNT 3
#define TOPIC_PAGE_SIZE 20

@interface TopicViewController ()

@property (nonatomic, assign) int pictureIndex;

@end


@implementation TopicViewController

- (void)dealloc {
    [topics release];
    [simpleTopics release];
    [header release];

    [super dealloc];
}

- (id)init {
    self = [super init];
    if (self) {
      /*  UIButton *back = [UIButton buttonWithCustomStyle:CustomButtonStyleBack];
        [back addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        [bbTopbar addSubview:back];*/
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // Custom initialization
    self.view.backgroundColor = [Shared bbWhite];
    
    topicTable = [[PullTableView alloc] initWithFrame:CGRectMake(0, 44, 320, screentContentHeight - 44)
                                                style:UITableViewStylePlain];
    topicTable.pullDelegate = self;
    topicTable.delegate = self;
    topicTable.dataSource = self;
//    topicTable.backgroundColor = [Shared bbWhite];
    topicTable.backgroundColor = [UIColor r:250 g:242 b:232 alpha:1];
    [topicTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:topicTable];
    topicTable.pullBackgroundColor = [Shared bbRealWhite];
    [topicTable release];
    
    topics = [[NSMutableArray alloc] initWithCapacity:0];
    simpleTopics = [[NSMutableArray alloc] initWithCapacity:0];
    [self loadTopic];
    
    [self setViewTitle:@"作品"];
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

- (void)loadTopic {
    TopicTask *task = [[TopicTask alloc] initTopicListAtPage:currentPage count:TOPIC_PAGE_SIZE];
    task.logicCallbackBlock = ^(bool succeeded, id userInfo) {
        if (currentPage == 1) {
            [topics removeAllObjects];
            [simpleTopics removeAllObjects];
        }
        
        if (succeeded) {
            NSDictionary *dict = (NSDictionary *)userInfo;
            
            int count = 0;

            for (Topic *topic in dict[@"normal"]) {
                

                if (topic.icon != nil) {
                    [topics addObject:topic];
                } else {
                    [simpleTopics addObject:topic];
                }
            }

            
            topicTable.hasMore = count >= TOPIC_PAGE_SIZE;
        }
        
        [topicTable reloadData];
        [topicTable stopLoading];
    };
    [TaskQueue addTaskToQueue:task];
    [task release];
}


#pragma table view section
- (void)configNormalCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    for (int i = 0; i < COL_CNT; i++) {
        TopicCell *gCell = (TopicCell *)cell;
        gCell.row = indexPath.row;
        if (indexPath.row*COL_CNT + i < topics.count) {
            Topic *t = [topics objectAtIndex:indexPath.row*COL_CNT + i];
            [gCell setImagePath:t.icon atCol:i];
            [gCell setTitle:t.content atCol:i];
        } else {
            [gCell setImagePath:nil atCol:i];
            [gCell setTitle:nil atCol:i];
        }
    }
}

- (void)configSimpleCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    for (int i = 0; i < SIMPLE_COL_CNT; i++) {
        TopicSimpleCell *gCell = (TopicSimpleCell *)cell;
        gCell.row = indexPath.row;
        if (indexPath.row*SIMPLE_COL_CNT + i < simpleTopics.count) {
            Topic *t = [simpleTopics objectAtIndex:indexPath.row*SIMPLE_COL_CNT + i];
            [gCell setTitle:t.content atCol:i];
        } else {
            [gCell setTitle:nil atCol:i];
        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return topics.count/COL_CNT + (topics.count%COL_CNT>0? 1: 0);
    } else {
        return simpleTopics.count/SIMPLE_COL_CNT + (simpleTopics.count%SIMPLE_COL_CNT>0? 1: 0);
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 缩略
    if (indexPath.section == 0) {
        static NSString *cellId = @"TopicCell";
        TopicCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[[TopicCell alloc] initWithStyle:UITableViewCellStyleDefault
                                     reuseIdentifier:cellId
                                              colCnt:COL_CNT
                                              height:50] autorelease];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;
        }
        [self configNormalCell:cell atIndexPath:indexPath];
        return cell;
    } else {
        static NSString *cellId = @"STopicCell";
        TopicSimpleCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[[TopicSimpleCell alloc] initWithStyle:UITableViewCellStyleDefault
                                     reuseIdentifier:cellId
                                              colCnt:SIMPLE_COL_CNT
                                              height:44] autorelease];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;
        }
        [self configSimpleCell:cell atIndexPath:indexPath];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 60;
    }
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return nil;
    }
    
    if (!header) {
        header = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
        header.text = @"   热门标签";
        header.font = [UIFont systemFontOfSize:12];
        header.backgroundColor = [Shared bbRealWhite];
        header.textColor = [UIColor lightGrayColor];
    }
    return header;
}

//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
//
//    return footerView;
//}



- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    }
    return 30;
}


#pragma mark pull table view delegate
- (void)pullTableViewDidTriggerRefresh:(PullTableView*)pullTableView {
    currentPage = 1;
    [self loadTopic];
}

- (void)pullTableViewDidTriggerLoadMore:(PullTableView*)pullTableView {
    currentPage ++;
    [self loadTopic];
}


#pragma mark grid gallery view cell
- (void)topicTouchedAtRow:(int)row andCol:(int)col {
    if (topics.count > row*COL_CNT + col) {
        Topic *t = [topics objectAtIndex:row*COL_CNT + col];
        
        TopicGalleryViewController *tVC = [[TopicGalleryViewController alloc] initWithTopic:t._id];
        [ctr pushViewController:tVC animation:ViewSwitchAnimationSwipeR2L];
        [tVC release];
    }
}

- (void)simpleTopicTouchedAtRow:(int)row andCol:(int)col {
    if (simpleTopics.count > row*SIMPLE_COL_CNT + col) {
        Topic *t = [simpleTopics objectAtIndex:row*SIMPLE_COL_CNT + col];
        
        TopicGalleryViewController *tVC = [[TopicGalleryViewController alloc] initWithTopic:t._id];
        [ctr pushViewController:tVC animation:ViewSwitchAnimationSwipeR2L];
        [tVC release];
    }
}


@end
