//
//  LanuchViewController.h
//  baby
//
//  Created by chenxin on 14-11-8.
//  Copyright (c) 2014年 zhang da. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^AfterLanuchView)() ;

@interface LanuchViewController : UIViewController

@property (nonatomic, strong) AfterLanuchView afterLanuchView;

- (void)showLanchView;

@end
