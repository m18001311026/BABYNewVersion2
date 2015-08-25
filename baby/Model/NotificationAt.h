//
//  NotificationAt.h
//  baby
//
//  Created by zhang da on 14-6-16.
//  Copyright (c) 2014年 zhang da. All rights reserved.
//

#import "Model.h"

@interface NotificationAt : Model

@property (nonatomic, assign) long _id;
@property (nonatomic, assign) long galleryId;
@property (nonatomic, assign) long fromUserId;
@property (nonatomic, assign) long toUserId;
@property (nonatomic, assign) long long createTime;

@end
