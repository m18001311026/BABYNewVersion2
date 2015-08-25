//
//  LessonCell.h
//  baby
//
//  Created by zhang da on 14-3-24.
//  Copyright (c) 2014年 zhang da. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ImageView;

@protocol SchoolCellDelegate <NSObject>

@end


@interface SchoolCell : UITableViewCell {
    ImageView *schoolPreview;
    UILabel *title, *city, *distance;
}

@property (nonatomic, assign) long schoolId;
@property (nonatomic, assign) id<SchoolCellDelegate> delegate;

- (void)updateLayout;

@end
