//
//  AccountView.h
//  baby
//
//  Created by zhang da on 14-3-6.
//  Copyright (c) 2014年 zhang da. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ImageView, UserView;


@protocol SelfSummaryViewDelegate <NSObject>

@required
- (void)editUserDetail;
- (void)userLogin;

- (void)editUserHome;
- (void)showPicture;
- (void)showFriend;
- (void)showFan;
@end


@interface SelfSummaryView : UIView {
    ImageView *userBg, *avatar;
    UILabel *nameLabel, *ageLabel;
    UILabel *fanLabel, *friendLabel, *pictureLabel;
    UILabel *editLabel;
    UIButton *userBtn;
}

@property (nonatomic, assign) long userId;
@property (nonatomic, assign) id<SelfSummaryViewDelegate> delegate;

- (void)updateLayout;
- (void)setImage:(UIImage *)image;
- (id)initWithFrame:(CGRect)frame forUser:(long)userId;

@end
