//
//  Picture.h
//  baby
//
//  Created by zhang da on 14-3-9.
//  Copyright (c) 2014年 zhang da. All rights reserved.
//

#import "Model.h"

@interface Picture : Model

@property (nonatomic, assign) long _id;
@property (nonatomic, retain) NSString *voice;
@property (nonatomic, assign) int voiceLength;
@property (nonatomic, retain) NSString *imageSmall;
@property (nonatomic, retain) NSString *imageMid;
@property (nonatomic, retain) NSString *imageBig;
@property (nonatomic, assign) long userId;
@property (nonatomic, retain) NSDate *createTime;

@property (nonatomic, retain) UIImage *localImage;
@property (nonatomic, retain) NSString *localVoice;

+ (Picture *)getPictureWithId:(long)_id;
- ( long)showUserId;
- (void)nnnnn:(long)userId ;
@end
