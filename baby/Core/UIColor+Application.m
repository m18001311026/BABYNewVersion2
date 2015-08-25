//
//  UIColor+Application.m
//  baby
//
//  Created by chenxin on 14-12-10.
//  Copyright (c) 2014年 zhang da. All rights reserved.
//

#import "UIColor+Application.h"

static UIColor *applicationYellowColor, *applicationLightYellowColor;

@implementation UIColor (Application)

+ (UIColor *)applicationYellowColor {
    
    if (!applicationYellowColor) {
        applicationYellowColor = [[UIColor alloc] initWithRed:250.0/255.0 green:210.0/255.0 blue:6/255.0 alpha:1];
    }
    
    return applicationYellowColor;
}

+ (UIColor *)applicationLightYellowColor {
    
    if (!applicationLightYellowColor) {
        applicationLightYellowColor = [[UIColor alloc] initWithRed:251.0/255.0 green:245.0/255.0 blue:238.0/255.0 alpha:1];
    }
    
    return applicationLightYellowColor;
    
}

@end
