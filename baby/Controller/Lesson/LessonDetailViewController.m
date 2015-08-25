//
//  LessonViewController.m
//  baby
//
//  Created by zhang da on 14-3-6.
//  Copyright (c) 2014年 zhang da. All rights reserved.
//

#import "LessonDetailViewController.h"
#import "UIButtonExtra.h"
#import "AudioPlayer.h"
#import "Lesson.h"

#import "LessonHeader.h"
#import "IndicatorSegment.h"
#import "LessonDetailView.h"
#import "LessonCommentView.h"
#import "LessonRecommendView.h"
#import "ShareManager.h"
#import "ConfigManager.h"

#import "OrderTask.h"
#import "TaskQueue.h"
#import "MobClick.h"

#if TARGET_IPHONE_SIMULATOR
#else
#import "UPPayPlugin.h"
#endif

#import "UIBlockSheet.h"
#import "NSStringExtra.h"

#define CURRENT_VIEW_TAG 899999

@interface LessonDetailViewController ()

@end


@implementation LessonDetailViewController

- (void)dealloc {
    [detail release];
    [comment release];
    [lessons release];

    [super dealloc];
}

- (id)initWithLesson:(long)lessonId {
    self = [super init];
    if (self) {
        
        self.lessonId = lessonId;
        
        header = [[LessonHeader alloc] initWithFrame:CGRectMake(0, 44, 320, 180) lesson:lessonId];
        [self.view addSubview:header];
        [header release];
        
        segment = [[IndicatorSegment alloc] initWithFrame:CGRectMake(0, 224, 320, 36)
                                                   titles:@[@"基本信息", @"评论", @"相关推荐"]];
        segment.selectedColor = [UIColor colorWithRed:234/255.0 green:166/255.0 blue:31/255.0 alpha:1];
        segment.backgroundColor = [Shared bbWhite];
        segment.delegate = self;
        segment.normalColor = [UIColor lightGrayColor];
        segment.textColor = [UIColor grayColor];
        segment.selectedIndex = 0;
        [segment updateLayout];
        [self.view addSubview:segment];
        [segment release];
        
        [self segmentSelected:0];
        
        [self updateLayout];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Custom initialization
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setViewTitle:@"画画"];
    bbTopbar.backgroundColor = [UIColor colorWithRed:234/255.0 green:166/255.0 blue:31/255.0 alpha:1];

    UIButton *back = [UIButton buttonWithCustomStyle:CustomButtonStyleBack];
    [back addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [bbTopbar addSubview:back];
    
    UIButton *share = [UIButton buttonWithCustomStyle:CustomButtonStyleShare position:CustomButtonPositonRight];
    [share addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
    [bbTopbar addSubview:share];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (userFlags.initAppear) {

    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [AudioPlayer stopPlay];
}


#pragma mark ui event
- (void)back {
    [ctr popViewControllerAnimated:YES];
}

- (void)share {
    Lesson *lesson = [Lesson getLessonWithId:self.lessonId];
    if (lesson) {
        UIImage *local = [IMG getImageFromDisk:lesson.cover];
        NSString *url = [NSString stringWithFormat:LESSON_PAGE, lesson._id];
        if (local) {
            [[ShareManager me] showShareMenuWithTitle:@"宝贝计画"
                                              content:lesson.title
                                                image:local
                                              pageUrl:url];
        } else {
            [[ShareManager me] showShareMenuWithTitle:@"宝贝计画"
                                              content:lesson.title
                                             imageUrl:lesson.cover
                                              pageUrl:url];
        }
    } else {
        [UI showAlert:@"课程详情尚未加载完成"];
    }
}

- (void)updateLayout {
    Lesson *lesson = [Lesson getLessonWithId:self.lessonId];
    
    header.thumbPath = lesson.cover;
    header.videoPath = lesson.videoMain;
}


#pragma mark segment delegate
- (UIView *)viewForIndex:(int)index {
    if (index == 0) {
        if (!detail) {
            detail = [[LessonDetailView alloc] initWithFrame:
                      CGRectMake(0, 260, 320, screentContentHeight - 260)
                                                      lesson:self.lessonId];
            detail.delegate = self;
        }
        [detail updateLayout];
        return detail;
    } else if (index == 1) {
        if (!comment) {
            comment = [[LessonCommentView alloc] initWithFrame:
                       CGRectMake(0, 260, 320, screentContentHeight - 260)
                                                        lesson:self.lessonId];
        }
        return comment;
    } else if (index == 2) {
        if (!lessons) {
            lessons = [[LessonRecommendView alloc] initWithFrame:
                       CGRectMake(0, 260, 320, screentContentHeight - 260)
                                                          lesson:self.lessonId];
        }
        return lessons;
    }
    return nil;
}

- (void)segmentSelected:(int)index {
    [UIView animateWithDuration:0.2 animations:^{
        [[self.view viewWithTag:CURRENT_VIEW_TAG] removeFromSuperview];
        
        UIView *view = [self viewForIndex:index];
        view.tag = CURRENT_VIEW_TAG;
        [self.view addSubview:view];
        [self.view bringSubviewToFront:view];
    }];
}


#pragma mark lesson detail view delegate
- (void)buyLesson {
    UIBlockSheet *sheet = [[UIBlockSheet alloc] initWithTitle:@"请选择支付方式"];
    
    if ([ConfigManager me].enableAlipay) {
        [sheet addButtonWithTitle:@"支付宝" block: ^{
            [self checkoutWithAlipay];
        }];
    }
    
    if ([ConfigManager me].enableUnionPay) {
        [sheet addButtonWithTitle: @"银联" block: ^{
            [self checkoutWithUnionpay];
        }];
    }
    
    [sheet setCancelButtonWithTitle: @"取消" block: ^{}];
    
    [sheet showInView:self.view];
    [sheet release];
}

//- (void)checkoutWithAlipay {
//    [UI showIndicator];
//    
//    OrderTask *task = [[OrderTask alloc] initOrderAdd:@[@(self.lessonId)]];
//    task.logicCallbackBlock = ^(bool success, id userInfo) {
//        if (success) {
//            Lesson *lesson = [Lesson getLessonWithId:self.lessonId];
//            if (lesson) {
//                [MobClick event:UMENG_BUY_LESSONTYPE label:[NSString stringWithFormat:@"%d", lesson.type]];
//            }
//
//            OrderTask *confirmTask = [[OrderTask alloc] initOrderConfirm:[userInfo longValue] payMethod:2];
//            confirmTask.logicCallbackBlock = ^(bool success, id userInfo) {
//                
//                if (success) {
//                    
//                    if (!userInfo) {
//                        [UI showAlert:@"恭喜您购买成功"];
//                        [detail updateLayout];
//                    } else {
//                        NSString *sign = [userInfo Base642String:NSUTF8StringEncoding];
//                        [[Alipay defaultService] pay:sign
//                                                From:@"BabyPainting"
//                                       CallbackBlock:^(NSString *resultString) {
//                                           NSError *error;
//                                           NSData *data = [resultString dataUsingEncoding:NSUTF8StringEncoding];
//                                           NSDictionary *jsonQuery = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
//                                           NSString *resultStatus = [jsonQuery objectForKey:@"ResultStatus"];
//                                           
//                                           //4000 订单支付失败
//                                           //8000 正在处理中
//                                           //6001 用户中途取消
//                                           //6002 网络连接错误
//                                           if([resultStatus isEqualToString:@"9000"]){
//                                               [UI showAlert:@"恭喜您支付成功"];
//                                           } else if([resultStatus isEqualToString:@"4000"]
//                                                     || [resultStatus isEqualToString:@"6002"]) {
//                                               [UI showAlert:@"支付失败，请重试"];
//                                           }
//                                           
//                                           NSLog(@"result = %@", resultString);
//                                           [detail updateLayout];
//                                       }];
//
//                    }
//                }
//                [UI hideIndicator];
//                
//            };
//            [TaskQueue addTaskToQueue:confirmTask];
//            [confirmTask release];
//        } else {
//            [UI hideIndicator];
//            [UI showAlert:@"下单失败，请稍后重试"];
//        }
//    };
//    [TaskQueue addTaskToQueue:task];
//    [task release];
//}
//
//- (void)checkoutWithUnionpay {
//    [UI showIndicator];
//    
//    OrderTask *task = [[OrderTask alloc] initOrderAdd:@[@(self.lessonId)]];
//    task.logicCallbackBlock = ^(bool success, id userInfo) {
//        if (success) {
//            Lesson *lesson = [Lesson getLessonWithId:self.lessonId];
//            if (lesson) {
//                [MobClick event:UMENG_BUY_LESSONTYPE label:[NSString stringWithFormat:@"%d", lesson.type]];
//            }
//            
//            OrderTask *confirmTask = [[OrderTask alloc] initOrderConfirm:[userInfo longValue] payMethod:4];
//            confirmTask.logicCallbackBlock = ^(bool success, id userInfo) {
//                
//                if (success) {
//                    if (!userInfo) {
//                        [UI showAlert:@"恭喜您购买成功"];
//                        [detail updateLayout];
//                    } else {
//#if TARGET_IPHONE_SIMULATOR
//#else
//                        [UPPayPlugin startPay:userInfo
//                                   sysProvide:nil
//                                         spId:nil
//                                         mode:@"00"
//                               viewController:self
//                                     delegate:self];
//#endif
//                    }
//                }
//                [UI hideIndicator];
//                
//            };
//            [TaskQueue addTaskToQueue:confirmTask];
//            [confirmTask release];
//        } else {
//            [UI hideIndicator];
//            [UI showAlert:@"下单失败，请稍后重试"];
//        }
//    };
//    [TaskQueue addTaskToQueue:task];
//    [task release];
//}
//
//- (void)UPPayPluginResult:(NSString *)result {
//    if ([result isEqualToString:@"success"]) {
//        [UI showAlert:@"恭喜您支付成功"];
//    }
//}
//
//

@end
