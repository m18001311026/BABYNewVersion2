//
//  SimpleSegment.h
//  baby
//
//  Created by zhang da on 14-3-17.
//  Copyright (c) 2014年 zhang da. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SimpleSegmentDelegate <NSObject>

@optional
- (void)segmentSelected:(int)index;

@end


@interface SimpleSegment : UIView {
    NSMutableArray *buttons;
}

@property (nonatomic, assign) int selectedIndex;
@property (nonatomic, assign) id<SimpleSegmentDelegate> delegate;

@property (nonatomic, retain) UIColor *selectedBackgoundColor;
@property (nonatomic, retain) UIColor *normalBackgroundColor;
@property (nonatomic, retain) UIColor *selectedTextColor;
@property (nonatomic, retain) UIColor *normalTextColor;
@property (nonatomic, retain) UIColor *borderColor;

- (id)initWithFrame:(CGRect)frame titles:(NSArray *)titles;
- (UIButton *)segmentAtIndex:(int)index;
- (void)updateLayout;

@end
