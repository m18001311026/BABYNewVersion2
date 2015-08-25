//
//  Macro.h
//  baby
//
//  Created by chenxin on 14-12-10.
//  Copyright (c) 2014年 zhang da. All rights reserved.
//

#ifndef baby_Macro_h
#define baby_Macro_h

// 高度
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
// 宽度
#define kScreenWidth [UIScreen mainScreen].bounds.size.width

#define iOS6 [[[UIDevice currentDevice] systemVersion] floatValue] < 7.0


#ifdef DEBUG
#define CLLog(format, ...) NSLog(format, ## __VA_ARGS__)
#define LogFunc NSLog(@"%s", __func__)
#else
#define DLog(format, ...)
#define LogFunc ;
#endif


//notify part
#define UserDidAddGalleryNotification @"UserDidAddGalleryNotification"
#define UserDidAddCommentNotification @"UserDidAddCommentNotification"
#define UserDidLoginNotification @"UserDidLoginNotification"

#endif
