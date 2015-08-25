//
//  IntroViewController.m
//  baby
//
//  Created by zhang da on 14-5-3.
//  Copyright (c) 2014年 zhang da. All rights reserved.
//

#import "IceViewController.h"
#import "UIButtonExtra.h"

@interface IceViewController ()

@end

@implementation IceViewController

- (void)dealloc {
    
    [super dealloc];
}

- (id)init {
    self = [super init];
    if (self) {
        self.view.backgroundColor = [Shared bbRealWhite];

        UIScrollView *holder = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 44, 320, screentContentHeight - 44)];
        [self.view addSubview:holder];
        holder.contentSize = CGSizeMake(320, 670);
        [holder release];
        
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 490)];
        [holder addSubview:image];
        image.image = [UIImage imageNamed:@"iceberg.jpg"];
        [image release];
        
        UITextView *detail = [[UITextView alloc] initWithFrame:
                              CGRectMake(10, 490, 300, 180)];
        detail.font = [UIFont systemFontOfSize:15];
        detail.backgroundColor = [UIColor clearColor];
        detail.alwaysBounceVertical = YES;
        detail.editable = NO;
        detail.textColor = [UIColor grayColor];
        detail.showsVerticalScrollIndicator = NO;
        [holder addSubview:detail];
        [detail release];
        
        UIButton *back = [UIButton buttonWithCustomStyle:CustomButtonStyleBack];
        [back addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        [bbTopbar addSubview:back];
        
        detail.text = @"       浮在水面上的冰山是显现在外的，例如家长朋友们可以看到的孩子画一张画的效果，学习到了什么样的技法，画得像不像等。而真正隐藏在水面下的冰山蕴藏着各种潜能，譬如：想象力、自信力、创新力、专注力、表达力等更为重要。宝贝计画就是通过学习画画，将冰山下方的潜在能力引导出来，理解智慧、感悟成长。";
    }
    return self;
}

- (void)back {
    [ctr popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setViewTitle:@"冰山理论"];
    bbTopbar.backgroundColor = [UIColor colorWithRed:234/255.0 green:166/255.0 blue:31/255.0 alpha:1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
