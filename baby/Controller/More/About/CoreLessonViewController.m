//
//  IntroViewController.m
//  baby
//
//  Created by zhang da on 14-5-3.
//  Copyright (c) 2014年 zhang da. All rights reserved.
//

#import "CoreLessonViewController.h"
#import "UIButtonExtra.h"

@interface CoreLessonViewController ()

@end

@implementation CoreLessonViewController

- (void)dealloc {
    
    [super dealloc];
}

- (id)init {
    self = [super init];
    if (self) {
        self.view.backgroundColor = [Shared bbRealWhite];

        UITextView *detail = [[UITextView alloc] initWithFrame:
                              CGRectMake(10, 50, 300, screentContentHeight - 50)];
        detail.font = [UIFont systemFontOfSize:15];
        detail.backgroundColor = [UIColor clearColor];
        detail.alwaysBounceVertical = YES;
        detail.editable = NO;
        detail.textColor = [UIColor grayColor];
        detail.showsVerticalScrollIndicator = NO;
        [self.view addSubview:detail];
        [detail release];
        
        UIButton *back = [UIButton buttonWithCustomStyle:CustomButtonStyleBack];
        [back addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        [bbTopbar addSubview:back];
        
        detail.text = @"儿童美术培训：3-8人制小班精准教学\n"
        @"\n1、（3 -7岁）变变变创新美术精品课程"
        @"\n       小班的孩子由于年龄小，所以画画经常是心中有想法，可是在纸上画不出来，针对这一现状，我们可教授技法和基本功。可是在教授的时候，如何避免把老师的思维有意或无意的灌输给孩子们呢？这就需要强调想象创意和强调技法的有机统一。"
        @"\n\n2、(7-16岁）绘本创作精品课程"
        @"\n       宝贝计画就是通过科学的教学体系，引导小朋友创作自己的绘本书，在整个过程中，一是启发孩子的想象力（例如需要孩子自己编故事），二是训练孩子的专业美术基本功（例如造型、色彩、构图、设计、透视原理、比例等等专业知识），三是锻炼孩子的毅力和专注力（例如画一个绘本需要一年，那么在过程总不能间断），第四可以训练孩子成为一名导演（例如孩子自己编剧、美术、剪辑、构图安排类似摄影，脚本设计类似对白，颜色搭配类似色彩，景别设计类似镜头，主人公设计类似演员安排、绘本的结构类似线索、绘本情节类似电影中的冲突、矛盾等剧情刻画等等）可见一个绘本的创作俨然如一部电影的完成！";
    }
    return self;
}

- (void)back {
    [ctr popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setViewTitle:@"核心课程"];
    bbTopbar.backgroundColor = [UIColor colorWithRed:234/255.0 green:166/255.0 blue:31/255.0 alpha:1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
