//
//  WebViewController.m
//  baby
//
//  Created by chenxin on 14-12-17.
//  Copyright (c) 2014年 zhang da. All rights reserved.
//

#import "WebViewController.h"
#import "Macro.h"
#import "UIButtonExtra.h"

@interface WebViewController ()

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 44, kScreenWidth, kScreenHeight - 44)];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:self.url];
    [webView loadRequest:request];
    [request release];
    [self.view addSubview:webView];
    [webView release];
    
    UIButton *back = [UIButton buttonWithCustomStyle:CustomButtonStyleBack];
    [back addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [bbTopbar addSubview:back];
    [back release];
}

- (void)back {
    [ctr popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
