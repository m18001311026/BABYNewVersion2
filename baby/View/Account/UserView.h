//
//  AccountView.h
//  baby
//
//  Created by zhang da on 14-3-6.
//  Copyright (c) 2014年 zhang da. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ImageView, UserView;


@protocol UserViewDelegate <NSObject>

@required
- (void)editUserRelation:(UserView *)caller;
//- (void)showPicture;
- (void)showFriend;
- (void)showFan;
@end


@interface UserView : UIView {
    ImageView *userBg, *avatar;
    UILabel *nameLabel, *ageLabel;
    UILabel *fanLabel, *friendLabel, *pictureLabel;
    UIButton *userBtn;
    
    
    
}

@property (nonatomic, assign) long userId;
@property (nonatomic, assign) id<UserViewDelegate> delegate;

- (void)updateLayout;
- (id)initWithFrame:(CGRect)frame forUser:(long)userId;

@end
