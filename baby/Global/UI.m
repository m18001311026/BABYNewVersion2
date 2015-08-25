//
//  UI.m
//  baby
//
//  Created by zhang da on 14-3-4.
//  Copyright (c) 2014年 zhang da. All rights reserved.
//

#import "UI.h"

#define INDICATOR_TAG 98765
#define INDICATOR_SIZE 100

@implementation UI

+ (void)showAlert:(NSString *)content {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:content
                                                       delegate:nil
                                              cancelButtonTitle:@"好的"
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
    });
}

+ (void)showAlertSigned:(NSString *)content {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:content
                                                       delegate:nil
                                              cancelButtonTitle:@"您的手机号码已注册，请重新登录"
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
    });
}






+ (void)showIndicator {
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([delegate.window viewWithTag:INDICATOR_TAG]) {
            [self hideIndicator];
        }
        
        UIView *bg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, INDICATOR_SIZE, INDICATOR_SIZE)];
        bg.center = delegate.window.center;
        bg.backgroundColor = [UIColor colorWithRed:234/255.0 green:166/255.0 blue:31/255.0 alpha:1];
        bg.layer.cornerRadius = 2;
        bg.layer.masksToBounds = YES;
        bg.tag = INDICATOR_TAG;
        
        UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc]
                                              initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        indicator.frame = CGRectMake(0, 0, INDICATOR_SIZE/2, INDICATOR_SIZE/2);
        indicator.center = CGPointMake(INDICATOR_SIZE/2, INDICATOR_SIZE/2);
        [bg addSubview:indicator];
        [indicator release];
        [indicator startAnimating];
        
        [delegate.window addSubview:bg];
        [bg release];
    });
}

+ (void)hideIndicator {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[delegate.window viewWithTag:INDICATOR_TAG] removeFromSuperview];
    });
}

@end
