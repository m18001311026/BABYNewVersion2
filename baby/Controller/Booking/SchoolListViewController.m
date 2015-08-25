//
//  LessonViewController.m
//  baby
//
//  Created by zhang da on 14-3-3.
//  Copyright (c) 2014年 zhang da. All rights reserved.
//

#import "SchoolListViewController.h"
#import "UIButtonExtra.h"

#import "SchoolTask.h"
#import "TaskQueue.h"


@interface SchoolListViewController ()

@property (nonatomic, copy) SchoolChoose callback;

@end



@implementation SchoolListViewController

- (void)dealloc {
    [schools release];
    self.callback = nil;

    [super dealloc];
}

- (id)initWithCallback:(SchoolChoose)callback {
    self = [super init];
    if (self) {
        self.view.backgroundColor = [UIColor whiteColor];
        self.callback = callback;
        
        schoolTable = [[PullTableView alloc] initWithFrame:CGRectMake(0, 44, 320, screentContentHeight - 44)
                                                      style:UITableViewStylePlain];
        schoolTable.pullDelegate = self;
        schoolTable.delegate = self;
        schoolTable.dataSource = self;
        schoolTable.pullBackgroundColor = [Shared bbWhite];
        schoolTable.backgroundColor = [Shared bbWhite];
        [schoolTable setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
        if ([schoolTable respondsToSelector:@selector(setSeparatorInset:)]) {
            [schoolTable setSeparatorInset:UIEdgeInsetsZero];
        }
        schoolTable.separatorColor = [UIColor lightGrayColor];
        [self.view addSubview:schoolTable];
        [schoolTable release];
        
        schools = [[NSMutableArray alloc] initWithCapacity:0];
        [self loadSchool];
        
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
    
    [self setViewTitle:@"预约分校"];
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

- (void)loadSchool {
    SchoolTask *task = [[SchoolTask alloc] initSchoolList];
    task.logicCallbackBlock = ^(bool succeeded, id userInfo) {
        [schools removeAllObjects];
        
        if (succeeded) {
            [schools addObjectsFromArray:(NSArray *)userInfo];
            schoolTable.hasMore = NO;
        }
        
        [schoolTable reloadData];
        [schoolTable stopLoading];
    };
    [TaskQueue addTaskToQueue:task];
    [task release];
}


#pragma table view section
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return schools.count;
}

- (void)configCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    SchoolCell *sCell = (SchoolCell *)cell;
    if (schools.count > indexPath.row) {
        sCell.schoolId = [[schools objectAtIndex:indexPath.row] longValue];
        [sCell updateLayout];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"schoolcell";
    SchoolCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[[SchoolCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [Shared bbRealWhite];
        cell.delegate = self;
    }
    [self configCell:cell atIndexPath:indexPath];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 76;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    long schoolId = [[schools objectAtIndex:indexPath.row] longValue];
    
    if (self.callback) {
        self.callback(schoolId);
        self.callback = nil;
        [self back];
    }
}


#pragma mark pull table view delegate
- (void)pullTableViewDidTriggerRefresh:(PullTableView*)pullTableView {
    [self loadSchool];
}

- (void)pullTableViewDidTriggerLoadMore:(PullTableView*)pullTableView {
    [self loadSchool];
}


@end
