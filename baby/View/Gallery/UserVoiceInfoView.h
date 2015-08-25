//
//  UserVoiceInfoView.h
//  baby
//
//  Created by zhang da on 14-3-4.
//  Copyright (c) 2014年 zhang da. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ImageView;
@class UserVoiceInfoView;


@protocol UserVoiceInfoViewDelegate <NSObject>

@required
- (void)showUserDetail:(long)userId;
- (void)playVoiceForGallery:(long)galleryId atIndex:(int)page isComment:(bool)isComment;
@end


@interface UserVoiceInfoView : UIView {
    ImageView *avatar;
    
    UIImageView *playIndicator;
    UIActivityIndicatorView *loading;
    
    UILabel *userNameLabel, *ageLabel, *timestampLabel, *voiceLengthLabel;
}

@property (nonatomic, assign) int voiceLength;
@property (nonatomic, assign) bool isPlaying;
@property (nonatomic, assign) bool isComment;
@property (nonatomic, assign) long galleryId;
@property (nonatomic, assign) int page;
@property (nonatomic, assign) id<UserVoiceInfoViewDelegate> delegate;

- (void)updateLayout;

@end
