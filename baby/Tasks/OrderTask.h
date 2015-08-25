//
//  OrderTask.h
//  baby
//
//  Created by zhang da on 14-4-30.
//  Copyright (c) 2014年 zhang da. All rights reserved.
//

#import "BBNetworkTask.h"

@interface OrderTask : BBNetworkTask

- (id)initOrderAdd:(NSArray *)lessonIds;
- (id)initOrderConfirm:(long)orderId payMethod:(int)payMethod;
- (id)initOrderListAtPage:(int)page count:(int)count;
- (id)initOrderDetail:(long)orderId;
- (id)initLessonBoughtListAtPage:(int)page count:(int)count;

@end
