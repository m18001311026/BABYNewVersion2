//
//  AccountView.m
//  baby
//
//  Created by zhang da on 14-3-6.
//  Copyright (c) 2014年 zhang da. All rights reserved.
//

#import "UserView.h"
#import "ImageView.h"
#import "User.h"

#import "UserTask.h"
#import "TaskQueue.h"
#import "ConfigManager.h"
#import "Session.h"

@implementation UserView

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
        
        userBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        userBtn.frame = CGRectMake(196, 87, 70, 20);
        [userBtn setTitle:@"+关注" forState:UIControlStateNormal];
        [userBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [userBtn setBackgroundColor:[UIColor colorWithRed:234/255.0 green:166/255.0 blue:31/255.0 alpha:1]];
        [userBtn addTarget:self action:@selector(userBtnTouched) forControlEvents:UIControlEventTouchUpInside];
        userBtn.titleLabel.font = [UIFont boldSystemFontOfSize:13];
        [userBtn.layer setCornerRadius:10];
        [self addSubview:userBtn];
        
        pictureLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 180, 100, 17)];
        pictureLabel.textColor = [UIColor whiteColor];
        pictureLabel.textAlignment = UITextAlignmentCenter;
        pictureLabel.backgroundColor = [UIColor clearColor];
        pictureLabel.font = [UIFont boldSystemFontOfSize:16];
        pictureLabel.text = @"1000";
        [self addSubview:pictureLabel];
        [pictureLabel release];
        
        UILabel *pcitureTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 200, 100, 14)];
        pcitureTitle.textColor = [UIColor whiteColor];
        pcitureTitle.textAlignment = UITextAlignmentCenter;
        pcitureTitle.backgroundColor = [UIColor clearColor];
        pcitureTitle.font = [UIFont systemFontOfSize:12];
        pcitureTitle.text = @"发布的画";
        [self addSubview:pcitureTitle];
        [pcitureTitle release];
        
//        UIButton *showPicture = [UIButton buttonWithType:UIButtonTypeCustom];
//        showPicture.frame = CGRectMake(0, 180, 105, 34);
//        [showPicture addTarget:self action:@selector(showPicture) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:showPicture];
        
        UIView *slider1 = [[UIView alloc] initWithFrame:CGRectMake(108, 182, 1, 30)];
        slider1.backgroundColor = [UIColor whiteColor];
        [self addSubview:slider1];
        [slider1 release];
        
        friendLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 180, 100, 17)];
        friendLabel.textColor = [UIColor whiteColor];
        friendLabel.textAlignment = UITextAlignmentCenter;
        friendLabel.backgroundColor = [UIColor clearColor];
        friendLabel.font = [UIFont boldSystemFontOfSize:16];
        friendLabel.text = @"100";
        [self addSubview:friendLabel];
        [friendLabel release];
        
        UILabel *friendTitle = [[UILabel alloc] initWithFrame:CGRectMake(110, 200, 100, 14)];
        friendTitle.textColor = [UIColor whiteColor];
        friendTitle.textAlignment = UITextAlignmentCenter;
        friendTitle.backgroundColor = [UIColor clearColor];
        friendTitle.font = [UIFont systemFontOfSize:12];
        friendTitle.text = @"关注";
        [self addSubview:friendTitle];
        [friendTitle release];
        
        UIButton *showFriend = [UIButton buttonWithType:UIButtonTypeCustom];
        showFriend.frame = CGRectMake(105, 180, 110, 34);
        [showFriend addTarget:self action:@selector(showFriend) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:showFriend];
        
        UIView *slider2 = [[UIView alloc] initWithFrame:CGRectMake(215, 182, 1, 30)];
        slider2.backgroundColor = [UIColor whiteColor];
        [self addSubview:slider2];
        [slider2 release];
        
        fanLabel = [[UILabel alloc] initWithFrame:CGRectMake(220, 180, 100, 17)];
        fanLabel.textColor = [UIColor whiteColor];
        fanLabel.textAlignment = UITextAlignmentCenter;
        fanLabel.backgroundColor = [UIColor clearColor];
        fanLabel.font = [UIFont boldSystemFontOfSize:16];
        fanLabel.text = @"89898";
        [self addSubview:fanLabel];
        [fanLabel release];

        UILabel *fanTitle = [[UILabel alloc] initWithFrame:CGRectMake(220, 200, 100, 14)];
        fanTitle.textColor = [UIColor whiteColor];
        fanTitle.textAlignment = UITextAlignmentCenter;
        fanTitle.backgroundColor = [UIColor clearColor];
        fanTitle.font = [UIFont systemFontOfSize:12];
        fanTitle.text = @"粉丝";
        [self addSubview:fanTitle];
        [fanTitle release];
        
        UIButton *showFan = [UIButton buttonWithType:UIButtonTypeCustom];
        showFan.frame = CGRectMake(215, 180, 110, 34);
        [showFan addTarget:self action:@selector(showFan) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:showFan];
    }
    return self;
}

- (void)updateLayout {
    User *user = [User getUserWithId:self.userId];
    
    CallbackBlock block = ^(bool successful, id userInfo) {
        if (successful)
        {
            User *user = [User getUserWithId:self.userId];
            if (user)
            {
                avatar.imagePath = user.avatarMid;
                if (user.homeCover)
                {
                    userBg.imagePath = user.homeCover;
                }
                nameLabel.text = user.showName;
                ageLabel.text = [NSString stringWithFormat:@"%d岁", user.age];

                pictureLabel.text = [NSString stringWithFormat:@"%ld", user.galleryCnt];
                fanLabel.text = [NSString stringWithFormat:@"%ld", user.fanCnt];
                friendLabel.text = [NSString stringWithFormat:@"%ld", user.friendCnt];
                
                if (!user.following)
                {
                    UserTask *task = [[UserTask alloc] initUserDetail:self.userId];
                    task.logicCallbackBlock = ^(bool successful, id userInfo) {
                        if (user.following) {
                            [userBtn setTitle:[user.following boolValue]? @"取消关注": @"+关注"
                                     forState:UIControlStateNormal];
                        }
                    };
                    [TaskQueue addTaskToQueue:task];
                    [task release];
                }
                else if (user.following)
                {
                    
                    [userBtn setTitle:[user.following boolValue]? @"取消关注": @"+关注"
                             forState:UIControlStateNormal];
                }
            }
        }
    };

    if (user) {
        block(YES, nil);
    } else {
        UserTask *task = [[UserTask alloc] initUserDetail:self.userId];
        task.logicCallbackBlock = ^(bool successful, id userInfo) {
            block(YES, nil);
        };
        [TaskQueue addTaskToQueue:task];
        [task release];
    }
    
}

- (void)receiveNsnotification
{
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(userBtnTouched) name:@"attentionBtnDown" object:nil];
    
    
}

- (void)userBtnTouched

{
    if (self.delegate && [self.delegate respondsToSelector:@selector(editUserRelation:)]) {
        [self.delegate editUserRelation:self];
    }
}

//- (void)showPicture {
//    if (self.delegate && [self.delegate respondsToSelector:@selector(showPicture)]) {
//        [self.delegate showPicture];
//    }
//}

- (void)showFriend {
    if (self.delegate && [self.delegate respondsToSelector:@selector(showFriend)]) {
        [self.delegate showFriend];
    }
}

- (void)showFan {
    if (self.delegate && [self.delegate respondsToSelector:@selector(showFan)]) {
        [self.delegate showFan];
    }
}


@end
