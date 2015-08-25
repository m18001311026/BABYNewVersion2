//
//  OrderTask.m
//  baby
//
//  Created by zhang da on 14-4-30.
//  Copyright (c) 2014年 zhang da. All rights reserved.
//

#import "OrderTask.h"
#import "ConfigManager.h"
#import "Session.h"
#import "Order.h"
#import "Lesson.h"
#import "MemContainer.h"
#import "MobClick.h"


@implementation OrderTask

- (id)initOrderAdd:(NSArray *)lessonIds {
    self = [super initWithUrl:SERVERURL method:POST session:[[ConfigManager me] getSession].session];
    if (self) {
        [self addParameter:@"action" value:@"order_Add"];
        
        NSMutableString *lIds = [[NSMutableString alloc] init];
        for (NSNumber *lid in lessonIds) {
            [lIds appendString:[NSString stringWithFormat:@"%@", lid]];
            [lIds appendString:@","];
        }
        if ([lIds length]) {
            [lIds deleteCharactersInRange:NSMakeRange([lIds length] - 1, 1)];
        }
        [self addParameter:@"lesson_ids" value:lIds];
        [lIds release];
        
        self.responseCallbackBlock = ^(bool succeeded, id userInfo) {
            if (succeeded) {
                long orderId = [[userInfo objectForKey:@"orderId"] longValue];
                if (orderId) {
                    [MobClick event:UMENG_BUY_LESSONCNT label:[NSString stringWithFormat:@"%d", lessonIds.count]];
                    
                    [self doLogicCallBack:YES info:@(orderId)];
                } else {
                    [self doLogicCallBack:NO info:nil];
                }
            } else {
                [self doLogicCallBack:NO info:userInfo];
            }
        };
    }
    return self;
}

- (id)initOrderConfirm:(long)orderId payMethod:(int)payMethod {
    self = [super initWithUrl:SERVERURL method:POST session:[[ConfigManager me] getSession].session];
    if (self) {
        [self addParameter:@"action" value:@"order_Confirm"];
        [self addParameter:@"order_id" value:[NSString stringWithFormat:@"%ld", orderId]];
        [self addParameter:@"pay_method" value:[NSString stringWithFormat:@"%d", payMethod]];
        
        self.responseCallbackBlock = ^(bool succeeded, id userInfo) {
            if (succeeded) {
                NSDictionary *payInfo = [userInfo objectForKey:@"payInfo"];
                if (payInfo) {
                    NSString *sign = payInfo[@"sign"];
                    [self doLogicCallBack:YES info:sign];
                } else {
                    [self doLogicCallBack:YES info:nil];
                }
            } else {
                [self doLogicCallBack:NO info:userInfo];
            }
        };
    }
    return self;
}

- (id)initOrderListAtPage:(int)page count:(int)count {
    self = [super initWithUrl:SERVERURL method:POST session:[[ConfigManager me] getSession].session];
    if (self) {
        [self addParameter:@"action" value:@"order_Query"];
        [self addParameter:@"page" value:[NSString stringWithFormat:@"%d", page]];
        [self addParameter:@"count" value:[NSString stringWithFormat:@"%d", count]];
        
        self.responseCallbackBlock = ^(bool succeeded, id userInfo) {
            if (succeeded) {
                NSArray *orders = [userInfo objectForKey:@"orders"];
                
                if (orders && orders.count > 0) {
                    NSMutableArray *orderList = [[NSMutableArray alloc] initWithCapacity:0];
                    for (NSDictionary *orderDict in orders) {
                        Order *o = (Order *)[[MemContainer me] instanceFromDict:orderDict
                                                                          clazz:[Order class]];
                        [orderList addObject:o];
                    }
                    [self doLogicCallBack:YES info:[orderList autorelease]];
                } else {
                    [self doLogicCallBack:YES info:nil];
                }
            } else {
                [self doLogicCallBack:NO info:userInfo];
            }
        };
    }
    return self;
}

- (id)initOrderDetail:(long)orderId {
    self = [super initWithUrl:SERVERURL method:POST session:[[ConfigManager me] getSession].session];
    if (self) {
        [self addParameter:@"action" value:@"order_Query"];
        [self addParameter:@"order_id" value:[NSString stringWithFormat:@"%ld", orderId]];
        
        self.responseCallbackBlock = ^(bool succeeded, id userInfo) {
            if (succeeded) {
                NSDictionary *orderDict = [userInfo objectForKey:@"order"];
                Order *o = (Order *)[[MemContainer me] instanceFromDict:orderDict
                                                                  clazz:[Order class]];
                
                NSArray *lessons = [userInfo objectForKey:@"lessons"];
                if (lessons && lessons.count > 0) {
                    for (NSDictionary *lessonDict in lessons) {
                        [[MemContainer me] instanceFromDict:lessonDict clazz:[Lesson class]];
                    }
                }
                [self doLogicCallBack:YES info:o];
            } else {
                [self doLogicCallBack:NO info:userInfo];
            }
        };
    }
    return self;
}

- (id)initLessonBoughtListAtPage:(int)page count:(int)count {
    self = [super initWithUrl:SERVERURL method:POST session:[[ConfigManager me] getSession].session];
    if (self) {
        [self addParameter:@"action" value:@"lesson_Bought"];
        
        self.responseCallbackBlock = ^(bool succeeded, id userInfo) {
            if (succeeded) {
                NSArray *lessons = [userInfo objectForKey:@"lessons"];
                
                if (lessons && lessons.count > 0) {
                    NSMutableArray *lessonList = [[NSMutableArray alloc] initWithCapacity:0];
                    for (NSDictionary *lessonDict in lessons) {
                        Lesson *l = (Lesson *)[[MemContainer me] instanceFromDict:lessonDict
                                                                            clazz:[Lesson class]];
                        [lessonList addObject:@(l._id)];
                    }
                    [self doLogicCallBack:YES info:[lessonList autorelease]];
                } else {
                    [self doLogicCallBack:YES info:nil];
                }
            } else {
                [self doLogicCallBack:NO info:userInfo];
            }
        };
    }
    return self;
}

@end
