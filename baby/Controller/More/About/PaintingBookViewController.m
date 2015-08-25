//
//  IntroViewController.m
//  baby
//
//  Created by zhang da on 14-5-3.
//  Copyright (c) 2014年 zhang da. All rights reserved.
//

#import "PaintingBookViewController.h"
#import "UIButtonExtra.h"

@interface PaintingBookViewController ()

@end

@implementation PaintingBookViewController

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
        
        detail.text = @"       英文称之为picture book，就是画出来的书，也可以理解为图画书。宝贝计画的绘本教学，立时多年研发，长期耕耘在一线，积攒了大量孩子亲手创作的原创绘本，当孩子们用一年的时间创作出自己的绘本书时，孩子脸上的那种幸福是难以用言语形容的，不但有了一本亲自创作的绘本，更重要的是可以激起孩子的自豪感，建立孩子自信心。而且等孩子长大是可以作为童年的一段多么美好的回忆。";
    }
    return self;
}

- (void)back {
    [ctr popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setViewTitle:@"绘本"];
    bbTopbar.backgroundColor = [UIColor colorWithRed:234/255.0 green:166/255.0 blue:31/255.0 alpha:1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
