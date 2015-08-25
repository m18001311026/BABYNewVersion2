//
//  LessonCell.m
//  baby
//
//  Created by zhang da on 14-3-24.
//  Copyright (c) 2014年 zhang da. All rights reserved.
//

#import "SchoolCell.h"
#import "ImageView.h"
#import "UIColorExtra.h"
#import "School.h"

@implementation SchoolCell

- (void)dealloc {
    
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        schoolPreview = [[ImageView alloc] init];
        schoolPreview.frame = CGRectMake(5, 5, 94, 65);
        schoolPreview.clipsToBounds = YES;
        [self addSubview:schoolPreview];
        [schoolPreview release];
        
        title = [[UILabel alloc] initWithFrame:CGRectMake(104, 2, 190, 20)];
        title.text = @"";
        title.font = [UIFont systemFontOfSize:14];
        title.textColor = [UIColor darkGrayColor];
        title.backgroundColor = [UIColor clearColor];
        [self addSubview:title];
        [title release];
        
        city = [[UILabel alloc] initWithFrame:CGRectMake(104, 52, 200, 15)];
        city.text = @"";
        city.font = [UIFont systemFontOfSize:12];
        city.textColor = [UIColor darkGrayColor];
        city.backgroundColor = [UIColor clearColor];
        [self addSubview:city];
        [city release];
        
//        distance = [[UILabel alloc] initWithFrame:CGRectMake(250, 52, 60, 13)];
//        distance.text = @"距离";
//        distance.font = [UIFont systemFontOfSize:12];
//        distance.textColor = [UIColor darkGrayColor];
//        distance.textAlignment = UITextAlignmentRight;
//        distance.backgroundColor = [UIColor clearColor];
//        [self addSubview:distance];
//        [distance release];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateLayout {
    School *school = [School getSchoolWithId:self.schoolId];
    
    schoolPreview.imagePath = school.cover;
    title.text = school.title;
    city.text = school.address;
    distance.text = [NSString stringWithFormat:@"%.2f公里", 1.5f];
    
}


@end
