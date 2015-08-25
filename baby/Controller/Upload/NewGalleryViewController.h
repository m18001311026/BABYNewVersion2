//
//  NewGalleryViewController.h
//  baby
//
//  Created by zhang da on 14-3-10.
//  Copyright (c) 2014年 zhang da. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BBViewController.h"

@class ShareView, Topic;

@interface NewGalleryViewController : BBViewController <UITextViewDelegate> {
    UIScrollView *pictureHolder;
    NSMutableArray *thumbViewList;
    NSMutableArray *pictureList;
    
    UITextView *introView;
    UILabel *introViewPlaceHolder;
    ShareView *shareView;
}

@property (nonatomic, assign) int maxPictureCount;
@property (nonatomic, retain) Topic *topic;

- (void)addPicture:(UIImage *)pic voice:(NSString *)file id:(long)pid;
- (void)setInitContent:(NSString *)content;

@end
