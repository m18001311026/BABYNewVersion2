//
//  CartViewController.m
//  baby
//
//  Created by zhang da on 14-3-3.
//  Copyright (c) 2014年 zhang da. All rights reserved.
//

#import "CartViewController.h"
#import "LessonDetailViewController.h"
#import "ConfigManager.h"
#import "CartTask.h"
#import "OrderTask.h"
#import "TaskQueue.h"
#import "Lesson.h"
//#import <AlipaySDK/Alipay.h>
#import "MobClick.h"
#import "ConfigManager.h"

#if TARGET_IPHONE_SIMULATOR
#else
//#import "UPPayPlugin.h"
#endif

#import "UIBlockSheet.h"
#import "NSStringExtra.h"
#import "UIButtonExtra.h"

@interface CartViewController ()

@end

@implementation CartViewController

- (void)dealloc {
    [lessons release];
    
    [super dealloc];
}

- (id)init {
    self = [super init];
    if (self) {
        self.view.backgroundColor = [UIColor whiteColor];
        
        lessonTable = [[PullTableView alloc] initWithFrame:CGRectMake(0, 44, 320, screentContentHeight - 44 - 40)
                                                     style:UITableViewStylePlain];
        lessonTable.pullDelegate = self;
        lessonTable.delegate = self;
        lessonTable.dataSource = self;
        lessonTable.pullBackgroundColor = [Shared bbRealWhite];
        lessonTable.backgroundColor = [Shared bbRealWhite];
        [lessonTable setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
        lessonTable.separatorColor = [UIColor whiteColor];
        [self.view addSubview:lessonTable];
        [lessonTable release];
        
        total = [[CartTotalView alloc] initWithFrame:CGRectMake(0, screentContentHeight - 40, 320, 40)];
        total.delegate = self;
        [self.view addSubview:total];
        [total release];
        
        lessons = [[NSMutableArray alloc] initWithCapacity:0];
        checkedLessons = [[NSMutableArray alloc] initWithCapacity:0];
        
        [self loadCart];
        
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
    
    [self setViewTitle:@"购物车"];
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

- (void)loadCart {
    
    if ([[ConfigManager me] runInReviewMode]) {
        [lessons removeAllObjects];
        lessonTable.hasMore = NO;
        [lessonTable reloadData];
        [lessonTable stopLoading];
        [lessonTable showPlaceHolder:@"您的购物车尚无课程"];
        return;
    }
    
    
    CartTask *task = [[CartTask alloc] initLessonCart];
    task.logicCallbackBlock = ^(bool succeeded, id userInfo) {
        [lessons removeAllObjects];
        
        if (succeeded) {
            [lessons addObjectsFromArray:(NSArray *)userInfo];
        }
        
        lessonTable.hasMore = NO;
        [lessonTable reloadData];
        [lessonTable stopLoading];
        
        if (lessons.count == 0) {
            [lessonTable showPlaceHolder:@"您的购物车尚无课程"];
        } else {
            [lessonTable showPlaceHolder:nil];
        }
    };
    [TaskQueue addTaskToQueue:task];
    [task release];
}


#pragma table view section
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return lessons.count;
}

- (void)configCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    CartCell *cCell = (CartCell *)cell;
    if (lessons.count > indexPath.row) {
        cCell.lessonId = [[lessons objectAtIndex:indexPath.row] longValue];
        cCell.checked = [checkedLessons containsObject:@(cCell.lessonId)];
        [cCell updateLayout];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"lessoncell";
    CartCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[[CartCell alloc] initWithStyle:UITableViewCellStyleDefault
                                reuseIdentifier:cellId
                                          table:tableView] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
    }
    [self configCell:cell atIndexPath:indexPath];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 76;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *bg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 89)];
    bg.backgroundColor = [UIColor clearColor];
    return [bg autorelease];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 36;
}


#pragma mark pull table view delegate
- (void)pullTableViewDidTriggerRefresh:(PullTableView*)pullTableView {
    [self loadCart];
}

- (void)pullTableViewDidTriggerLoadMore:(PullTableView*)pullTableView {
    [self loadCart];
}


#pragma mark card cell delegte
//- (void)checkBtnTouchedForLesson:(long)lessonId {
//    if ([checkedLessons containsObject:@(lessonId)]) {
//        [checkedLessons removeObject:@(lessonId)];
//    } else {
//        [checkedLessons addObject:@(lessonId)];
//    }
//    
//    [lessonTable reloadData];
//    total.count = checkedLessons.count;
//    
//    float money = 0;
//    for (NSNumber *lessonId in checkedLessons) {
//        Lesson *l = [Lesson getLessonWithId:[lessonId longValue]];
//        money += l.price;
//    }
//    total.total = money;
//}

- (void)previewTouchedForLesson:(long)lessonId {    
    LessonDetailViewController *lCtr = [[LessonDetailViewController alloc] initWithLesson:lessonId];
    [ctr pushViewController:lCtr animation:ViewSwitchAnimationBounce];
    [lCtr release];
}

- (void)deleteTouchedForLesson:(long)lessonId {
    CartTask *task = [[CartTask alloc] initEditLesson:lessonId relation:false];
    task.logicCallbackBlock = ^(bool successful, id userinfo) {
        if (successful) {
            [lessons removeObject:@(lessonId)];
            [lessonTable reloadData];
        }
    };
    [TaskQueue addTaskToQueue:task];
    [task release];
}


#pragma mark total view delegate
//- (void)selectAllTouched {
//    total.selectAll = !total.selectAll;
//    [checkedLessons removeAllObjects];
//    if (total.selectAll) {
//        [checkedLessons addObjectsFromArray:lessons];
//    }
//    
//    [lessonTable reloadData];
//    total.count = checkedLessons.count;
//    float money = 0;
//    for (NSNumber *lessonId in checkedLessons) {
//        Lesson *l = [Lesson getLessonWithId:[lessonId longValue]];
//        money += l.price;
//    }
//    total.total = money;
//}

- (void)checkoutTouched {
    if (checkedLessons.count < 1) {
        [UI showAlert:@"请选择课程"];
        return;
    }
    
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
//    OrderTask *task = [[OrderTask alloc] initOrderAdd:checkedLessons];
//    task.logicCallbackBlock = ^(bool success, id userInfo) {
//        if (success) {
//            for (NSNumber *lessonId in checkedLessons) {
//                Lesson *lesson = [Lesson getLessonWithId:[lessonId longValue]];
//                if (lesson) {
//                    [MobClick event:UMENG_BUY_LESSONTYPE label:[NSString stringWithFormat:@"%d", lesson.type]];
//                }
//            }
//
//            OrderTask *confirmTask = [[OrderTask alloc] initOrderConfirm:[userInfo longValue] payMethod:2];
//            confirmTask.logicCallbackBlock = ^(bool success, id userInfo) {
//                
//                if (success) {
//                    if (!userInfo) {
//                        [UI showAlert:@"恭喜您购买成功"];
//                        [self loadCart];
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
//                                           [self loadCart];
//                                       }];
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
//    OrderTask *task = [[OrderTask alloc] initOrderAdd:checkedLessons];
//    task.logicCallbackBlock = ^(bool success, id userInfo) {
//        if (success) {
//            for (NSNumber *lessonId in checkedLessons) {
//                Lesson *lesson = [Lesson getLessonWithId:[lessonId longValue]];
//                if (lesson) {
//                    [MobClick event:UMENG_BUY_LESSONTYPE label:[NSString stringWithFormat:@"%d", lesson.type]];
//                }
//            }
//
//            OrderTask *confirmTask = [[OrderTask alloc] initOrderConfirm:[userInfo longValue] payMethod:4];
//            confirmTask.logicCallbackBlock = ^(bool success, id userInfo) {
//                
//                if (success) {
//                    if (!userInfo) {
//                        [UI showAlert:@"恭喜您购买成功"];
//                        [self loadCart];
//                    } else {
//#if TARGET_IPHONE_SIMULATOR
//#else
//                        [UPPayPlugin startPay:userInfo
//                                   sysProvide:nil
//                                         spId:nil
//                                         mode:@"00"
//                               viewController:delegate.window.rootViewController
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
@end
