//
//  ALMoviePlayerControls.m
//  ALMoviePlayerController
//
//  Created by Anthony Lobianco on 10/8/13.
//  Copyright (c) 2013 Anthony Lobianco. All rights reserved.
//

#import "ALMoviePlayerControls.h"
#import "ALMoviePlayerController.h"
#import "ALButton.h"
#import <tgmath.h>
#import <QuartzCore/QuartzCore.h>

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


static const CGFloat activityIndicatorSize = 40.f;
static const CGFloat iPhoneScreenPortraitWidth = 320.f;


@interface ALMoviePlayerControls () <ALButtonDelegate>

@property (nonatomic, assign) ALMoviePlayerControlsState state;
@property (nonatomic, assign) BOOL isShowing;
@property (nonatomic, retain) NSTimer *durationTimer;

@end

@implementation ALMoviePlayerControls {
    
    UISlider *_durationSlider;

    UIView *_topBar;
    UIView *_bottomBar;
    
    UILabel *_timeElapsedLabel;
    UILabel *_timeRemainingLabel;
    
    ALButton *_fullscreenButton;
    ALButton *_rotateButton;
    ALButton *_playPauseButton;
    
    UIView *_activityBackgroundView;
    UIActivityIndicatorView *_activityIndicator;

}


# pragma mark - Construct/Destruct
- (id)initWithMoviePlayer:(ALMoviePlayerController *)moviePlayer
                    style:(ALMoviePlayerControlsStyle)style {
    
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        _moviePlayer = moviePlayer;
        _style = style;
        _showing = NO;
        _fadeDelay = 5.0;
        _timeRemainingDecrements = NO;
        _barColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        
        //in fullscreen mode, move controls away from top status bar and bottom screen bezel. I think the iOS7 control center gestures interfere with the uibutton touch events. this will alleviate that a little (correct me if I'm wrong and/or adjust if necessary).
        _barHeight = [UIDevice iOSVersion] >= 7.0 ? 70.f : 50.f;
        
        _seekRate = 3.f;
        _state = ALMoviePlayerControlsStateIdle;
        
        //top bar
        _topBar = [[UIView alloc] init];
        _topBar.backgroundColor = _barColor;
        _topBar.alpha = 0.f;
        [self addSubview:_topBar];
        
        //bottom bar
        _bottomBar = [[UIView alloc] init];
        _bottomBar.backgroundColor = _barColor;
        _bottomBar.alpha = 0.f;
        [self addSubview:_bottomBar];
        
        _durationSlider = [[UISlider alloc] init];
        _durationSlider.value = 0.f;
        _durationSlider.continuous = YES;
        [_durationSlider setThumbImage:[UIImage imageNamed:@"slider_bar"] forState:UIControlStateNormal];
        [_durationSlider setThumbImage:[UIImage imageNamed:@"slider_bar"] forState:UIControlStateHighlighted];
        [_durationSlider setMinimumTrackImage:[UIImage imageNamed:@"slider_left"] forState:UIControlStateNormal];
        [_durationSlider setMaximumTrackImage:[UIImage imageNamed:@"slider_right"] forState:UIControlStateNormal];
        [_durationSlider addTarget:self action:@selector(durationSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
        [_durationSlider addTarget:self action:@selector(durationSliderTouchBegan:) forControlEvents:UIControlEventTouchDown];
        [_durationSlider addTarget:self action:@selector(durationSliderTouchEnded:) forControlEvents:UIControlEventTouchUpInside];
        [_durationSlider addTarget:self action:@selector(durationSliderTouchEnded:) forControlEvents:UIControlEventTouchUpOutside];
    
        _timeElapsedLabel = [[UILabel alloc] init];
        _timeElapsedLabel.backgroundColor = [UIColor clearColor];
        _timeElapsedLabel.font = [UIFont systemFontOfSize:11.f];
        _timeElapsedLabel.textColor = [UIColor colorWithRed:234/255.0 green:166/255.0 blue:31/255.0 alpha:1];
        _timeElapsedLabel.textAlignment = NSTextAlignmentRight;
        _timeElapsedLabel.text = @"0:00";
        
        _timeRemainingLabel = [[UILabel alloc] init];
        _timeRemainingLabel.backgroundColor = [UIColor clearColor];
        _timeRemainingLabel.font = [UIFont systemFontOfSize:11.f];
        _timeRemainingLabel.textColor = [UIColor colorWithRed:234/255.0 green:166/255.0 blue:31/255.0 alpha:1];
        _timeRemainingLabel.textAlignment = NSTextAlignmentLeft;
        _timeRemainingLabel.text = @"0:00";

        _rotateButton = [[ALButton alloc] init];
        [_rotateButton setImage:[UIImage imageNamed:@"movieFullscreen.png"] forState:UIControlStateNormal];
        [_rotateButton setImage:[UIImage imageNamed:@"movieEndFullscreen.png"] forState:UIControlStateSelected];
        _rotateButton.delegate = self;
        [_rotateButton addTarget:self action:@selector(rotatePressed:) forControlEvents:UIControlEventTouchUpInside];
        
        _fullscreenButton = [[ALButton alloc] init];
        [_fullscreenButton setImage:[UIImage imageNamed:@"movieFullscreen.png"] forState:UIControlStateNormal];
        [_fullscreenButton setImage:[UIImage imageNamed:@"movieEndFullscreen.png"] forState:UIControlStateSelected];
        _fullscreenButton.delegate = self;
        [_fullscreenButton addTarget:self action:@selector(fullscreenPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        _playPauseButton = [[ALButton alloc] init];
        [_playPauseButton setImage:[UIImage imageNamed:@"moviePause.png"] forState:UIControlStateNormal];
        [_playPauseButton setImage:[UIImage imageNamed:@"moviePlay.png"] forState:UIControlStateSelected];
        _playPauseButton.delegate = self;
        [_playPauseButton addTarget:self action:@selector(playPausePressed:) forControlEvents:UIControlEventTouchUpInside];
        
        _activityBackgroundView = [[UIView alloc] init];
        [_activityBackgroundView setBackgroundColor:[UIColor blackColor]];
        _activityBackgroundView.alpha = 0.f;
        
        _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        _activityIndicator.alpha = 0.f;
        _activityIndicator.hidesWhenStopped = YES;
        
        [self setup];
        [self addNotifications];
    }
    
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideControls:) object:nil];
    
    [self stopDurationTimer];
    self.durationTimer = nil;
    
    [self nilDelegates];
    
    self.moviePlayer = nil;
    self.barColor = nil;

    [_activityBackgroundView release];
    [_activityIndicator release];
    [_topBar release];
    [_bottomBar release];
    [_durationSlider release];
    [_timeElapsedLabel release];
    [_timeRemainingLabel release];
    [_rotateButton release];
    [_fullscreenButton release];
    [_playPauseButton release];
    
    [super dealloc];
}


# pragma mark - Construct/Destruct Helpers
- (void)resetViews {
    [self stopDurationTimer];
    [self nilDelegates];
    
    [_topBar removeFromSuperview];
    [_bottomBar removeFromSuperview];
}

- (void)setup {
    
    if (self.style == ALMoviePlayerControlsStyleNone)
        return;
    
    if (_style == ALMoviePlayerControlsStyleFullscreen
        || (_style == ALMoviePlayerControlsStyleDefault && _moviePlayer.isFullscreen)) {
        [_topBar addSubview:_durationSlider];
        [_topBar addSubview:_timeElapsedLabel];
        [_topBar addSubview:_timeRemainingLabel];
        [_topBar addSubview:_fullscreenButton];
        [_topBar addSubview:_rotateButton];
    } else if (_style == ALMoviePlayerControlsStyleEmbedded
               || (_style == ALMoviePlayerControlsStyleDefault && !_moviePlayer.isFullscreen)) {
        [_bottomBar addSubview:_durationSlider];
        [_bottomBar addSubview:_timeElapsedLabel];
        [_bottomBar addSubview:_timeRemainingLabel];
        [_bottomBar addSubview:_fullscreenButton];
    }
    
    [_bottomBar addSubview:_playPauseButton];

}

- (void)nilDelegates {
    _playPauseButton.delegate = nil;
    _fullscreenButton.delegate = nil;
    _rotateButton.delegate = nil;
}


# pragma mark - Setters
- (void)setStyle:(ALMoviePlayerControlsStyle)style {
    if (_style != style) {
        BOOL flag = _style == ALMoviePlayerControlsStyleDefault;
        [self hideControls:^{
            
            [self resetViews];
            _style = style;
            [self setup];
            
            if (_style != ALMoviePlayerControlsStyleNone) {
                double delayInSeconds = 0.2;
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    [self setDurationSliderMaxMinValues];
                    [self monitorMoviePlayback]; //resume values
                    [self startDurationTimer];
                    [self showControls:^{
                        if (flag) {
                            //put style back to default
                            _style = ALMoviePlayerControlsStyleDefault;
                        }
                    }];
                    
                });
            } else {
                if (flag) {
                    //put style back to default
                    _style = ALMoviePlayerControlsStyleDefault;
                }
            }
        }];
    }
}

- (void)setState:(ALMoviePlayerControlsState)state {
    if (_state != state) {
        _state = state;
        
        switch (state) {
            case ALMoviePlayerControlsStateLoading:
                [self showLoadingIndicators];
                break;
            case ALMoviePlayerControlsStateReady:
                [self hideLoadingIndicators];
                break;
            case ALMoviePlayerControlsStateIdle:
            default:
                break;
        }
    }
}

- (void)setBarColor:(UIColor *)barColor {
    if (_barColor != barColor) {
        [_barColor release];
        _barColor = [barColor retain];
        
        _topBar.backgroundColor = barColor;
        _bottomBar.backgroundColor = barColor;
    }
}


# pragma mark - UIControl/Touch Events
- (void)durationSliderTouchBegan:(UISlider *)slider {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideControls:) object:nil];
    [self.moviePlayer pause];
}

- (void)durationSliderTouchEnded:(UISlider *)slider {
    [self.moviePlayer setCurrentPlaybackTime:floor(slider.value)];
    [self.moviePlayer play];
    [self performSelector:@selector(hideControls:) withObject:nil afterDelay:self.fadeDelay];
}

- (void)durationSliderValueChanged:(UISlider *)slider {
    double currentTime = floor(slider.value);
    double totalTime = floor(self.moviePlayer.duration);
    [self setTimeLabelValues:currentTime totalTime:totalTime];
}

- (void)buttonTouchedDown:(UIButton *)button {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideControls:) object:nil];
}

- (void)buttonTouchedUpOutside:(UIButton *)button {
    [self performSelector:@selector(hideControls:) withObject:nil afterDelay:self.fadeDelay];
}

- (void)buttonTouchCancelled:(UIButton *)button {
    [self performSelector:@selector(hideControls:) withObject:nil afterDelay:self.fadeDelay];
}

- (void)playPausePressed:(UIButton *)button {
    self.moviePlayer.playbackState == MPMoviePlaybackStatePlaying ? [self.moviePlayer pause] : [self.moviePlayer play];
    [self performSelector:@selector(hideControls:) withObject:nil afterDelay:self.fadeDelay];
}

- (void)fullscreenPressed:(UIButton *)button {
    if (self.style == ALMoviePlayerControlsStyleDefault) {
        self.style = self.moviePlayer.isFullscreen ? ALMoviePlayerControlsStyleEmbedded : ALMoviePlayerControlsStyleFullscreen;
    }
    if (self.moviePlayer.currentPlaybackRate != 1.f) {
        self.moviePlayer.currentPlaybackRate = 1.f;
    }
    [self.moviePlayer setFullscreen:!self.moviePlayer.isFullscreen animated:YES];
    [self performSelector:@selector(hideControls:) withObject:nil afterDelay:self.fadeDelay];
}

- (void)scalePressed:(UIButton *)button {
    //[self.moviePlayer setScalingMode:button.selected ? MPMovieScalingModeAspectFill : MPMovieScalingModeAspectFit];
}

- (void)rotatePressed:(UIButton *)button {
    button.selected = !button.selected;
    
    self.moviePlayer.enableAutorotate = NO;
    
    UIInterfaceOrientation origin = self.moviePlayer.orientation;
    UIInterfaceOrientation desire = UIInterfaceOrientationPortrait;
    switch (origin) {
        case UIInterfaceOrientationPortrait:
        case UIInterfaceOrientationPortraitUpsideDown: desire = UIInterfaceOrientationLandscapeRight; break;
        case UIInterfaceOrientationLandscapeLeft:
        case UIInterfaceOrientationLandscapeRight: desire = UIInterfaceOrientationPortrait; break;
        default: break;
    }
    [self.moviePlayer rotateMoviePlayerTo:desire animated:NO completion:nil];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if (self.style == ALMoviePlayerControlsStyleNone)
        return;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (self.style == ALMoviePlayerControlsStyleNone)
        return;
    self.isShowing? [self hideControls:nil]: [self showControls:nil];
}


# pragma mark - Notifications
- (void)addNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlaybackStateDidChange:) name:MPMoviePlayerPlaybackStateDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(movieFinished:) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(movieContentURLDidChange:) name:ALMoviePlayerContentURLDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(movieDurationAvailable:) name:MPMovieDurationAvailableNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(movieLoadStateDidChange:) name:MPMoviePlayerLoadStateDidChangeNotification object:nil];
}

- (void)movieFinished:(NSNotification *)note {
    _playPauseButton.selected = YES;
    [self.durationTimer invalidate];
    [self.moviePlayer setCurrentPlaybackTime:0.0];
    [self monitorMoviePlayback]; //reset values
    [self hideControls:nil];
    self.state = ALMoviePlayerControlsStateIdle;
}

- (void)movieLoadStateDidChange:(NSNotification *)note {
    switch (self.moviePlayer.loadState) {
        case MPMovieLoadStatePlayable:
        case MPMovieLoadStatePlaythroughOK:
            [self showControls:nil];
            self.state = ALMoviePlayerControlsStateReady;
            break;
        case MPMovieLoadStateStalled:
        case MPMovieLoadStateUnknown:
            break;
        default:
            break;
    }
}

- (void)moviePlaybackStateDidChange:(NSNotification *)note {
    switch (self.moviePlayer.playbackState) {
        case MPMoviePlaybackStatePlaying:
            _playPauseButton.selected = NO;
            [self startDurationTimer];
            
            //local file
            if ([self.moviePlayer.contentURL.scheme isEqualToString:@"file"]) {
                [self setDurationSliderMaxMinValues];
                [self showControls:nil];
            }
        case MPMoviePlaybackStateSeekingBackward:
        case MPMoviePlaybackStateSeekingForward:
            self.state = ALMoviePlayerControlsStateReady;
            break;
        case MPMoviePlaybackStateInterrupted:
            self.state = ALMoviePlayerControlsStateLoading;
            break;
        case MPMoviePlaybackStatePaused:
        case MPMoviePlaybackStateStopped:
            self.state = ALMoviePlayerControlsStateIdle;
            _playPauseButton.selected = YES;
            [self stopDurationTimer];
            break;
        default:
            break;
    }
    [_playPauseButton setSelected:_moviePlayer.playbackState != MPMoviePlaybackStatePlaying];
}

- (void)movieDurationAvailable:(NSNotification *)note {
    [self setDurationSliderMaxMinValues];
}

- (void)movieContentURLDidChange:(NSNotification *)note {
    [self hideControls:^{
        //don't show loading indicator for local files
        self.state = [self.moviePlayer.contentURL.scheme isEqualToString:@"file"] ? ALMoviePlayerControlsStateReady : ALMoviePlayerControlsStateLoading;
    }];
}


# pragma mark - Internal Methods
- (void)startDurationTimer {
    self.durationTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(monitorMoviePlayback) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.durationTimer forMode:NSDefaultRunLoopMode];
}

- (void)stopDurationTimer {
    [self.durationTimer invalidate];
}

- (void)showControls:(void(^)(void))completion {
    
    if (!self.isShowing) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideControls:) object:nil];
        
        if (self.style == ALMoviePlayerControlsStyleFullscreen
            || (self.style == ALMoviePlayerControlsStyleDefault && self.moviePlayer.isFullscreen)) {
            [_topBar setNeedsDisplay];
        }
        
        [_bottomBar setNeedsDisplay];
        
        [UIView animateWithDuration:0.3 delay:0.0 options:0 animations:^{
            if (self.style == ALMoviePlayerControlsStyleFullscreen
                || (self.style == ALMoviePlayerControlsStyleDefault && self.moviePlayer.isFullscreen)) {
                _topBar.alpha = 1.f;
            }
            _bottomBar.alpha = 1.f;
        } completion:^(BOOL finished) {
            _showing = YES;
            if (completion)
                completion();
            [self performSelector:@selector(hideControls:) withObject:nil afterDelay:self.fadeDelay];
        }];
    } else {
        if (completion)
            completion();
    }
}

- (void)hideControls:(void(^)(void))completion {
    if (self.isShowing) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideControls:) object:nil];
        [UIView animateWithDuration:0.3 delay:0.0 options:0 animations:^{
            if (self.style == ALMoviePlayerControlsStyleFullscreen
                || (self.style == ALMoviePlayerControlsStyleDefault && self.moviePlayer.isFullscreen)) {
                _topBar.alpha = 0.f;
            }
            _bottomBar.alpha = 0.f;
        } completion:^(BOOL finished) {
            _showing = NO;
            if (completion)
                completion();
        }];
    } else {
        if (completion)
            completion();
    }
}

- (void)showLoadingIndicators {
    [self addSubview:_activityBackgroundView];
    [self addSubview:_activityIndicator];
    [_activityIndicator startAnimating];
    
    [UIView animateWithDuration:0.2f animations:^{
        _activityBackgroundView.alpha = 1.f;
        _activityIndicator.alpha = 1.f;
    }];
}

- (void)hideLoadingIndicators {
    [UIView animateWithDuration:0.2f delay:0.0 options:0 animations:^{
        _activityBackgroundView.alpha = 0.0f;
        _activityIndicator.alpha = 0.f;
    } completion:^(BOOL finished) {
        [_activityBackgroundView removeFromSuperview];
        [_activityIndicator removeFromSuperview];
    }];
}

- (void)setDurationSliderMaxMinValues {
    CGFloat duration = self.moviePlayer.duration;
    _durationSlider.minimumValue = 0.f;
    _durationSlider.maximumValue = duration;
}

- (void)setTimeLabelValues:(double)currentTime totalTime:(double)totalTime {
    double minutesElapsed = floor(currentTime / 60.0);
    double secondsElapsed = fmod(currentTime, 60.0);
    _timeElapsedLabel.text = [NSString stringWithFormat:@"%.0f:%02.0f", minutesElapsed, secondsElapsed];
    
    double minutesRemaining;
    double secondsRemaining;
    if (self.timeRemainingDecrements) {
        minutesRemaining = floor((totalTime - currentTime) / 60.0);
        secondsRemaining = fmod((totalTime - currentTime), 60.0);
    } else {
        minutesRemaining = floor(totalTime / 60.0);
        secondsRemaining = floor(fmod(totalTime, 60.0));
    }
    _timeRemainingLabel.text = self.timeRemainingDecrements ? [NSString stringWithFormat:@"-%.0f:%02.0f", minutesRemaining, secondsRemaining] : [NSString stringWithFormat:@"%.0f:%02.0f", minutesRemaining, secondsRemaining];
}

- (void)monitorMoviePlayback {
    double currentTime = floor(self.moviePlayer.currentPlaybackTime);
    double totalTime = floor(self.moviePlayer.duration);
    [self setTimeLabelValues:currentTime totalTime:totalTime];
    _durationSlider.value = ceil(currentTime);
}

- (void)layoutSubviews {
    [super layoutSubviews];
            
    if (self.style == ALMoviePlayerControlsStyleNone)
        return;
    
    //common sizes
    CGFloat paddingFromBezel = self.frame.size.width <= iPhoneScreenPortraitWidth ? 10.f : 20.f;
    CGFloat paddingBetweenButtons = self.frame.size.width <= iPhoneScreenPortraitWidth ? 10.f : 30.f;
    //CGFloat paddingBetweenPlaybackButtons = self.frame.size.width <= iPhoneScreenPortraitWidth ? 20.f : 30.f;
    CGFloat paddingBetweenLabelsAndSlider = 10.f;
    CGFloat sliderHeight = 34.f; //default height
    CGFloat playWidth = 18.f;
    CGFloat playHeight = 22.f;
    CGFloat labelWidth = 35.f;
    
    if (self.style == ALMoviePlayerControlsStyleFullscreen
        || (self.style == ALMoviePlayerControlsStyleDefault && self.moviePlayer.isFullscreen)) {
        //top bar
        CGFloat fullscreenWidth = 34.f;
        CGFloat fullscreenHeight = self.barHeight;
        CGFloat scaleWidth = 28.f;
        CGFloat scaleHeight = 28.f;
        _topBar.frame = CGRectMake(0, 0, self.frame.size.width, self.barHeight);
        [self addSubview:_topBar];
        
        _fullscreenButton.frame = CGRectMake(paddingFromBezel, self.barHeight/2 - fullscreenHeight/2, fullscreenWidth, fullscreenHeight);
        _timeElapsedLabel.frame = CGRectMake(_fullscreenButton.frame.origin.x + _fullscreenButton.frame.size.width + paddingBetweenButtons, 0, labelWidth, self.barHeight);
        _rotateButton.frame = CGRectMake(_topBar.frame.size.width - paddingFromBezel - scaleWidth, self.barHeight/2 - scaleHeight/2, scaleWidth, scaleHeight);
        _timeRemainingLabel.frame = CGRectMake(_rotateButton.frame.origin.x - paddingBetweenButtons - labelWidth, 0, labelWidth, self.barHeight);
        
        //bottom bar
        _bottomBar.frame = CGRectMake(0, self.frame.size.height - self.barHeight, self.frame.size.width, self.barHeight);
        [self addSubview:_bottomBar];
        _playPauseButton.frame = CGRectMake(_bottomBar.frame.size.width/2 - playWidth/2,
                                            self.barHeight/2 - playHeight/2,
                                            playWidth,
                                            playHeight);
    } else if (self.style == ALMoviePlayerControlsStyleEmbedded
            || (self.style == ALMoviePlayerControlsStyleDefault && !self.moviePlayer.isFullscreen)) {
        
        _bottomBar.frame = CGRectMake(0, self.frame.size.height - self.barHeight, self.frame.size.width, self.barHeight);
        [self addSubview:_bottomBar];
        
        //left side of bottom bar
        _playPauseButton.frame = CGRectMake(paddingFromBezel, self.barHeight/2 - playHeight/2, playWidth, playHeight);
        _timeElapsedLabel.frame = CGRectMake(_playPauseButton.frame.origin.x + _playPauseButton.frame.size.width + paddingBetweenButtons, 0, labelWidth, self.barHeight);
        
        //right side of bottom bar
        CGFloat fullscreenWidth = 28.f;
        CGFloat fullscreenHeight = fullscreenWidth;
        _fullscreenButton.frame = CGRectMake(_bottomBar.frame.size.width - paddingFromBezel - fullscreenWidth,
                                             self.barHeight/2 - fullscreenHeight/2,
                                             fullscreenWidth,
                                             fullscreenHeight);
        _timeRemainingLabel.frame = CGRectMake(_fullscreenButton.frame.origin.x - paddingBetweenButtons - labelWidth, 0, labelWidth, self.barHeight);
    }
    
    //duration slider
    CGFloat timeRemainingX = _timeRemainingLabel.frame.origin.x;
    CGFloat timeElapsedX = _timeElapsedLabel.frame.origin.x;
    CGFloat sliderWidth = ((timeRemainingX - paddingBetweenLabelsAndSlider) - (timeElapsedX + _timeElapsedLabel.frame.size.width + paddingBetweenLabelsAndSlider));
    _durationSlider.frame = CGRectMake(timeElapsedX + _timeElapsedLabel.frame.size.width + paddingBetweenLabelsAndSlider, self.barHeight/2 - sliderHeight/2, sliderWidth, sliderHeight);
    
    if (self.state == ALMoviePlayerControlsStateLoading) {
        [_activityIndicator setFrame:CGRectMake((self.frame.size.width / 2) - (activityIndicatorSize / 2), (self.frame.size.height / 2) - (activityIndicatorSize / 2), activityIndicatorSize, activityIndicatorSize)];
        [_activityBackgroundView setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    }
}


@end
