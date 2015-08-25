//
//  TopicSimpleCell.h
//  baby
//
//  Created by zhang da on 14-3-23.
//  Copyright (c) 2014年 zhang da. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ImageView;


@protocol TopicSimpleCellDelegate <NSObject>
- (void)simpleTopicTouchedAtRow:(int)row andCol:(int)col;
@end



@interface TopicSimpleCell : UITableViewCell {
    NSMutableArray *views;
    NSMutableArray *titles;
}

@property (nonatomic, readonly) int colCnt;
@property (nonatomic, readonly) int height;

@property (nonatomic, assign) id<TopicSimpleCellDelegate> delegate;
@property (nonatomic, assign) int row;

- (void)setTitle:(NSString *)topic atCol:(int)col;

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
             colCnt:(int)colCnt
             height:(int)height;

@end
