//
//  ALMoviePlayerController.m
//  ALMoviePlayerController
//
//  Created by Anthony Lobianco on 10/8/13.
//  Copyright (c) 2013 Anthony Lobianco. All rights reserved.
//

#import "ALMoviePlayerController.h"
#import <CoreMotion/CoreMotion.h>

@implementation UIDevice (ALSystemVersion)

+ (float)iOSVersion {
    static float version = 0.f;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        version = [[[UIDevice currentDevice] systemVersion] floatValue];
    });
    return version;
}

@end

@implementation UIApplication (ALAppDimensions)

+ (CGSize)sizeInOrientation:(UIInterfaceOrientation)orientation {
    CGSize size = [UIScreen mainScreen].bounds.size;
    UIApplication *application = [UIApplication sharedApplication];
    if (UIInterfaceOrientationIsLandscape(orientation)) {
        size = CGSizeMake(size.height, size.width);
    }
    if (!application.statusBarHidden && [UIDevice iOSVersion] < 7.0) {
        size.height -= MIN(application.statusBarFrame.size.width, application.statusBarFrame.size.height);
    }
    return size;
}

@end

static const CGFloat movieBackgroundPadding = 20.f; //if we don't pad the movie's background view, the edges will appear jagged when rotating
static const NSTimeInterval fullscreenAnimationDuration = 0.3;


@interface ALMoviePlayerController ()

@property (nonatomic, retain) ALMoviePlayerControls *controls;
@property (nonatomic, readwrite) BOOL movieFullscreen; //used to manipulate default fullscreen property
@property (nonatomic, copy) CMAccelerometerHandler orientationHandler;

@end


@implementation ALMoviePlayerController {
    CMMotionManager *_motionManager;
}

# pragma mark - Construct/Destruct
- (void)dealloc {
    [movieBackgroundView release];
    [_motionManager stopAccelerometerUpdates];
    [_motionManager release];

    self.orientationHandler = nil;
    
    self.delegate = nil;
    
    self.controls.moviePlayer = nil;
    [self.controls stopDurationTimer];
    self.controls = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [super dealloc];
}

- (id)init {
    return [self initWithFrame:CGRectZero];
}

- (id)initWithContentURL:(NSURL *)url {
    [[NSException exceptionWithName:@"ALMoviePlayerController Exception"
                             reason:@"Set contentURL after initialization."
                           userInfo:nil] raise];
    return nil;
}

- (id)initWithFrame:(CGRect)frame {
    
//    self = [super initWithContentURL:[NSURL URLWithString:@""]];
    
    self = [super init];
    
//    self = [super initWithContentURL:[NSURL URLWithString:@"http://img-children-sketchbook-com.oss-cn-beijing.aliyuncs.com/video/lesson_test/51_1418035940540.mp4"]];
    if (self) {
        self.view.frame = frame;
        self.view.backgroundColor = [UIColor blackColor];
        self.enableAutorotate = YES;
        self.shouldAutoplay = YES;
        
        [self setControlStyle:MPMovieControlStyleNone];
        
        _movieFullscreen = NO;
        
        movieBackgroundView = [[UIView alloc] init];
        movieBackgroundView.alpha = 0.f;
        [movieBackgroundView setBackgroundColor:[UIColor blackColor]];
        
        __block ALMoviePlayerController *weakSelf = self;
        
        CMAccelerometerHandler handler = ^(CMAccelerometerData *data, NSError *error) {
            //NSLog(@"x:= %f y:= %f z:= %f", data.acceleration.x, data.acceleration.y, data.acceleration.z);
            // Get the current device angle
            float xx = -data.acceleration.x;
            float yy = data.acceleration.y;
            float angle = atan2(yy, xx);
            
            UIInterfaceOrientation orientation = UIInterfaceOrientationPortrait;
            // Read my blog for more details on the angles. It should be obvious that you
            // could fire a custom shouldAutorotateToInterfaceOrientation-event here.
            if (angle >= -2.25 && angle <= -0.25) {
                orientation = UIInterfaceOrientationPortrait;
            } else if (angle >= -1.75 && angle <= 0.75) {
                orientation = UIInterfaceOrientationLandscapeRight;
            } else if (angle >= 0.75 && angle <= 2.25) {
                orientation = UIInterfaceOrientationPortraitUpsideDown;
            } else if (angle <= -2.25 || angle >= 2.25) {
                orientation = UIInterfaceOrientationLandscapeLeft;
            }
            [weakSelf deviceOrientationChange:orientation];
        };
        self.orientationHandler = handler;
        
        _motionManager = [[CMMotionManager alloc] init];
        _motionManager.accelerometerUpdateInterval = 1/60.0;
        
        
        ALMoviePlayerControls *movieControls = [[ALMoviePlayerControls alloc]
                                                initWithMoviePlayer:self
                                                style:ALMoviePlayerControlsStyleDefault];
        //[movieControls setAdjustsFullscreenImage:NO];
        [movieControls setBarColor:[Shared bbWhite]];
        [movieControls setTimeRemainingDecrements:YES];
        //[movieControls setFadeDelay:2.0];
        [movieControls setBarHeight:30];
        //[movieControls setSeekRate:2.f];
        movieControls.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        self.controls = movieControls;
        [self.view addSubview:movieControls];
        [movieControls release];
        
    }
    return self;

}

- (id)initWithFrame:(CGRect)frame urlStr: (NSString *)url {
    self = [super initWithContentURL:[NSURL URLWithString:@"http://img-children-sketchbook-com.oss-cn-beijing.aliyuncs.com/video/lesson_test/51_1418035940540.mp4"]];
    if (self) {
        self.view.frame = frame;
        self.view.backgroundColor = [UIColor blackColor];
        self.enableAutorotate = YES;
        self.shouldAutoplay = YES;

        [self setControlStyle:MPMovieControlStyleNone];
        
        _movieFullscreen = NO;
        
        movieBackgroundView = [[UIView alloc] init];
        movieBackgroundView.alpha = 0.f;
        [movieBackgroundView setBackgroundColor:[UIColor blackColor]];
        
        __block ALMoviePlayerController *weakSelf = self;
        
        CMAccelerometerHandler handler = ^(CMAccelerometerData *data, NSError *error) {
            //NSLog(@"x:= %f y:= %f z:= %f", data.acceleration.x, data.acceleration.y, data.acceleration.z);
            // Get the current device angle
            float xx = -data.acceleration.x;
            float yy = data.acceleration.y;
            float angle = atan2(yy, xx);
            
            UIInterfaceOrientation orientation = UIInterfaceOrientationPortrait;
            // Read my blog for more details on the angles. It should be obvious that you
            // could fire a custom shouldAutorotateToInterfaceOrientation-event here.
            if (angle >= -2.25 && angle <= -0.25) {
                orientation = UIInterfaceOrientationPortrait;
            } else if (angle >= -1.75 && angle <= 0.75) {
                orientation = UIInterfaceOrientationLandscapeRight;
            } else if (angle >= 0.75 && angle <= 2.25) {
                orientation = UIInterfaceOrientationPortraitUpsideDown;
            } else if (angle <= -2.25 || angle >= 2.25) {
                orientation = UIInterfaceOrientationLandscapeLeft;
            }
            [weakSelf deviceOrientationChange:orientation];
        };
        self.orientationHandler = handler;
        
        _motionManager = [[CMMotionManager alloc] init];
        _motionManager.accelerometerUpdateInterval = 1/60.0;
        
        
        ALMoviePlayerControls *movieControls = [[ALMoviePlayerControls alloc]
                                                initWithMoviePlayer:self
                                                style:ALMoviePlayerControlsStyleDefault];
        //[movieControls setAdjustsFullscreenImage:NO];
        [movieControls setBarColor:[Shared bbWhite]];
        [movieControls setTimeRemainingDecrements:YES];
        //[movieControls setFadeDelay:2.0];
        [movieControls setBarHeight:30];
        //[movieControls setSeekRate:2.f];
        movieControls.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        self.controls = movieControls;
        [self.view addSubview:movieControls];
        [movieControls release];

    }
    return self;
}


# pragma mark - Getters
- (BOOL)isFullscreen {
    return _movieFullscreen;
}

- (CGFloat)statusBarHeightInOrientation:(UIInterfaceOrientation)orientation {
    if ([UIDevice iOSVersion] >= 7.0)
        return 0.f;
    else if ([UIApplication sharedApplication].statusBarHidden)
        return 0.f;
    return 20.f;
}


# pragma mark - Setters
- (void)setContentURL:(NSURL *)contentURL {
    if (_controls) {
        [super setContentURL:contentURL];
        [[NSNotificationCenter defaultCenter] postNotificationName:ALMoviePlayerContentURLDidChangeNotification object:nil];
        [self play];
    }
}

- (void)setFrame:(CGRect)frame {
    [self.view setFrame:frame];
    [self.controls setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
}

- (void)setFullscreen:(BOOL)fullscreen animated:(BOOL)animated {
    _movieFullscreen = fullscreen;
    if (fullscreen) {
        [[NSNotificationCenter defaultCenter] postNotificationName:MPMoviePlayerWillEnterFullscreenNotification object:nil];
        
        UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
        if (!keyWindow) {
            keyWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
        }
        if (CGRectEqualToRect(movieBackgroundView.frame, CGRectZero)) {
            [movieBackgroundView setFrame:keyWindow.bounds];
        }
        [keyWindow addSubview:movieBackgroundView];
        
        [UIView animateWithDuration:animated? fullscreenAnimationDuration: 0.0
                              delay:0.0
                            options:UIViewAnimationOptionCurveLinear
                         animations:^{
                             movieBackgroundView.alpha = 1.f;
                         } completion:^(BOOL finished) {
                             [[UIApplication sharedApplication] setStatusBarHidden:YES];

                             self.view.alpha = 0.f;
                             [movieBackgroundView addSubview:self.view];
                             [self rotateMoviePlayerTo:self.orientation animated:NO completion:^{
                                 [UIView animateWithDuration:animated ? fullscreenAnimationDuration : 0.0 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
                                     self.view.alpha = 1.f;
                                 } completion:^(BOOL finished) {
                                     [[NSNotificationCenter defaultCenter] postNotificationName:MPMoviePlayerDidEnterFullscreenNotification object:nil];
                                 }];
                             }];
                         }];
        
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:MPMoviePlayerWillExitFullscreenNotification object:nil];
        
        [UIView animateWithDuration:animated? fullscreenAnimationDuration: 0.0
                              delay:0.0
                            options:UIViewAnimationOptionCurveLinear
                         animations:^{
                             self.view.alpha = 0.f;
                         } completion:^(BOOL finished) {
                             [[UIApplication sharedApplication] setStatusBarHidden:NO];

                             if ([self.delegate respondsToSelector:@selector(moviePlayerWillMoveFromWindow)]) {
                                 [self.delegate moviePlayerWillMoveFromWindow];
                             }
                             self.view.alpha = 1.f;
                             [UIView animateWithDuration:animated ? fullscreenAnimationDuration : 0.0 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
                                 movieBackgroundView.alpha = 0.f;
                             } completion:^(BOOL finished) {
                                 [movieBackgroundView removeFromSuperview];
                                 [[NSNotificationCenter defaultCenter] postNotificationName:MPMoviePlayerDidExitFullscreenNotification object:nil];
                             }];
                         }];
    }
    
    if (fullscreen) {
        [_motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue currentQueue]
                                             withHandler:self.orientationHandler];
    } else {
        [_motionManager stopAccelerometerUpdates];
    }
}


#pragma mark - Notifications
- (void)videoLoadStateChanged:(NSNotification *)note {
    switch (self.loadState) {
        case MPMovieLoadStatePlayable:
            [NSObject cancelPreviousPerformRequestsWithTarget:self
                                                     selector:@selector(movieTimedOut)
                                                       object:nil];
            [[NSNotificationCenter defaultCenter] removeObserver:self
                                                            name:MPMoviePlayerLoadStateDidChangeNotification
                                                          object:nil];
        default:
            break;
    }
}

- (void)videoPlayStateChanged:(NSNotification *)note {
    if (self.playbackState == MPMoviePlaybackStatePaused
        && self.endPlaybackTime > 0
        && self.currentPlaybackTime == self.endPlaybackTime) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(moviePreviewEnded)]) {
            [self.delegate moviePreviewEnded];
        }
    }
}

- (void)deviceOrientationChange:(UIInterfaceOrientation)orientation {
    if (self.enableAutorotate && orientation != self.orientation) {
        [self rotateMoviePlayerTo:orientation animated:YES completion:nil];
    }
}

- (void)rotateMoviePlayerTo:(UIInterfaceOrientation)orientation
                   animated:(BOOL)animated
                 completion:(void (^)(void))completion {
    
    if (!self.isFullscreen) {
        return;
    }
    
    self.orientation = orientation;
    
    CGFloat angle;
    CGSize windowSize = [UIApplication sizeInOrientation:orientation];
    CGRect backgroundFrame;
    CGRect movieFrame;
    switch (orientation) {
        case UIInterfaceOrientationPortraitUpsideDown:
            angle = M_PI;
            backgroundFrame = CGRectMake(-movieBackgroundPadding, -movieBackgroundPadding, windowSize.width + movieBackgroundPadding*2, windowSize.height + movieBackgroundPadding*2);
            movieFrame = CGRectMake(movieBackgroundPadding, movieBackgroundPadding, backgroundFrame.size.width - movieBackgroundPadding*2, backgroundFrame.size.height - movieBackgroundPadding*2);
            break;
        case UIInterfaceOrientationLandscapeLeft:
            angle = - M_PI_2;
            backgroundFrame = CGRectMake([self statusBarHeightInOrientation:orientation] - movieBackgroundPadding, -movieBackgroundPadding, windowSize.height + movieBackgroundPadding*2, windowSize.width + movieBackgroundPadding*2);
            movieFrame = CGRectMake(movieBackgroundPadding, movieBackgroundPadding, backgroundFrame.size.height - movieBackgroundPadding*2, backgroundFrame.size.width - movieBackgroundPadding*2);
            break;
        case UIInterfaceOrientationLandscapeRight:
            angle = M_PI_2;
            backgroundFrame = CGRectMake(-movieBackgroundPadding, -movieBackgroundPadding, windowSize.height + movieBackgroundPadding*2, windowSize.width + movieBackgroundPadding*2);
            movieFrame = CGRectMake(movieBackgroundPadding, movieBackgroundPadding, backgroundFrame.size.height - movieBackgroundPadding*2, backgroundFrame.size.width - movieBackgroundPadding*2);
            break;
        case UIInterfaceOrientationPortrait:
        default:
            angle = 0.f;
            backgroundFrame = CGRectMake(-movieBackgroundPadding, [self statusBarHeightInOrientation:orientation] - movieBackgroundPadding, windowSize.width + movieBackgroundPadding*2, windowSize.height + movieBackgroundPadding*2);
            movieFrame = CGRectMake(movieBackgroundPadding, movieBackgroundPadding, backgroundFrame.size.width - movieBackgroundPadding*2, backgroundFrame.size.height - movieBackgroundPadding*2);
            break;
    }
    
    if (animated) {
        [UIView animateWithDuration:0.3
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             movieBackgroundView.transform = CGAffineTransformMakeRotation(angle);
                             movieBackgroundView.frame = backgroundFrame;
                             [self setFrame:movieFrame];
                         } completion:^(BOOL finished) {
                             if (completion)
                                 completion();
                         }];
    } else {
        movieBackgroundView.transform = CGAffineTransformMakeRotation(angle);
        movieBackgroundView.frame = backgroundFrame;
        [self setFrame:movieFrame];
        if (completion)
            completion();
    }
}


# pragma mark - Internal Methods
- (void)destroy {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(movieTimedOut) object:nil];
}

- (void)play {
    [super play];
    
    //remote file
    if (![self.contentURL.scheme isEqualToString:@"file"] && self.loadState == MPMovieLoadStateUnknown) {
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:MPMoviePlayerLoadStateDidChangeNotification
                                                      object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoLoadStateChanged:)
                                                     name:MPMoviePlayerLoadStateDidChangeNotification
                                                   object:nil];
        
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(movieTimedOut) object:nil];
        [self performSelector:@selector(movieTimedOut) withObject:nil afterDelay:20.f];
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerPlaybackStateDidChangeNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoPlayStateChanged:)
                                                 name:MPMoviePlayerPlaybackStateDidChangeNotification
                                               object:nil];
}

- (void)movieTimedOut {
    if (!(self.loadState & MPMovieLoadStatePlayable) || !(self.loadState & MPMovieLoadStatePlaythroughOK)) {
        if ([self.delegate respondsToSelector:@selector(movieTimedOut)]) {
            [self.delegate performSelector:@selector(movieTimedOut)];
        }
    }
}


@end
