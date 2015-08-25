//
//  LessonViewController.m
//  baby
//
//  Created by zhang da on 14-3-3.
//  Copyright (c) 2014年 zhang da. All rights reserved.
//

#import "LessonViewController.h"
#import "LessonCell.h"
#import "LessonHeader.h"
#import "Lesson.h"

#import "LessonDetailViewController.h"
#import "LessonTask.h"
#import "TaskQueue.h"

#import "CartViewController.h"

#define LESSON_PAGE_SIZE 7

@interface LessonViewController ()

@property (nonatomic, assign) long playingLessonId;


@end



@implementation LessonViewController
{
    LessonTask * _task;

}

- (void)dealloc {
    [lessons release];
    [recLessons release];
    [lessonType release];

    [super dealloc];
}

- (id)init {
    self = [super init];
    if (self) {
        
        
        
        self.view.backgroundColor = [UIColor whiteColor];
        
        lessonType = [[SimpleSegment alloc] initWithFrame:CGRectMake(5, 5, 310, 0)
                                                    titles:@[@"绘本", @"变变变", @"儿童评书"]];
        lessonType.selectedTextColor = [UIColor whiteColor];
        lessonType.selectedBackgoundColor = [UIColor colorWithRed:234/255.0 green:166/255.0 blue:31/255.0 alpha:1];
        lessonType.normalTextColor = [UIColor colorWithRed:234/255.0 green:166/255.0 blue:31/255.0 alpha:1];
        lessonType.normalBackgroundColor = [UIColor whiteColor];
        lessonType.borderColor = [UIColor colorWithRed:234/255.0 green:166/255.0 blue:31/255.0 alpha:1];
        lessonType.delegate = self;
        lessonType.layer.cornerRadius = 2;
        [lessonType updateLayout];
        
        lessonTable = [[PullTableView alloc] initWithFrame:CGRectMake(0, 44, 320, screentContentHeight - 44 - 52)
                                                      style:UITableViewStylePlain];
        lessonTable.pullDelegate = self;
        lessonTable.delegate = self;
        lessonTable.dataSource = self;
        lessonTable.pullBackgroundColor = [Shared bbWhite];
        lessonTable.backgroundColor = [Shared bbWhite];
        [lessonTable setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
        lessonTable.separatorColor = [UIColor whiteColor];
        [self.view addSubview:lessonTable];
        lessonTable.hidden=YES;
    //    [lessonTable release];
    //    chulijian2015-03-18 11:01:19
    //    [lessonTable removeFromSuperview];
        
        //chulijian周二晚上
        banner = [[ImagePlayerView alloc] initWithFrame:CGRectMake(0, 0, 320, 0)];
        //banner = [[ImagePlayerView alloc] initWithFrame:CGRectMake(0, 0, 320, 180)];
        
        banner.delegate = self;
        lessonTable.tableHeaderView = banner;
        [banner release];
        
        lessons = [[NSMutableArray alloc] initWithCapacity:0];
        recLessons = [[NSMutableArray alloc] initWithCapacity:0];
        
        currentPage = 1;
        [self loadLesson];
        backgroundView=[[UIView alloc]initWithFrame:CGRectMake(0, 43, kScreen_width, kScreen_height)];
     //   NSLog(@"screen %f   %f",kScreen_width,kScreen_height);
        backgroundView.backgroundColor=[UIColor cyanColor];
        backgroundView.userInteractionEnabled=YES;
        //  [self.view addSubview:backgroundView];
        
        
        //
        UIButton * backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        //  backBtn.frame=CGRectMake(260, 100, 50, 50);
      //  backBtn.backgroundColor=[UIColor blackColor];
        [backBtn addTarget:self action:@selector(backToHome:) forControlEvents:UIControlEventTouchUpInside];
        backBtn.frame = CGRectMake(8, 7, 30, 30);
        [backBtn setImage:[UIImage imageNamed:@"back_btn.png"] forState:UIControlStateNormal];
        backToHomeBtn=backBtn;
        [bbTopbar addSubview:backToHomeBtn];
        backToHomeBtn.hidden=YES;
        
     }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setViewTitle:@"课堂"];
    bbTopbar.backgroundColor = [UIColor colorWithRed:234/255.0 green:166/255.0 blue:31/255.0 alpha:1];
    
    UIButton *shoppingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    shoppingBtn.frame = CGRectMake(kScreen_width - 40, 7, 30, 30);
    [shoppingBtn setImage:[UIImage imageNamed:@"shopping.png"] forState:UIControlStateNormal];
    [shoppingBtn addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
    [bbTopbar addSubview:shoppingBtn];
    shoppingBtn.hidden=YES;
    bbTopbar.hidden=YES;
    
    //chulijian
    
    _img=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreen_width, kScreen_height)];
    NSArray * picArray=[NSArray arrayWithObjects:@"bbjhchengshi.jpg",@"bbjhshuimo.jpg",@"bbjhtiankong.jpg",@"bbjhxuancai.jpg", @"bbjhhuangse.jpg",nil];
     _img.image=[UIImage imageNamed:[picArray objectAtIndex:arc4random()%5]];

    [self.view addSubview:_img];
    
    
    UIButton * changechangechangeBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    changechangechangeBtn.frame=CGRectMake(50, kScreen_height/5, 100, 100);
     NSLog(@"kscreen %f,%f",kScreen_width,kScreen_height);
    if(kScreen_height==480)
    {
        NSLog(@"320*480");
    
    }
   // changechangechangeBtn.backgroundColor=[UIColor yellowColor];
    [changechangechangeBtn addTarget:self action:@selector(changeBtnDown:) forControlEvents:UIControlEventTouchUpInside];
    btn1=changechangechangeBtn;
    [self.view addSubview:btn1];
    [backgroundView addSubview:changechangechangeBtn];
    
    btn2=[UIButton buttonWithType:UIButtonTypeCustom];
    btn2.frame=CGRectMake(170, kScreen_height/5, 100, 100);
  // btn2.backgroundColor=[UIColor blackColor];
    
    [btn2 addTarget:self action:@selector(pingshuBtnDown:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn2];
    
    
    btn3=[UIButton buttonWithType:UIButtonTypeCustom];
    btn3.frame=CGRectMake(50, kScreen_height/5+100+23, 100, 100);
 //   btn3.backgroundColor=[UIColor blackColor];
    
    [btn3 addTarget:self action:@selector(guoxueBtnDown:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn3];
    
    btn4=[UIButton buttonWithType:UIButtonTypeCustom];
    btn4.frame=CGRectMake(170, kScreen_height/5+100+22, 100, 100);
  //  btn4.backgroundColor=[UIColor yellowColor];
    NSLog(@"比例是%f",21/kScreen_height );
    
    
    [btn4 addTarget:self action:@selector(huibenBtnDown:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn4];
    
    btn5=[UIButton buttonWithType:UIButtonTypeCustom];
    btn5.frame=CGRectMake(50, kScreen_height/5+100+22+100+20, 100, 100);
   // btn5.backgroundColor=[UIColor yellowColor];
    
    [btn5 addTarget:self action:@selector(baikeBtnDown:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn5];
    
    btn6=[UIButton buttonWithType:UIButtonTypeCustom];
    btn6.frame=CGRectMake(170, kScreen_height/5+100+22+100+20, 100, 100);
   // btn6.backgroundColor=[UIColor yellowColor];
    
    [btn6 addTarget:self action:@selector(huazuoBtnDown:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn6];
   // tabbar.hidden=YES;

    //chulijian
    
    if(kScreen_height==480)
    {
        NSLog(@"320*480");
        btn1.frame=CGRectMake(50, kScreen_height/5, 100, 100);
        btn2.frame=CGRectMake(170, kScreen_height/5, 100, 100);
        btn3.frame=CGRectMake(50, kScreen_height/5*(1+0.045)+100, 100, 100);
        btn4.frame=CGRectMake(170, kScreen_height/5*(1+0.045)+100, 100, 100);
        btn5.frame=CGRectMake(50, kScreen_height/5*(1+0.045*2)+200, 100, 100);
        btn6.frame=CGRectMake(170, kScreen_height/5*(1+0.045*2)+200, 100, 100);
    }

}
//chulijian



//chulijian
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark sixBtnDownEvent By chulijian



- (void)changeBtnDown:(UIButton *)btn11
{
   // [self.view addSubview:lessonTable];
    _img.hidden=YES;
    btn1.hidden=YES;
    btn2.hidden=YES;
    btn3.hidden=YES;
    btn4.hidden=YES;
    btn5.hidden=YES;
    btn6.hidden=YES;
    [self setViewTitle:@"变变变"];
    bbTopbar.hidden=NO;
    lessonTable.hidden=NO;
    backToHomeBtn.hidden=NO;
    lessonType.selectedIndex=1;

    
    
    //  [TaskQueue addTaskToQueue:_task];
    //  [_task release];
    //  [btn removeFromSuperview];
    //  [lessonTable release];

}
- (void)pingshuBtnDown:(UIButton *)btn22
{
    bbTopbar.hidden=NO;
    btn1.hidden=YES;
    btn2.hidden=YES;
    btn3.hidden=YES;
    btn4.hidden=YES;
    btn5.hidden=YES;
    btn6.hidden=YES;
    _img.hidden=YES;
    [self setViewTitle:@"评书"];
    lessonTable.hidden=NO;
    backToHomeBtn.hidden=NO;
    lessonType.selectedIndex=2;

}
- (void)guoxueBtnDown:(UIButton *)btn33
{
    bbTopbar.hidden=NO;
    btn1.hidden=YES;
    btn2.hidden=YES;
    btn3.hidden=YES;
    btn4.hidden=YES;
    btn5.hidden=YES;
    btn6.hidden=YES;
    _img.hidden=YES;
    [self setViewTitle:@"国学"];

     lessonTable.hidden=NO;
    backToHomeBtn.hidden=NO;
    lessonType.selectedIndex=3
    ;
    
}

- (void)huibenBtnDown:(UIButton *)btn44
{
    bbTopbar.hidden=NO;
    btn1.hidden=YES;
    btn2.hidden=YES;
    _img.hidden=YES;
    btn3.hidden=YES;
    btn4.hidden=YES;
    btn5.hidden=YES;
    btn6.hidden=YES;
    [self setViewTitle:@"绘本"];

    lessonTable.hidden=NO;
    backToHomeBtn.hidden=NO;
    lessonType.selectedIndex=0;


}

- (void)baikeBtnDown:(UIButton *)btn55
{
    bbTopbar.hidden=NO;
    btn1.hidden=YES;
    btn2.hidden=YES;
    _img.hidden=YES;
    btn3.hidden=YES;
    btn4.hidden=YES;
    btn5.hidden=YES;
    btn6.hidden=YES;
    [self setViewTitle:@"百科"];
    
    
    lessonTable.hidden=NO;
    backToHomeBtn.hidden=NO;
    lessonType.selectedIndex=4;
    
    
}
- (void)huazuoBtnDown:(UIButton *)btn66
{
    bbTopbar.hidden=NO;
    btn1.hidden=YES;
    btn2.hidden=YES;
    _img.hidden=YES;
    btn3.hidden=YES;
    btn4.hidden=YES;
    btn5.hidden=YES;
    btn6.hidden=YES;
    [self setViewTitle:@"画作"];

    [self setTitle:@"画作"];
    lessonTable.hidden=NO;
    backToHomeBtn.hidden=NO;
    lessonType.selectedIndex=5;
    
    
}
- (void)backToHome:(UIButton *)btn
{
    _img.hidden=NO;
    btn.hidden=YES;
    bbTopbar.hidden=YES;
    lessonTable.hidden=YES;
    
    
    btn1.hidden=NO;
    btn2.hidden=NO;
    btn3.hidden=NO;
    btn4.hidden=NO;
    btn5.hidden=NO;
    btn6.hidden=NO;
    
    
   //[self.view addSubview:btn1];
   // [btn removeFromSuperview];
   // [lessonTable removeFromSuperview];
    
}




#pragma mark sixBtnDownEvent By chulijian

#pragma ui event

- (void)btnAction {
    //    CartViewController
    
    CartViewController *dCtr = [[CartViewController alloc] init];
    [ctr pushViewController:dCtr animation:ViewSwitchAnimationSwipeR2L];
    [dCtr release];
}

- (void)segmentSelected:(int)index {
    currentPage = 1;
    lessonTable.isRefreshing = YES;
    [self loadLesson];
}

- (void)loadLesson
{
    LessonTask * task = [[LessonTask alloc] initGetLesson:lessonType.selectedIndex
                                                     age:0
                                                    page:currentPage
                                                   count:LESSON_PAGE_SIZE];
    
    task.logicCallbackBlock = ^(bool succeeded, id userInfo)
    {
        if (currentPage == 1)
        {
            [lessons removeAllObjects];
        }
        
        if (succeeded)
        {
            [lessons addObjectsFromArray:(NSArray *)userInfo];
            if ([((NSArray *)userInfo) count] < LESSON_PAGE_SIZE)
            {
                lessonTable.hasMore = NO;
            }
            else
            {
                lessonTable.hasMore = YES;
            }
        }
        
        [lessonTable reloadData];
        [lessonTable stopLoading];
    };
    
    [TaskQueue addTaskToQueue:task];
    _task=task;
    
    [task release];
    
    
    LessonTask *recommentTask = [[LessonTask alloc] initRecommendLessonList];
    recommentTask.logicCallbackBlock = ^(bool succeeded, id userInfo)
    {
        if (succeeded)
        {
            [recLessons removeAllObjects];
            [recLessons addObjectsFromArray:userInfo];
            
            NSMutableArray *pictures = [[NSMutableArray alloc] init];
            for (Lesson *l in recLessons)
            {
                [pictures addObject:l.cover];
            }
            banner.banners = pictures;
            [banner updateLayout];
            [pictures release];
        }
    };
    //chulijian课堂
    [TaskQueue addTaskToQueue:recommentTask];
    [recommentTask release];

}

- (void)startPlayPreview {
    if (self.playingLessonId > 0)
    {
        
    }
}

- (void)stopPlayPreview {

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
    if (!cell)
    {
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
    [ctr pushViewController:lCtr animation:ViewSwitchAnimationBounce];
    [lCtr release];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *bg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 0)];
    bg.backgroundColor = [Shared bbWhite];
  //  [bg addSubview:lessonType];
    return [bg autorelease];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    //chulijian周二2015年03月17日22:38:37
   // return 39;
    return 0;

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


#pragma mark image player delegate
- (void)handleTouchAtIndex:(int)index
{
    if (index < recLessons.count)
    {
        Lesson *l = [recLessons objectAtIndex:index];
        
        LessonDetailViewController *lCtr = [[LessonDetailViewController alloc] initWithLesson:l._id];
        [ctr pushViewController:lCtr animation:ViewSwitchAnimationBounce];
        [lCtr release];
    }
}


@end
