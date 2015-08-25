//
//  LessonCell.h
//  baby
//
//  Created by zhang da on 14-3-24.
//  Copyright (c) 2014年 zhang da. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ImageView;

@protocol BoughtLessonCellDelegate <NSObject>

@end


@interface BoughtLessonCell : UITableViewCell {
    ImageView *videoPreview;
    UILabel *lessonTitle, *time, *moneyLable;
    UIButton *buy;
}

@property (nonatomic, assign) long lessonId;
@property (nonatomic, assign) id<BoughtLessonCellDelegate> delegate;

- (void)updateLayout;

@end
