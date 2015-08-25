//
//  GComment.h
//  baby
//
//  Created by zhang da on 14-3-18.
//  Copyright (c) 2014年 zhang da. All rights reserved.
//

#import "Model.h"

@interface LComment : Model

@property (nonatomic, assign) long _id;
@property (nonatomic, retain) NSString *content;
@property (nonatomic, assign) long long createTime;
@property (nonatomic, assign) long lessonId;
@property (nonatomic, assign) long userId;
@property (nonatomic, retain) NSString *voice;
@property (nonatomic, assign) int voiceLength;
@property (nonatomic, retain) NSString *replyTo;

+ (LComment *)getCommentWithId:(long)_id;

@end
