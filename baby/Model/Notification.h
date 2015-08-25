//
//  Notification.h
//  baby
//
//  Created by zhang da on 14-4-19.
//  Copyright (c) 2014年 zhang da. All rights reserved.
//

#import "Model.h"

@interface Notification : Model

@property (nonatomic, assign) int _id;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *content;
@property (nonatomic, retain) NSString *image;
@property (nonatomic, assign) long long expireDate;
@property (nonatomic, assign) long long createTime;

+ (Notification *)getNotificationWithId:(int)_id;

@end
