//
//  TopicCell.m
//  baby
//
//  Created by zhang da on 14-3-23.
//  Copyright (c) 2014年 zhang da. All rights reserved.
//

#import "TopicSimpleCell.h"
#import "ImageView.h"

#define TITLE_TAG 8888

@implementation TopicSimpleCell

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
        
        UILabel *label = [[UILabel alloc] initWithFrame:
                          CGRectMake(10,
                                     (_height - 16
                                      )/2.0,
                                     holder.frame.size.width - 20,
                                     20)];
        label.textColor = [UIColor grayColor];
        label.layer.borderColor = [UIColor colorWithRed:234/255.0 green:166/255.0 blue:31/255.0 alpha:1].CGColor;
        label.layer.borderWidth = 1;
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont systemFontOfSize:13];
        label.tag = TITLE_TAG;
        label.textAlignment = NSTextAlignmentCenter;
        [holder addSubview:label];
        [label release];
    }

}

- (void)setTitle:(NSString *)topic atCol:(int)col {
    if (views.count > col) {
        UIView *view = [views objectAtIndex:col];
        UILabel *titel = (UILabel *)[view viewWithTag:TITLE_TAG];
        titel.text = [NSString stringWithFormat:@"#%@#", topic];
    }
}


- (void)touched:(UITapGestureRecognizer *)tap {
    CGPoint point = [tap locationInView:self];
    for (UIView *v in views) {
        if ([v superview] && CGRectContainsPoint(v.frame, point)) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(simpleTopicTouchedAtRow:andCol:)]) {
                [self.delegate simpleTopicTouchedAtRow:self.row andCol:[views indexOfObject:v]];
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
