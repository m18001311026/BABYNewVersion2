//
//  FeedbackViewController.m
//  baby
//
//  Created by zhang da on 14-4-21.
//  Copyright (c) 2014年 zhang da. All rights reserved.
//

#import "FeedbackViewController.h"
#import "UIButtonExtra.h"
#import "MobClick.h"
#import "FeedbackTask.h"
#import "TaskQueue.h"

#define PLACE_HOLDER @"感谢您提出意见反馈"

@interface FeedbackViewController () {
    UITextView *content;
}

@end

@implementation FeedbackViewController

- (void)dealloc {
    
    [super dealloc];
}


- (id)init {
    self = [super init];
    if (self) {

        self.view.backgroundColor = [Shared bbRealWhite];
        
        content = [[UITextView alloc] initWithFrame:CGRectMake(0, 44, 320, 100)];
        content.font = [UIFont systemFontOfSize:15];
        content.backgroundColor = [UIColor whiteColor];
        content.alwaysBounceVertical = YES;
        content.delegate = self;
        content.textColor = [UIColor grayColor];
        [self.view addSubview:content];
        [content release];
        
        placeHolder = [[UILabel alloc] initWithFrame:CGRectMake(8, 54, 284, 16)];
        placeHolder.font = [UIFont systemFontOfSize:15];
        placeHolder.backgroundColor = [UIColor clearColor];
        placeHolder.textColor = [UIColor lightGrayColor];
        placeHolder.text = PLACE_HOLDER;
        placeHolder.userInteractionEnabled = NO;
        [self.view addSubview:placeHolder];
        [placeHolder release];
        
        UIButton *back = [UIButton buttonWithCustomStyle:CustomButtonStyleBack];
        [back addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        [bbTopbar addSubview:back];
        
        UIButton *sendBtn = [UIButton simpleButton:@"发送" y:156];
        [sendBtn addTarget:self action:@selector(send) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:sendBtn];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setViewTitle:@"意见反馈"];
    bbTopbar.backgroundColor = [UIColor colorWithRed:234/255.0 green:166/255.0 blue:31/255.0 alpha:1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)back {
    [ctr popViewControllerAnimated:YES];
}

- (void)send {
    [content resignFirstResponder];
    
    if (content.text) {
        FeedbackTask *task = [[FeedbackTask alloc] initFeedback:content.text];
        task.logicCallbackBlock = ^(bool success, id userInfo) {
            if (success) {
                [UI showAlert:@"发送成功，我们的工作人员会尽快处理"];
                [self back];
            } else {
                [UI showAlert:@"发送失败，请稍后重试"];
            }
        };
        [TaskQueue addTaskToQueue:task];
        [task release];
    }
}

#pragma mark uitextfield delegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    if ([textView.text length] + [text length] - range.length == 0 ){
        placeHolder.text = PLACE_HOLDER;
    } else {
        placeHolder.text = @"";
    }
    return YES;
}

@end
