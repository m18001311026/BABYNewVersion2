//
//  AccountView.h
//  baby
//
//  Created by zhang da on 14-3-6.
//  Copyright (c) 2014年 zhang da. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ImageView, SelfView;


@protocol AccountViewDelegate <NSObject>

@required
- (void)editUserDetail:(SelfView *)caller;
@end


@interface SelfView : UIView {
    ImageView *userBg, *avatar;
    UILabel *nameLabel, *ageLabel;
    UIButton *userBtn;
}

@property (nonatomic, assign) long userId;
@property (nonatomic, assign) id<AccountViewDelegate> delegate;

- (void)updateLayout;
- (id)initWithFrame:(CGRect)frame forUser:(long)userId;

@end
