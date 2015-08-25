//
//  ScanView.m
//  baby
//
//  Created by zhang da on 14-5-3.
//  Copyright (c) 2014年 zhang da. All rights reserved.
//

#import "ScanView.h"

@interface ScanView ()

@property (nonatomic, assign) bool isAnimating;

@end



@implementation ScanView {
    UIView *line;
}

- (void)dealloc {
    [line release];
    
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 2)];
        line.backgroundColor = [UIColor greenColor];
    }
    return self;
}

- (void)startAnimation {
    self.isAnimating = YES;
    
    [self addSubview:line];
    [UIView animateWithDuration:2
                     animations:^{
                         line.center = CGPointMake(self.frame.size.width/2, self.frame.size.height);
                         //NSLog(@"%@", NSStringFromCGRect(line.frame));
                     }
                     completion:^(BOOL finished) {
                         if (self.isAnimating) {
                             line.center = CGPointMake(self.frame.size.width/2, 0);
                             [NSObject cancelPreviousPerformRequestsWithTarget:self
                                                                      selector:@selector(startAnimation)
                                                                        object:nil];
                             [self performSelector:@selector(startAnimation)
                                        withObject:nil
                                        afterDelay:.1
                                           inModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
                         }
                     }];

    
}

- (void)stopAnimation {
    self.isAnimating = NO;

    [line removeFromSuperview];
    [NSObject cancelPreviousPerformRequestsWithTarget:self
                                             selector:@selector(startAnimation)
                                               object:nil];
}

@end
