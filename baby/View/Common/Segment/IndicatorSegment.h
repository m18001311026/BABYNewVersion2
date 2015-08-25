//
//  IndicatorSegment.h
//  baby
//
//  Created by zhang da on 14-3-17.
//  Copyright (c) 2014年 zhang da. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol IndicatorSegmentDelegate <NSObject>

@optional
- (void)segmentSelected:(int)index;

@end


@interface IndicatorSegment : UIView {
    NSMutableArray *buttons, *indicators;
}

@property (nonatomic, assign) int selectedIndex;
@property (nonatomic, assign) id<IndicatorSegmentDelegate> delegate;

@property (nonatomic, retain) UIColor *selectedColor;
@property (nonatomic, retain) UIColor *normalColor;
@property (nonatomic, retain) UIColor *textColor;

- (id)initWithFrame:(CGRect)frame titles:(NSArray *)titles;
- (UIButton *)segmentAtIndex:(int)index;
- (void)updateLayout;

@end
