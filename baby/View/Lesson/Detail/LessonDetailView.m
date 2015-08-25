//
//  LessonDetailView.m
//  baby
//
//  Created by zhang da on 14-3-25.
//  Copyright (c) 2014年 zhang da. All rights reserved.
//

#import "LessonDetailView.h"
#import "Lesson.h"

#import "CartTask.h"
#import "TaskQueue.h"
#import "UserLessonLK.h"
#import "ConfigManager.h"

#define BAR_HEIGHT 60

@implementation LessonDetailView

- (void)dealloc {
    [bar release];

    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame lesson:(long)lessonId {
    self = [super initWithFrame:frame];
    if (self) {

        self.lessonId = lessonId;
        self.backgroundColor = [Shared bbWhite];
        
        holder = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, frame.size.height)];
        holder.contentInset = UIEdgeInsetsMake(0, 0, BAR_HEIGHT, 0);
        [self addSubview:holder];
        [holder release];
        
        int posY = 15;
        
        title = [[UILabel alloc] initWithFrame:CGRectMake(10, posY, 230, 20)];
        title.text = @"宝贝计画课程";
        title.font = [UIFont boldSystemFontOfSize:15];
        title.backgroundColor = [UIColor clearColor];
        [holder addSubview:title];
        [title release];
        
//        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(250, posY - 2, 1, 24)];
//        line.backgroundColor = [UIColor lightGrayColor];
//        [holder addSubview:line];
//        line.hidden=YES;
//        [line release];
        
//        priceUnit = [[UILabel alloc] initWithFrame:CGRectMake(255, posY + 8, 15, 14)];
//     //   priceUnit.text = @"￥";
//        priceUnit.text = @"";
//
//        priceUnit.font = [UIFont boldSystemFontOfSize:16];
//        priceUnit.backgroundColor = [UIColor clearColor];
//        priceUnit.textColor = [UIColor colorWithRed:234/255.0 green:166/255.0 blue:31/255.0 alpha:1];
//        [holder addSubview:priceUnit];
//        priceUnit.hidden=YES;
//        [priceUnit release];
        
//        price = [[UILabel alloc] initWithFrame:CGRectMake(272, posY - 2, 46, 27)];
//      //  price.text = @"0.0";
//        price.text = @"";
//
//        price.font = [UIFont fontWithName:@"DBLCDTempBlack" size:26];
//        price.minimumFontSize = 14;
//        price.numberOfLines = 1;
//        price.adjustsFontSizeToFitWidth = YES;
//        price.backgroundColor = [UIColor clearColor];
//        price.textColor = [UIColor colorWithRed:234/255.0 green:166/255.0 blue:31/255.0 alpha:1];
//        [holder addSubview:price];
//        [price release];
        
        posY += title.frame.size.height;
        posY += 10;
        
        createTime = [[UILabel alloc] initWithFrame:CGRectMake(10, posY, 280, 16)];
        createTime.text = @"上线：";
        createTime.font = [UIFont systemFontOfSize:14];
        createTime.backgroundColor = [UIColor clearColor];
        [holder addSubview:createTime];
        [createTime release];
        
        posY += createTime.frame.size.height;
        posY += 5;
        
//        teacher = [[UILabel alloc] initWithFrame:CGRectMake(10, posY, 280, 16)];
//        teacher.text = @"主讲：杨帅";
//        teacher.font = [UIFont systemFontOfSize:14];
//        teacher.backgroundColor = [UIColor clearColor];
//        [holder addSubview:teacher];
//        [teacher release];
//        
//        posY += teacher.frame.size.height;
//        posY += 5;
        
        type = [[UILabel alloc] initWithFrame:CGRectMake(10, posY, 280, 16)];
        type.text = @"类型：少儿美术绘本";
        type.font = [UIFont systemFontOfSize:14];
        type.backgroundColor = [UIColor clearColor];
        [holder addSubview:type];
        [type release];
        
        posY += type.frame.size.height;
        posY += 5;
        
        length = [[UILabel alloc] initWithFrame:CGRectMake(10, posY, 280, 16)];
        length.text = @"时长：0:0";
        length.font = [UIFont systemFontOfSize:14];
        length.backgroundColor = [UIColor clearColor];
        [holder addSubview:length];
        [length release];
        
        posY += length.frame.size.height;
        posY += 10;
        
        intro = [[UILabel alloc] initWithFrame:CGRectMake(10, posY, 300, frame.size.height - 50 - posY)];
        intro.text = @"";
        intro.textColor = [UIColor grayColor];
        intro.backgroundColor = [UIColor clearColor];
        intro.numberOfLines = 0;
        intro.font = [UIFont systemFontOfSize:14];
        [holder addSubview:intro];
        [intro release];
        
        bar = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height - BAR_HEIGHT, 320, BAR_HEIGHT)];
        bar.backgroundColor = [UIColor colorWithRed:234/255.0 green:166/255.0 blue:31/255.0 alpha:1];
        
        UIButton *buy = [UIButton buttonWithType:UIButtonTypeCustom];
        buy.frame = CGRectMake(20, 12, 130, 36);
        buy.layer.cornerRadius = 2.0;
        buy.layer.masksToBounds = YES;
        buy.backgroundColor = [UIColor whiteColor];
        [buy setTitleColor:[UIColor colorWithRed:234/255.0 green:166/255.0 blue:31/255.0 alpha:1] forState:UIControlStateNormal];
        [buy setTitle:@"立即购买" forState:UIControlStateNormal];
        buy.titleLabel.font = [UIFont systemFontOfSize:15];
        [buy addTarget:self action:@selector(buyButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        [bar addSubview:buy];
        
        cart = [UIButton buttonWithType:UIButtonTypeCustom];
        cart.frame = CGRectMake(170, 12, 130, 36);
        cart.layer.cornerRadius = 2.0;
        cart.layer.borderColor = [UIColor whiteColor].CGColor;
        cart.layer.borderWidth = 1;
        cart.layer.masksToBounds = YES;
        cart.backgroundColor = [UIColor colorWithRed:234/255.0 green:166/255.0 blue:31/255.0 alpha:1];
        [cart setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [cart addTarget:self action:@selector(editRelation) forControlEvents:UIControlEventTouchUpInside];
        //[cart setTitle:@"放入购物车" forState:UIControlStateNormal];
        cart.titleLabel.font = [UIFont systemFontOfSize:15];
        [bar addSubview:cart];
        
    }
    return self;
}

- (void)updateLayout {
    priceUnit.hidden = [ConfigManager me].runInReviewMode;
    price.hidden = [ConfigManager me].runInReviewMode;
    
    Lesson *l = [Lesson getLessonWithId:self.lessonId];
    
    title.text = l.title;
    price.text = [NSString stringWithFormat:@"%0.01f", l.price];
    createTime.text = [NSString stringWithFormat:@"上线：%@", [TOOL stringFromUnixTime:l.createTime]];
//    teacher.text = @"主讲：杨帅";
    type.text = [NSString stringWithFormat:@"类型：%@ %@", [l typeString], [l ageString]];
    length.text = [NSString stringWithFormat:@"时长：%@", [l lengthString]];
    
    CGSize size = [l.content sizeWithFont:intro.font
                        constrainedToSize:CGSizeMake(300, INFINITY)];
    intro.frame = CGRectMake(10, intro.frame.origin.y, 300, size.height);
    intro.text = l.content;
    
    holder.contentSize = CGSizeMake(320, intro.frame.origin.y + size.height + 15);
    
    [self updateRelation];
}

- (void)updateCartBtn {
    bar.hidden = [ConfigManager me].runInReviewMode;
    
    UserLessonLK *lk = [UserLessonLK getUserLessonLK:[ConfigManager me].userId lesson:self.lessonId];
    if (!lk) {
        [cart setTitle:@"放入购物车" forState:UIControlStateNormal];
    } else {
        if (lk.status == 1) {
            [self addSubview:bar];
            [cart setTitle:@"移除购物车" forState:UIControlStateNormal];
        } else if (lk.status == 3) {
            [bar removeFromSuperview];
        } else {
            [self addSubview:bar];
            [cart setTitle:@"放入购物车" forState:UIControlStateNormal];
        }
    }
}

- (void)updateRelation {
//    UserLessonLK *lk = [UserLessonLK getUserLessonLK:[ConfigManager me].userId lesson:self.lessonId];
//    if (!lk) {
//        CartTask *task = [[CartTask alloc] initLessonRelationQuery:self.lessonId];
//        task.logicCallbackBlock = ^(bool succeeded, id userInfo) {
//            [self updateCartBtn];
//        };
//        [TaskQueue addTaskToQueue:task];
//        [task release];
//    } else {
//        [self updateCartBtn];
//    }
}

- (void)editRelation {
    UserLessonLK *lk = [UserLessonLK getUserLessonLK:[ConfigManager me].userId lesson:self.lessonId];
    if (!lk) {
        [self updateRelation];
    } else {
        CartTask *task = [[CartTask alloc] initEditLesson:self.lessonId relation:!lk.status];
        task.logicCallbackBlock = ^(bool successful, id userInfo) {            
            [self updateCartBtn];
            if (lk.status == 1) {
                [UI showAlert:@"已经加入购物车"];
            } else if (lk.status == 0) {
                [UI showAlert:@"已经从购物车移除"];
            }
        };
        [TaskQueue addTaskToQueue:task];
        [task release];
    }
}

- (void)buyButtonPressed {
    if (self.delegate && [self.delegate respondsToSelector:@selector(buyLesson)]) {
        [self.delegate buyLesson];
    }
}

@end
