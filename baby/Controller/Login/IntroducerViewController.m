//
//  IntroducerViewController.m
//  baby
//
//  Created by zhang da on 14-6-14.
//  Copyright (c) 2014年 zhang da. All rights reserved.
//

#import "IntroducerViewController.h"
#import "UIButtonExtra.h"

#import "IntroducerTask.h"
#import "TaskQueue.h"

@interface IntroducerViewController ()

@end

@implementation IntroducerViewController

- (void)dealloc {
    self.callback = nil;
    [introducers release];
    
    [super dealloc];
}

- (id)initWIthCallback:(FinishPickIntroducer)callback {
    self = [super init];
    if (self) {
        self.callback = callback;
        
        introTable = [[PullTableView alloc] initWithFrame:CGRectMake(0, 44, 320, screentContentHeight - 44)
                                                    style:UITableViewStylePlain];
        introTable.pullDelegate = self;
        introTable.delegate = self;
        introTable.dataSource = self;
        introTable.backgroundColor = [Shared bbRealWhite];
        if ([introTable respondsToSelector:@selector(setSeparatorInset:)]) {
            [introTable setSeparatorInset:UIEdgeInsetsZero];
        }
        [introTable setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
        introTable.separatorColor = [Shared bbLightGray];
        [self.view addSubview:introTable];
        introTable.pullBackgroundColor = [Shared bbRealWhite];
        [introTable release];
        
        UIButton *back = [UIButton buttonWithCustomStyle:CustomButtonStyleBack];
        [back addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        [bbTopbar addSubview:back];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [Shared bbWhite];
    
    introducers = [[NSMutableArray alloc] initWithCapacity:0];
    [self loadIntroducer];
    
    [self setViewTitle:@"选择渠道"];
    bbTopbar.backgroundColor = [UIColor colorWithRed:234/255.0 green:166/255.0 blue:31/255.0 alpha:1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma ui event
- (void)back {
    [ctr popViewControllerAnimated:YES];
}

- (void)loadIntroducer {
    IntroducerTask *task = [[IntroducerTask alloc] initIntroducerList];
    task.logicCallbackBlock = ^(bool succeeded, id userInfo) {
        [introducers removeAllObjects];
        
        if (succeeded) {
            [introducers addObjectsFromArray:(NSArray *)userInfo];
            introTable.hasMore = NO;
        }
        
        [introTable reloadData];
        [introTable stopLoading];
    };
    [TaskQueue addTaskToQueue:task];
    [task release];
}


#pragma table view section
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return introducers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"TopicCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        cell.textLabel.textColor = [UIColor grayColor];
    }
    cell.textLabel.text = [introducers objectAtIndex:indexPath.row];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.callback) {
        self.callback([introducers objectAtIndex:indexPath.row]);
        self.callback = nil;
    }
    [ctr popViewControllerAnimated:YES];
}


#pragma mark pull table view delegate
- (void)pullTableViewDidTriggerRefresh:(PullTableView*)pullTableView {
    [self loadIntroducer];
}

- (void)pullTableViewDidTriggerLoadMore:(PullTableView*)pullTableView {
}


@end
