//
//  AccountView.m
//  baby
//
//  Created by zhang da on 14-3-6.
//  Copyright (c) 2014年 zhang da. All rights reserved.
//

#import "SelfView.h"
#import "ImageView.h"
#import "User.h"

#import "UserTask.h"
#import "TaskQueue.h"
#import "ConfigManager.h"
#import "Session.h"

@implementation SelfView

- (void)dealloc {

    [super dealloc];
}


- (id)initWithFrame:(CGRect)frame forUser:(long)userId {
    self = [super initWithFrame:frame];
    if (self) {
        self.userId = userId;
        
        userBg = [[ImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 219)];
        [self addSubview:userBg];
        [userBg release];
        
//        UIView *mask = [[UIView alloc] initWithFrame:userBg.frame];
//        mask.backgroundColor = [UIColor colorWithWhite:1 alpha:.5];
//        [self addSubview:mask];
//        [mask release];
        
        avatar = [[ImageView alloc] initWithFrame:CGRectMake(130, 67, 60, 60)];
        //avatar.backgroundColor = [UIColor redColor];
        avatar.layer.cornerRadius = 30;
        avatar.layer.borderColor = [UIColor whiteColor].CGColor;
        avatar.layer.borderWidth = 2;
        avatar.layer.masksToBounds = YES;
        [self addSubview:avatar];
        [avatar release];
     
        nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 76, 112, 20)];
        nameLabel.textColor = [UIColor whiteColor];
        nameLabel.textAlignment = UITextAlignmentRight;
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.font = [UIFont systemFontOfSize:18];
        nameLabel.text = @"";
        [self addSubview:nameLabel];
        [nameLabel release];
        
        ageLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 100, 112, 16)];
        ageLabel.textColor = [UIColor whiteColor];
        ageLabel.textAlignment = UITextAlignmentRight;
        ageLabel.backgroundColor = [UIColor clearColor];
        ageLabel.font = [UIFont systemFontOfSize:14];
        ageLabel.text = @"";
        [self addSubview:ageLabel];
        [ageLabel release];
        
//        userBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        userBtn.frame = CGRectMake(196, 87, 70, 20);
//        [userBtn setTitle:@"编辑" forState:UIControlStateNormal];
//        [userBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [userBtn setBackgroundColor:[UIColor darkGrayColor]];
//        [userBtn addTarget:self action:@selector(userBtnTouched) forControlEvents:UIControlEventTouchUpInside];
//        userBtn.titleLabel.font = [UIFont boldSystemFontOfSize:13];
//        [userBtn.layer setCornerRadius:10];
//        [self addSubview:userBtn];
    }
    return self;
}

- (void)updateLayout {
    User *user = [User getUserWithId:self.userId];
    
    CallbackBlock block = ^(bool successful, id userInfo) {
        if (successful) {
            User *user = [User getUserWithId:self.userId];
            if (user) {
                avatar.imagePath = user.avatarMid;
                if (user.homeCover) {
                    userBg.imagePath = user.homeCover;
                }
                nameLabel.text = user.showName;
                ageLabel.text = [NSString stringWithFormat:@"%d岁", user.age];
            }
        }
    };

    if (user) {
        block(YES, nil);
    } else
        {
            UserTask *task = [[UserTask alloc] initUserDetail:self.userId];
            task.logicCallbackBlock = ^(bool successful, id userInfo) {
            block(YES, nil);
        };
        [TaskQueue addTaskToQueue:task];
        [task release];
    }
    
}




- (void)userBtnTouched
{
    if (self.delegate)
    {
        if ([self.delegate respondsToSelector:@selector(editUserDetail:)]) {
            [self.delegate editUserDetail:self];
        }
    }
}


@end
