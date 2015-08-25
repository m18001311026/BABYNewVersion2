//
//  RotateImageMenuItemButton.m
//  baby
//
//  Created by zhang da on 14-3-9.
//  Copyright (c) 2014年 zhang da. All rights reserved.
//

#import "RotateImageMenuItemButton.h"

@implementation RotateImageMenuItemButton

- (void)dealloc {
    self.selectedBlock = nil;

    [super dealloc];
}

- (id)initWithTitle:(NSString*)title andIcon:(UIImage*)icon andSelectedBlock:(RotateMenuItemSelectedBlock)block {
    self = [super init];
    if (self) {
        iconView_ = [[UIImageView alloc] init];
        iconView_.image = icon;
        [self addSubview:iconView_];
        [icon release];
        
        titleLabel_ = [[UILabel alloc] init];
        titleLabel_.textAlignment = NSTextAlignmentCenter;
        titleLabel_.backgroundColor = [UIColor clearColor];
        titleLabel_.textColor = [UIColor whiteColor];
        titleLabel_.text = title;
        [self addSubview:titleLabel_];
        [titleLabel_ release];
        
        self.selectedBlock = block;
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    
    iconView_.frame = CGRectMake(0, 0, CHTumblrMenuViewImageHeight, CHTumblrMenuViewImageHeight);
    titleLabel_.frame = CGRectMake(0, CHTumblrMenuViewImageHeight, CHTumblrMenuViewImageHeight, CHTumblrMenuViewTitleHeight);
}

@end
