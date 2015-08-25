//
//  LessonCommentView.h
//  baby
//
//  Created by zhang da on 14-3-25.
//  Copyright (c) 2014年 zhang da. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullTableView.h"
#import "EditView.h"
#import "LCommentCell.h"


@interface LessonCommentView : UIView
<UITableViewDataSource, UITableViewDelegate, PullTableViewDelegate, EditViewDelegate, LCommentCellDelegate>{
    
    PullTableView *commentTable;
    EditView *editView;
    NSMutableArray *comments;
    int currentPage;
}

@property (nonatomic, assign) long lessonId;

- (id)initWithFrame:(CGRect)frame lesson:(long)lessonId;

@end
