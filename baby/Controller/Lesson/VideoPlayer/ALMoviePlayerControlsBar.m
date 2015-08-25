//
//  ALMoviePlayerControlsBar.m
//  baby
//
//  Created by zhang da on 14-5-9.
//  Copyright (c) 2014年 zhang da. All rights reserved.
//

#import "ALMoviePlayerControlsBar.h"

@implementation ALMoviePlayerControlsBar

- (void)dealloc {
    self.color = nil;
    [super dealloc];
}

- (id)init {
    if ( self = [super init] ) {
        self.opaque = NO;
    }
    return self;
}

- (void)setColor:(UIColor *)color {
    if (_color != color) {
        [_color release];
        _color = [color retain];
        [self setNeedsDisplay];
    }
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [_color CGColor]);
    CGContextFillRect(context, rect);
}

@end
