//
//  SimpleSegment.m
//  baby
//
//  Created by zhang da on 14-3-17.
//  Copyright (c) 2014年 zhang da. All rights reserved.
//

#import "SimpleSegment.h"

#define BASIC_TAG 88888

@implementation SimpleSegment

- (void)dealloc {
    [buttons release];
    buttons = nil;
    
    self.selectedBackgoundColor = nil;
    self.normalBackgroundColor = nil;
    self.selectedTextColor = nil;
    self.normalTextColor = nil;
    self.borderColor = nil;
    
    self.delegate = nil;
    
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame titles:(NSArray *)titles {
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.masksToBounds = YES;
        int count = titles.count;
        buttons = [[NSMutableArray alloc] init];
        _selectedIndex = 0;

        float btnWidth = (frame.size.width*1.0)/count;
        for (int i = 0; i < count; i ++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(btnWidth*i, 0, btnWidth, frame.size.height);
            btn.tag = BASIC_TAG + i;
            
            [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            [btn setTitle:[titles objectAtIndex:i] forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:MIN(14, frame.size.height - 4)];
            
            [btn addTarget:self action:@selector(segmentSelected:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
            [buttons addObject:btn];
        }
        
        [self updateLayout];
    }
    return self;
}

- (void)setSelectedIndex:(int)selectedIndex {
    if (_selectedIndex != selectedIndex) {
        _selectedIndex = selectedIndex;
        
        for (int i = 0; i < buttons.count; i ++) {
            UIButton *btn = [buttons objectAtIndex:i];
            if (i == selectedIndex) {
                //highlighted
                btn.backgroundColor = self.selectedBackgoundColor;
                [btn setTitleColor:self.selectedTextColor forState:UIControlStateNormal];
            } else {
                btn.backgroundColor = self.normalBackgroundColor;
                [btn setTitleColor:self.normalTextColor forState:UIControlStateNormal];
            }
        }
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(segmentSelected:)]) {
            [self.delegate segmentSelected:selectedIndex];
        }
    }
}

- (void)updateLayout {
    for (UIButton *btn in buttons) {
        btn.layer.borderColor = self.borderColor.CGColor;
        btn.layer.borderWidth = 1;
    }
    for (int i = 0; i < buttons.count; i ++) {
        UIButton *btn = [buttons objectAtIndex:i];
        if (i == _selectedIndex) {
            //highlighted
            btn.backgroundColor = self.selectedBackgoundColor;
            [btn setTitleColor:self.selectedTextColor forState:UIControlStateNormal];
        } else {
            btn.backgroundColor = self.normalBackgroundColor;
            [btn setTitleColor:self.normalTextColor forState:UIControlStateNormal];
        }
    }

}

- (UIButton *)segmentAtIndex:(int)index {
    if ([buttons count] > index) {
        return [buttons objectAtIndex:index];
    }
    return nil;
}

- (void)segmentSelected:(UIButton *)btn {
    int index = btn.tag - BASIC_TAG;
    self.selectedIndex = index;
}

@end
