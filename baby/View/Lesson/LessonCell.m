//
//  LessonCell.m
//  baby
//
//  Created by zhang da on 14-3-24.
//  Copyright (c) 2014年 zhang da. All rights reserved.
//

#import "LessonCell.h"
#import "ImageView.h"
#import "UIColorExtra.h"
#import "Lesson.h"
#import "ConfigManager.h"

@implementation LessonCell

- (void)dealloc {
    
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [Shared bbWhite];
        
        videoPreview = [[ImageView alloc] init];
        videoPreview.frame = CGRectMake(5, 0, 94, 65);
        videoPreview.clipsToBounds = YES;
        [self addSubview:videoPreview];
        [videoPreview release];
        
        lessonTitle = [[UILabel alloc] initWithFrame:CGRectMake(104, 2, 146, 20)];
        lessonTitle.text = @"";
        lessonTitle.font = [UIFont systemFontOfSize:14];
        lessonTitle.textColor = [UIColor darkGrayColor];
        lessonTitle.backgroundColor = [UIColor clearColor];
        [self addSubview:lessonTitle];
        [lessonTitle release];
        
        time = [[UILabel alloc] initWithFrame:CGRectMake(104, 42, 100, 15)];
        time.text = @"";
        time.font = [UIFont systemFontOfSize:12];
        time.textColor = [UIColor darkGrayColor];
        time.backgroundColor = [UIColor clearColor];
        [self addSubview:time];
        [time release];
        //chulijian 价格注释处
        UIView *moneyBg = [[UIView alloc] initWithFrame:CGRectMake(251, 0, 64, 65)];
        moneyBg.backgroundColor = [UIColor r:255 g:220 b:10 alpha:.2];
        [self addSubview:moneyBg];
        
        [moneyBg release];
        
        moneyLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 62, 23)];
        moneyLable.text = @"";
        moneyLable.font = [UIFont fontWithName:@"DBLCDTempBlack" size:22];
        moneyLable.minimumFontSize = 14;
        moneyLable.numberOfLines = 1;
        moneyLable.adjustsFontSizeToFitWidth = YES;
        moneyLable.textColor = [UIColor colorWithRed:234/255.0 green:166/255.0 blue:31/255.0 alpha:1];
        moneyLable.textAlignment = UITextAlignmentCenter;
        moneyLable.backgroundColor = [UIColor clearColor];
        [moneyBg addSubview:moneyLable];
        [moneyLable release];
        
        buy = [UIButton buttonWithType:UIButtonTypeCustom];
        buy.frame = CGRectMake(5, 40, 54, 15);
        buy.backgroundColor = [UIColor colorWithRed:234/255.0 green:166/255.0 blue:31/255.0 alpha:1];
        [buy setTitle:@"立即观看" forState:UIControlStateNormal];
        [buy setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        buy.titleLabel.font = [UIFont systemFontOfSize:12];
        buy.layer.cornerRadius = 2.0;
        buy.layer.masksToBounds = YES;
        buy.titleLabel.textAlignment = UITextAlignmentCenter;
        [moneyBg addSubview:buy];
        moneyBg.hidden=YES;
        //chulijian
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateLayout {
    Lesson *lesson = [Lesson getLessonWithId:self.lessonId];
    
    videoPreview.imagePath = lesson.cover;
    lessonTitle.text = lesson.title;
    time.text = [TOOL stringFromUnixTime:lesson.createTime];
    
    moneyLable.hidden = [ConfigManager me].runInReviewMode;
    buy.hidden = [ConfigManager me].runInReviewMode;
    
    moneyLable.text = [NSString stringWithFormat:@"￥%0.01f", lesson.price];
    
    moneyLable.hidden=YES;
    //chulijian
}


@end
