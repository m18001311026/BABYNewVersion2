//
//  LessonCell.m
//  baby
//
//  Created by zhang da on 14-3-24.
//  Copyright (c) 2014年 zhang da. All rights reserved.
//

#import "CartCell.h"
#import "ImageView.h"
#import "UIColorExtra.h"

#import "Lesson.h"

@implementation CartCell

- (void)dealloc {
    
    [super dealloc];
}

- (void)setChecked:(bool)checked {
    _checked = checked;
    checkBtn.backgroundColor = checked? [Shared bbHightlight]: [UIColor clearColor];
}

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
              table:(UITableView *)table {
    
    NSMutableArray *rightUtilityButtons = [[NSMutableArray alloc] init];
    [rightUtilityButtons addUtilityButtonWithColor:[UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0f]
                                             title:@"删除"];
    self = [super initWithStyle:style
                reuseIdentifier:reuseIdentifier
                         height:76
             leftUtilityButtons:nil
            rightUtilityButtons:rightUtilityButtons];
    [rightUtilityButtons release];
    
    if (self) {
        self.scrollDelegate = self;
        
        self.scrollViewContentView.backgroundColor = [Shared bbRealWhite];
        
        checkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        checkBtn.frame = CGRectMake(5, 29, 18, 18);
        checkBtn.clipsToBounds = YES;
        checkBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
        checkBtn.layer.borderWidth = 2.0;
        checkBtn.layer.cornerRadius = 9;
        checkBtn.layer.masksToBounds = YES;
        checkBtn.backgroundColor = [UIColor clearColor];
        [checkBtn addTarget:self action:@selector(checkTouched) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollViewContentView addSubview:checkBtn];
        
        videoPreview = [[ImageView alloc] init];
        videoPreview.frame = CGRectMake(35, 10, 80, 55);
        videoPreview.clipsToBounds = YES;
        videoPreview.userInteractionEnabled = YES;
        [self.scrollViewContentView addSubview:videoPreview];
        [videoPreview release];
        
        UIButton *previewBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        previewBtn.frame = CGRectMake(0, 0, videoPreview.frame.size.width, videoPreview.frame.size.height);
        [videoPreview addSubview:previewBtn];
        [previewBtn addTarget:self action:@selector(previewTouched) forControlEvents:UIControlEventTouchUpInside];
        
        lessonTitle = [[UILabel alloc] initWithFrame:CGRectMake(122, 10, 150, 20)];
        lessonTitle.text = @"";
        lessonTitle.font = [UIFont systemFontOfSize:14];
        lessonTitle.textColor = [UIColor darkGrayColor];
        lessonTitle.backgroundColor = [UIColor clearColor];
        [self.scrollViewContentView addSubview:lessonTitle];
        [lessonTitle release];
        
        time = [[UILabel alloc] initWithFrame:CGRectMake(122, 46, 100, 15)];
        time.text = @"";
        time.font = [UIFont systemFontOfSize:12];
        time.textColor = [UIColor darkGrayColor];
        time.backgroundColor = [UIColor clearColor];
        [self.scrollViewContentView addSubview:time];
        [time release];
        
        moneyLable = [[UILabel alloc] initWithFrame:CGRectMake(272, 30, 46, 15)];
        moneyLable.text = @"";
        moneyLable.font = [UIFont fontWithName:@"DBLCDTempBlack" size:14];
        moneyLable.minimumFontSize = 10.0f;
        moneyLable.numberOfLines = 1;
        moneyLable.textColor = [UIColor colorWithRed:234/255.0 green:166/255.0 blue:31/255.0 alpha:1];
        //moneyLable.textAlignment = UITextAlignmentCenter;
        moneyLable.backgroundColor = [UIColor clearColor];
        [self.scrollViewContentView addSubview:moneyLable];
        [moneyLable release];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)checkTouched {
    if (self.delegate && [self.delegate respondsToSelector:@selector(checkBtnTouchedForLesson:)]) {
        [self.delegate checkBtnTouchedForLesson:self.lessonId];
    }
}

- (void)deleteTouched {
    if (self.delegate && [self.delegate respondsToSelector:@selector(deleteTouchedForLesson:)]) {
        [self.delegate deleteTouchedForLesson:self.lessonId];
    }
}

- (void)previewTouched {
    if (self.delegate && [self.delegate respondsToSelector:@selector(previewTouchedForLesson:)]) {
        [self.delegate previewTouchedForLesson:self.lessonId];
    }
}

- (void)updateLayout {
    Lesson *lesson = [Lesson getLessonWithId:self.lessonId];
    
    videoPreview.imagePath = lesson.cover;
    lessonTitle.text = lesson.title;
    time.text = [TOOL stringFromUnixTime:lesson.createTime];
    moneyLable.text = [NSString stringWithFormat:@"￥%0.1f", lesson.price];
    moneyLable.hidden=YES;
}


#pragma mark - SWTableViewDelegate
- (void)swippableTableViewCell:(SWTableViewCell *)cell didTriggerLeftUtilityButtonWithIndex:(NSInteger)index {

}

- (void)swippableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    [self deleteTouched];
}


@end
