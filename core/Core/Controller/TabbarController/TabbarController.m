//
//  TabbarController.m
//  TestWP7View
//
//  Created by alfaromeo on 12-3-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "TabbarController.h"
#import "TaskQueue.h"
#import "Macro.h"
#import "WelcomeViewController.h"
#import "ConfigManager.h"
 @interface TabbarController ()<UIAlertViewDelegate>

- (TabbarSubviewController *)viewControllerAtIndex:(int)index;

@end


@implementation TabbarController

@synthesize contentView, tabbar, selectedPage;
@synthesize selectedTabbarSubviewController;
@synthesize appearAnimation;

- (void)dealloc {
    self.selectedTabbarSubviewController.parentController = nil;
    self.selectedTabbarSubviewController = nil;
    
    [viewControllerClasses release];
    [viewControllerParams release];
    [viewControllers release];
    
    [contentView release];
    [tabbar release];
    
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame {
    
    self = [super init];
    if (self) {
        
        
        selectedPage = 0;
        userFlags.initAppear = YES;
        
        contentView = [[UIView alloc] initWithFrame:frame];
        contentView.backgroundColor = [UIColor clearColor];
        
        viewControllerClasses = [[NSMutableDictionary alloc] init];
        viewControllerParams = [[NSMutableDictionary alloc] init];
        viewControllers = [[NSMutableDictionary alloc] init];
                
        tabbar = [[UIImageView alloc] initWithFrame:CGRectMake(0,
                                                          frame.size.height - [self tabbarHeight],
                                                          frame.size.width,
                                                          [self tabbarHeight])];
        tabbar.userInteractionEnabled = YES;
        tabbar.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:tabbar];
      //  tabbar.hidden=YES;
        //chulijian tabbar
        
    }
    return self;

}

- (void)setSelectedPage:(int)value {
    
    if ( value != selectedPage  && !userFlags.disableScroll ) {
        
        BOOL right = (selectedPage > value);
        TabbarSubviewController *newCtr = [self viewControllerAtIndex:value];
        if (newCtr) {
            CGRect newCtrFrame = contentView.frame;
            newCtrFrame.origin = CGPointZero;
            CGRect newCtrDstFrame = newCtrFrame, currentCtrDstFrame = newCtrFrame;
            
            if (right) {
                newCtrFrame.origin.x -= newCtrFrame.size.width;
                newCtr.view.frame = newCtrFrame;
                currentCtrDstFrame.origin.x += newCtrFrame.size.width;
            } else {
                newCtrFrame.origin.x += newCtrFrame.size.width;
                newCtr.view.frame = newCtrFrame;
                currentCtrDstFrame.origin.x -= newCtrFrame.size.width;

            }
            
            [contentView insertSubview:newCtr.view belowSubview:tabbar];
         
//            CLLog(@"old:%@ new:%@", selectedTabbarSubviewController, newCtr);
        
            [UIView animateWithDuration:.6 animations:^{
                 userFlags.disableScroll = YES;
 
                 TabbarItem *current = [self itemAtIndex:selectedPage];
                 current.activated = NO;
                 
                 self.selectedTabbarSubviewController.view.frame = currentCtrDstFrame;
                 newCtr.view.frame = newCtrDstFrame;
            } completion:^(BOOL finished) {
                 
                 [self.selectedTabbarSubviewController.view removeFromSuperview];
                 self.selectedTabbarSubviewController = newCtr;
                 selectedTabbarSubviewController.view.userInteractionEnabled = YES;
                 
                 //NSLog(@"%d %@ %@",[newCtr retainCount], newCtr, viewControllers);
                 
                 selectedPage = value;
                 userFlags.disableScroll = NO;
                 
                 
//                 CLLog(@"---------%@", viewControllers);
//                 for (id key in [viewControllers allKeys]) {
////                     id obj = [viewControllers objectForKey:key];
////                     CLLog(@"key:%@, %@-%d", key, obj, [obj retainCount]);
//                 }
                
                 TabbarItem *current = [self itemAtIndex:selectedPage];
                 current.activated = YES;
                 
             }];
        }
    } else if (value == selectedPage  && !userFlags.disableScroll ) {
        if (!selectedTabbarSubviewController) {
            
            TabbarSubviewController *newCtr = [self viewControllerAtIndex:value];
            self.selectedTabbarSubviewController = newCtr;
            newCtr.view.frame = contentView.bounds;
            [contentView insertSubview:newCtr.view belowSubview:tabbar];

            TabbarItem *current = [self itemAtIndex:selectedPage];
            current.activated = NO;
            selectedPage = value;
            current = [self itemAtIndex:selectedPage];
            current.activated = YES;
        }
    }
}

- (void)setSelectedPage:(int)value tabBar:(BOOL)exist{
//    CLLog(@"new page :%d", value);
    
    
    if ( value != selectedPage  && !userFlags.disableScroll ) {
        BOOL right = (selectedPage > value);
        TabbarSubviewController *newCtr = [self viewControllerAtIndex:value];
        if (newCtr) {
            CGRect newCtrFrame = contentView.frame;
            newCtrFrame.origin = CGPointZero;
            CGRect newCtrDstFrame = newCtrFrame, currentCtrDstFrame = newCtrFrame;
            
            if (right) {
                newCtrFrame.origin.x -= newCtrFrame.size.width;
                newCtr.view.frame = newCtrFrame;
                currentCtrDstFrame.origin.x += newCtrFrame.size.width;
             
            } else {
                newCtrFrame.origin.x += newCtrFrame.size.width;
                newCtr.view.frame = newCtrFrame;
                currentCtrDstFrame.origin.x -= newCtrFrame.size.width;
                
            }
            
            [contentView insertSubview:newCtr.view belowSubview:tabbar];
            
//            CLLog(@"old:%@ new:%@", selectedTabbarSubviewController, newCtr);
            
            [UIView
             animateWithDuration:.6
             animations:^{
                 userFlags.disableScroll = YES;
                 
                 self.selectedTabbarSubviewController.view.frame = currentCtrDstFrame;
                 newCtr.view.frame = newCtrDstFrame;
             }
             completion:^(BOOL finished) {
                 
                 [self.selectedTabbarSubviewController.view removeFromSuperview];
                 self.selectedTabbarSubviewController = newCtr;
                 selectedTabbarSubviewController.view.userInteractionEnabled = YES;
                 
                 selectedPage = value;
                 userFlags.disableScroll = NO;
                 
//                 CLLog(@"---------%@", viewControllers);
//                 for (id key in [viewControllers allKeys]) {
//                     id obj = [viewControllers objectForKey:key];
////                     CLLog(@"key:%@, %@-%d", key, obj, [obj retainCount]);
//                 }
                 
                 if (exist) {
                     TabbarItem *current = [self itemAtIndex:selectedPage];
                     current.activated = YES;
                 }
             
             }];
        }
    } else if (value == selectedPage  && !userFlags.disableScroll ) {
        if (!selectedTabbarSubviewController) {
            
            TabbarSubviewController *newCtr = [self viewControllerAtIndex:value];
            self.selectedTabbarSubviewController = newCtr;
            newCtr.view.frame = contentView.bounds;
            [contentView insertSubview:newCtr.view belowSubview:tabbar];
            if (exist) {
                TabbarItem *current = [self itemAtIndex:selectedPage];
                current.activated = NO;
                selectedPage = value;
                current = [self itemAtIndex:selectedPage];
                current.activated = YES;
            }
       
        }
    }
}


#pragma mark utility
- (void)setViewController:(NSString *)ctrName params:(NSDictionary *)param atIndex:(int)index {
    if (ctrName)
        [viewControllerClasses setObject:ctrName forKey:[NSNumber numberWithInt:index]];
    if (param)
        [viewControllerParams setObject:param forKey:[NSNumber numberWithInt:index]];
}

- (void)addItem:(TabbarItem *)item {
    item.delegate = self;
    [tabbar addSubview:item];
}

- (TabbarItem *)itemAtIndex:(int)idx {
    NSArray *views = [tabbar subviews];
    for (UIView *view in views) {
        if ([view isKindOfClass:[TabbarItem class]]) {
            TabbarItem *item = (TabbarItem *)view;
            if (item.index == idx) {
                return item;
            }
        }
    }
    return nil;
}

- (TabbarSubviewController *)viewControllerAtIndex:(int)index {
    TabbarSubviewController *ctr = [viewControllers objectForKey:[NSNumber numberWithInt:index]];
    
    if (!ctr) {
        NSString *className = [viewControllerClasses objectForKey:[NSNumber numberWithInt:index]];
        if (className) {
            ctr = (TabbarSubviewController *)[[NSClassFromString(className) alloc] init];
            NSDictionary *params = [viewControllerParams objectForKey:[NSNumber numberWithInt:index]];
            NSArray *allKeys = [params allKeys];
            for (NSString *key in allKeys) {
                [ctr setValue:[params objectForKey:key] forKey:key];
            }
            ctr.subviewDelegate = self;
            ctr.parentController = self;
            ctr.view.frame = contentView.frame;
            
            [viewControllers setObject:ctr forKey:[NSNumber numberWithInt:index]];
            [ctr release];
        }
    }
    
    return ctr;
}

- (void)swipeToLeft {
    if (!userFlags.disableScroll) {
        selectedTabbarSubviewController.view.userInteractionEnabled = NO;
        self.selectedPage = selectedPage + 1;   
    }
}

- (void)swipeToRight {
    if (!userFlags.disableScroll) {
        selectedTabbarSubviewController.view.userInteractionEnabled = NO;
        self.selectedPage = selectedPage - 1;
    }
}

- (BOOL)subTabbarShouldScroll {
    return [viewControllerClasses count] > 1;
}

- (float)tabbarHeight {
    return 44;
}

- (void)tabbarItemTouchedAtIndex:(int)index {
    
    NSLog(@"ppppppppppppppppppp%d",index);

    //chulijian
    if(index!=0)
    {
                if (![[ConfigManager me] getSession])
                
                {
                    
                    
                    UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"" message:@"您需要登录才可以获取其他内容" delegate:self cancelButtonTitle:@"取消" otherButtonTitles: @"确定",nil];
                    
                    
                    [alert show];
                    
                    
                    
                    
                    
                    // 用户没有登陆
//                    WelcomeViewController *welVC = [[WelcomeViewController alloc] init];
//                    [ctr pushViewController:welVC animation:ViewSwitchAnimationNone];
//                    [welVC release];
                }
//                    WelcomeViewController *welVC = [[WelcomeViewController alloc] init];
//                    [ctr pushViewController:welVC animation:ViewSwitchAnimationNone];
//                    [welVC release];
    }
    
    
    
    
    

}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"cccccccccccc%ld",(long)buttonIndex);
    if (buttonIndex==1) {
        WelcomeViewController *welVC = [[WelcomeViewController alloc] init];
        [ctr pushViewController:welVC animation:ViewSwitchAnimationNone];
        [welVC release];
    }
    else
    {
        self.selectedPage=0;
        
        
//        [self tabbarItemShouldSelectAtIndex:0];
//        [self tabbarItemTouchedAtIndex:0];
        
    }
    

}



- (BOOL)tabbarItemShouldSelectAtIndex:(int)index {
    return YES;
}

- (void)setTabbarHidden:(BOOL)hide {
    tabbar.hidden = hide;
}


#pragma mark tabbaritem delegate
- (void)tabbarItem:(TabbarItem *)item touchedAtIndex:(int)idx {
    if (!userFlags.disableScroll) {
        if ([self tabbarItemShouldSelectAtIndex:idx]) {
            [self itemAtIndex:selectedPage].activated = NO;
            item.activated = YES;
            
            self.selectedPage = idx;
        }
        
        DLog(@"select item at index: %d", idx);
        [self tabbarItemTouchedAtIndex:idx];
    }
}


#pragma TabbarSubviewController delegate
- (void)tabbarSubViewDidScroll:(float)distance {
    if (!userFlags.disableScroll) {        
        CGRect currentFrame = selectedTabbarSubviewController.view.frame;
        currentFrame.origin.x = distance;
        selectedTabbarSubviewController.view.frame = currentFrame;
    }
}

- (void)tabbarSubViewDidEndScrolling {
    if (!userFlags.disableScroll) {
        CGRect currentFrame = selectedTabbarSubviewController.view.frame;
        float changePoint = currentFrame.size.width*kTabbarChangePagePoint;
        if (currentFrame.origin.x < -changePoint) {
            //NSLog(@"Tabbar scrolled");
            [self swipeToLeft];
        } else if (currentFrame.origin.x > changePoint) {
            //NSLog(@"Tabbar scrolled");
            [self swipeToRight];
        } else {
            float animationTime = .5*fabsf(currentFrame.origin.x)/changePoint;
            currentFrame.origin.x = 0;
            [UIView animateWithDuration:animationTime
                             animations:^{
                                 selectedTabbarSubviewController.view.frame = currentFrame;
                             }];
            //NSLog(@"Tabbar reseted");
        }
    }
}


#pragma mark view life cycle
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    if (!userFlags.initAppear) {
        [selectedTabbarSubviewController viewWillAppear:animated];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    [selectedTabbarSubviewController viewDidAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [selectedTabbarSubviewController viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [selectedTabbarSubviewController viewDidDisappear:animated];
}


@end
