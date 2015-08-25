//
//  LessonCell.h
//  baby
//
//  Created by zhang da on 14-3-24.
//  Copyright (c) 2014年 zhang da. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"


@class ImageView;

@protocol CartCellDelegate <NSObject>

- (void)checkBtnTouchedForLesson:(long)lessonId;
- (void)previewTouchedForLesson:(long)lessonId;
- (void)deleteTouchedForLesson:(long)lessonId;

@end


@interface CartCell : SWTableViewCell <SWTableViewCellDelegate> {
    ImageView *videoPreview;
    UIButton *checkBtn;
    UILabel *lessonTitle, *time, *moneyLable;
}

@property (nonatomic, assign) long lessonId;
@property (nonatomic, assign) id<CartCellDelegate> delegate;
@property (nonatomic, assign) bool checked;

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
              table:(UITableView *)table;
- (void)updateLayout;

@end
