//
//  LessonHeader.m
//  baby
//
//  Created by zhang da on 14-3-24.
//  Copyright (c) 2014年 zhang da. All rights reserved.
//

#import "LessonHeader.h"
#import "ALMoviePlayerController.h"
#import "ImageView.h"
#import "CartTask.h"
#import "TaskQueue.h"
#import "UserLessonLK.h"
#import "ConfigManager.h"
#import "Lesson.h"

@interface LessonHeader () <ALMoviePlayerControllerDelegate>

@property (nonatomic, retain) ALMoviePlayerController *moviePlayer;
@property (nonatomic) CGRect defaultFrame;

@end


@implementation LessonHeader {
    long _lessonId;
}

- (void)dealloc {
    [_moviePlayer stop];
    [_moviePlayer destroy];
    [_moviePlayer release];
    _moviePlayer = nil;
    
    self.thumbPath = nil;
    self.videoPath = nil;
    [mask release];

    [super dealloc];
}

- (void)setThumbPath:(NSString *)thumbPath {
    if (_thumbPath != thumbPath) {
        [_thumbPath release];
        _thumbPath = [thumbPath retain];
        
        mask.imagePath = _thumbPath;
    }
}

- (ALMoviePlayerController *)moviePlayer {
    if (!_moviePlayer) {

        _moviePlayer = [[ALMoviePlayerController alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) urlStr:self.videoPath];
        _moviePlayer.delegate = self;
//        if (self.lessonRelation != 3) {
//            if (![ConfigManager me].runInReviewMode) {
//                _moviePlayer.initialPlaybackTime = VIDEO_PREVIEW_BEGIN;
//                _moviePlayer.endPlaybackTime = VIDEO_PREVIEW_BEGIN + VIDEO_PREVIEW_LENGTH;                
//            }
//        }
    }
    return _moviePlayer;
}

- (id)initWithFrame:(CGRect)frame lesson:(long)lessonId {
    self = [super initWithFrame:frame];
    if (self) {
        mask = [[ImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        mask.backgroundColor = [UIColor blackColor];
        mask.userInteractionEnabled = YES;
        [self addSubview:mask];
        
        _lessonRelation = -1;
        _lessonId = lessonId;
        
        UIButton *playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        playBtn.frame = CGRectMake(0, 0, 50, 50);
        playBtn.center = mask.center;
        playBtn.layer.cornerRadius = 25;
        playBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        playBtn.layer.borderWidth = 2.0f;
        playBtn.backgroundColor = [UIColor clearColor];
        [playBtn setImageEdgeInsets:UIEdgeInsetsMake(10, 15, 10, 10)];
        [playBtn setImage:[UIImage imageNamed:@"play_indicator"] forState:UIControlStateNormal];
        [playBtn addTarget:self action:@selector(play) forControlEvents:UIControlEventTouchUpInside];
        [mask addSubview:playBtn];
    }
    return self;
}

- (void)play {
    void (^play)() = ^() {
        [UIView animateWithDuration:.3
                         animations:^{
                             mask.alpha = 0;
                         }
                         completion:^(BOOL finished) {
                             mask.alpha = 1;
                             [mask removeFromSuperview];
                             NSLog(@"start play:%@", self.videoPath);
                             [self.moviePlayer setContentURL:[NSURL URLWithString:self.videoPath]];
                             [self addSubview:self.moviePlayer.view];
                         }];
    };
    
    if (self.lessonRelation < 0) {
        CartTask *task = [[CartTask alloc] initLessonRelationQuery:_lessonId];
        task.logicCallbackBlock = ^(bool succeeded, id userInfo) {
            if (succeeded) {
                UserLessonLK *lk = [UserLessonLK getUserLessonLK:[ConfigManager me].userId
                                                          lesson:_lessonId];
                _lessonRelation = lk.status;
                play();
            }
        };
        [TaskQueue addTaskToQueue:task];
        [task release];
    } else {
        play();
    }

}


#pragma mark ALMoviePlayerControllerDelegate
- (void)moviePlayerWillMoveFromWindow {

    [self.moviePlayer.view removeFromSuperview];
    [self addSubview:self.moviePlayer.view];
    [self.moviePlayer setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];

}

- (UIView *)lessonPreviewEndView {
    Lesson *lesson = [Lesson getLessonWithId:_lessonId];
    
    UIView *end = [[UIView alloc] initWithFrame:mask.frame];
    
    UILabel *indicator = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, 320, 23)];
    indicator.text = @"试看已结束，如需继续观看请点击下方购买";
    indicator.font = [UIFont systemFontOfSize:14];
    //indicator.font = [UIFont fontWithName:@"DBLCDTempBlack" size:22];
    indicator.textColor = [UIColor whiteColor];
    indicator.textAlignment = UITextAlignmentCenter;
    indicator.backgroundColor = [UIColor clearColor];
    [end addSubview:indicator];
    [indicator release];
    
    UILabel *price = [[UILabel alloc] initWithFrame:CGRectMake(0, 75, 320, 14)];
    price.text = [NSString stringWithFormat:@"学费: %.2f元", lesson.price];
    price.font = [UIFont systemFontOfSize:12];
    price.textColor = [UIColor whiteColor];
    price.textAlignment = UITextAlignmentCenter;
    price.backgroundColor = [UIColor clearColor];
    [end addSubview:price];
    [price release];
    
    UILabel *time = [[UILabel alloc] initWithFrame:CGRectMake(0, 92, 320, 14)];
    time.text = [NSString stringWithFormat:@"时长: %d分", lesson.videoLength];
    time.font = [UIFont systemFontOfSize:12];
    time.textColor = [UIColor whiteColor];
    time.textAlignment = UITextAlignmentCenter;
    time.backgroundColor = [UIColor clearColor];
    [end addSubview:time];
    [time release];
    
    return [end autorelease];
}

- (void)movieTimedOut {
    [UI showAlert:@"视频无法加载，请稍后重试"];
}

- (void)moviePreviewEnded {
    [self addSubview:[self lessonPreviewEndView]];
    //[UI showAlert:@"视频预览结束，如需继续收看请购买"];
}

@end
