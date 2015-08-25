//
//  ALMoviePlayerController.h
//  ALMoviePlayerController
//
//  Created by Anthony Lobianco on 10/8/13.
//  Copyright (c) 2013 Anthony Lobianco. All rights reserved.
//

#import <MediaPlayer/MPMoviePlayerController.h>
#import "ALMoviePlayerControls.h"

static NSString * const ALMoviePlayerContentURLDidChangeNotification = @"ALMoviePlayerContentURLDidChangeNotification";

@protocol ALMoviePlayerControllerDelegate <NSObject>
@optional
- (void)movieTimedOut;
- (void)moviePreviewEnded;
@required
- (void)moviePlayerWillMoveFromWindow;
@end


@interface ALMoviePlayerController : MPMoviePlayerController {
    UIView *movieBackgroundView;
}

@property (nonatomic, assign) id<ALMoviePlayerControllerDelegate> delegate;
@property (nonatomic, assign) UIInterfaceOrientation orientation;
@property (nonatomic, assign) bool enableAutorotate;

//- (id)initWithFrame:(CGRect)frame;
- (id)initWithFrame:(CGRect)frame urlStr: (NSString *)url;
- (void)setFrame:(CGRect)frame;
- (void)destroy;

- (void)rotateMoviePlayerTo:(UIInterfaceOrientation)orientation
                   animated:(BOOL)animated
                 completion:(void (^)(void))completion;

@end
