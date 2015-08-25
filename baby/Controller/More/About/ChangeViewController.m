//
//  IntroViewController.m
//  baby
//
//  Created by zhang da on 14-5-3.
//  Copyright (c) 2014年 zhang da. All rights reserved.
//

#import "ChangeViewController.h"
#import "UIButtonExtra.h"

@interface ChangeViewController ()

@end

@implementation ChangeViewController

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
        
        detail.text = @"       变变变”是“宝贝计画哲学 ”，源自《周易》“穷则变，变则通，通则久”哲学和德尔斐的阿波罗神庙箴言“认识你自己”。配合“宝贝计画变变变”教学体系在近4000名孩子的画画教学实践中不断总结，提炼而成。"
        @"\n\n三个变分别指"
        @"\n       变：指画面本身要不断变化 ，时刻创新。（专业层面）"
        @"\n       变：穷则思变，变则通，通则久的哲学智慧。（智慧层面）"
        @"\n       变：认识你自己，从内心自省。（内心层面）"
        @"\n       终极：宝贝计画的终极理想-通过画画，让孩子还原想象、树立自信、感悟智慧、温存内心 。";
    }
    return self;
}

- (void)back {
    [ctr popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setViewTitle:@"变变变"];
    bbTopbar.backgroundColor = [UIColor colorWithRed:234/255.0 green:166/255.0 blue:31/255.0 alpha:1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
