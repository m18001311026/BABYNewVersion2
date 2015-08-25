//
//  LessonHeader.h
//  baby
//
//  Created by zhang da on 14-3-24.
//  Copyright (c) 2014年 zhang da. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ImageView;

@interface LessonHeader : UIView {
    ImageView *mask;
}

@property (nonatomic, retain) NSString *videoPath;
@property (nonatomic, retain) NSString *thumbPath;
@property (nonatomic, assign, readonly) int lessonRelation;

- (id)initWithFrame:(CGRect)frame lesson:(long)lessonId;

@end
