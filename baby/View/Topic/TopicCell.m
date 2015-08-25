//
//  TopicCell.m
//  baby
//
//  Created by zhang da on 14-3-23.
//  Copyright (c) 2014年 zhang da. All rights reserved.
//

#import "TopicCell.h"
#import "ImageView.h"

#define IMAGEVIEW_TAG 9999
#define TITLE_TAG 8888

@implementation TopicCell

- (void)dealloc {
    [views release];
    
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
             colCnt:(int)colCnt
             height:(int)height {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _colCnt = colCnt;
        _height = height;
        
        views = [[NSMutableArray alloc] init];
        self.backgroundColor = [Shared bbWhite];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                              action:@selector(touched:)];
        [self addGestureRecognizer:tap];
        [tap release];
        
        [self layoutGallery];
    }
    return self;
}

- (void)layoutGallery {
    for (UIView *v in views) {
        [v removeFromSuperview];
    }
    [views removeAllObjects];
    
    float width = self.frame.size.width/self.colCnt*1.0f;
    
    for (int i = 0; i < _colCnt; i++) {
        UIView *holder = [[UIView alloc] init];
        holder.backgroundColor = [Shared bbWhite];
        holder.frame = CGRectMake(width*i + i + 1, 0, width, _height);
        [self addSubview:holder];
        [views addObject:holder];
        [holder release];
        
        ImageView *thumb = [[ImageView alloc] init];
        thumb.backgroundColor = [Shared bbWhite];
        thumb.frame = CGRectMake(10, 5, _height - 10, _height - 10);
        thumb.layer.cornerRadius = thumb.frame.size.width/2.0f;
        thumb.layer.masksToBounds = YES;
        thumb.layer.borderColor = [UIColor colorWithRed:234/255.0 green:166/255.0 blue:31/255.0 alpha:1].CGColor;
        thumb.layer.borderWidth = 1;
        [holder addSubview:thumb];
        thumb.tag = IMAGEVIEW_TAG;
        [thumb release];
        
        float originX = thumb.frame.origin.x + thumb.frame.size.width + 10;
        UILabel *label = [[UILabel alloc] initWithFrame:
                          CGRectMake(originX,
                                     (_height - 14)/2.0,
                                     holder.frame.size.width - originX - 10,
                                     13)];
        label.textColor = [UIColor darkGrayColor];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont systemFontOfSize:13];
        label.tag = TITLE_TAG;
        [holder addSubview:label];
        [label release];
    }

}

- (void)setImagePath:(NSString *)imagePath atCol:(int)col {
    if (views.count > col) {
        UIView *view = [views objectAtIndex:col];
        ImageView *v = (ImageView *)[view viewWithTag:IMAGEVIEW_TAG];
        v.imagePath = imagePath;
        v.hidden = (imagePath == nil);
    }
}

- (void)setTitle:(NSString *)topic atCol:(int)col {
    if (views.count > col) {
        UIView *view = [views objectAtIndex:col];
        UILabel *titel = (UILabel *)[view viewWithTag:TITLE_TAG];
        titel.text = topic;
    }
}


- (void)touched:(UITapGestureRecognizer *)tap {
    CGPoint point = [tap locationInView:self];
    for (UIView *v in views) {
        ImageView *iv = (ImageView *)[v viewWithTag:IMAGEVIEW_TAG];
        if ([v superview] && CGRectContainsPoint(v.frame, point) && iv.imagePath) {
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(topicTouchedAtRow:andCol:)]) {
                [self.delegate topicTouchedAtRow:self.row andCol:[views indexOfObject:v]];
                break;
            }
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
