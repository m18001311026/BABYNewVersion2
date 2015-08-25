//
//  UIButton+UIButtonExtra.m
//  baby
//
//  Created by zhang da on 14-3-4.
//  Copyright (c) 2014年 zhang da. All rights reserved.
//

#import "UIButtonExtra.h"

@implementation UIButton (UIButtonExtra)

+ (UIButton *)buttonWithCustomStyle:(CustomButtonStyle)style {
    return [self buttonWithCustomStyle:style position:CustomButtonPositonLeft];
}

+ (UIButton *)buttonWithCustomStyle:(CustomButtonStyle)style position:(CustomButtonPositon)position
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = (position == CustomButtonPositonLeft? CGRectMake(7, 7, 30, 30): CGRectMake(283, 7, 30, 30));
    
    if (style == CustomButtonStyleBack)
    {
        [button setBackgroundImage:[UIImage imageNamed:@"back_btn.png"] forState:UIControlStateNormal];
    } else if (style == CustomButtonStyleCancel)
    {
        [button setBackgroundImage:[UIImage imageNamed:@"mCancel.png"] forState:UIControlStateNormal];
    } else if (style == CustomButtonStyleDone)
    {
        [button setBackgroundImage:[UIImage imageNamed:@"done_btn.png"] forState:UIControlStateNormal];
    } else if (style == CustomButtonStyleLocation)
    {
        [button setBackgroundImage:[UIImage imageNamed:@"mLocation.png"] forState:UIControlStateNormal];
    } else if (style == CustomButtonStyleMenu)
    {
        [button setBackgroundImage:[UIImage imageNamed:@"menu.png"] forState:UIControlStateNormal];
    } else if (style == CustomButtonStyleShare) {
        [button setBackgroundImage:[UIImage imageNamed:@"share_btn.png"] forState:UIControlStateNormal];
    }
    return button;
}


+ (UIButton *)simpleButton:(NSString *)title y:(int)y {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(20, y, 280, 40);
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor colorWithRed:234/255.0 green:166/255.0 blue:31/255.0 alpha:1]];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [btn.layer setCornerRadius:4.0];
    return btn;
}

@end
