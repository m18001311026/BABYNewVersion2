//
//  VoiceMask.h
//  baby
//
//  Created by zhang da on 14-3-18.
//  Copyright (c) 2014年 zhang da. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VoiceMask : UIView {
    UIImageView *image;
    UIView *volumnIndicator;
    UILabel *timeLabel;

    NSTimer *timer;
    long startTimestamp;
    int firetimes;
}

@property (nonatomic, assign) int time;
- (void)startAnimation;
- (void)stopAnimation;

@end
