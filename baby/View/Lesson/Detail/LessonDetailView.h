//
//  LessonDetailView.h
//  baby
//
//  Created by zhang da on 14-3-25.
//  Copyright (c) 2014年 zhang da. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LessonDetailViewDelegate <NSObject>

@required
- (void)buyLesson;

@end


@interface LessonDetailView : UIView {
    UIScrollView *holder;
    UIView *bar;
    UILabel *title, *price, *createTime, *teacher, *type, *length;
    UILabel *intro;
    UILabel *priceUnit;
    UIButton *cart;
}

@property (nonatomic, assign) long lessonId;
@property (nonatomic, assign) id<LessonDetailViewDelegate> delegate;

- (id)initWithFrame:(CGRect)frame lesson:(long)lessonId;
- (void)updateLayout;

@end
