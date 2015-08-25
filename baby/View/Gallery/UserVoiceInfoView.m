//
//  UserVoiceInfoView.m
//  baby
//
//  Created by zhang da on 14-3-4.
//  Copyright (c) 2014年 zhang da. All rights reserved.
//

#import "UserVoiceInfoView.h"
#import "User.h"
#import "Gallery.h"
#import "ImageView.h"
#import "RegexManager.h"

@interface UserVoiceInfoView ()

@property (nonatomic, retain) User *user;
@property (nonatomic, retain) Gallery *gallery;

@end


@implementation UserVoiceInfoView

- (void)dealloc {
    self.user = nil;
    self.delegate = nil;
    
    [super dealloc];
}

- (void)setGalleryId:(long)galleryId {
    if (_galleryId != galleryId) {
        _galleryId = galleryId;
        self.gallery = [Gallery getGalleryWithId:galleryId];
        if (self.isComment) {
            self.user = [User getUserWithId:self.gallery.commentatorId];
        } else {
            self.user = [User getUserWithId:self.gallery.userId];
        }
    } else if ((!self.gallery || !self.user) && _galleryId > 0) {
        self.gallery = [Gallery getGalleryWithId:galleryId];
        if (self.isComment) {
            self.user = [User getUserWithId:self.gallery.commentatorId];
        } else {
            self.user = [User getUserWithId:self.gallery.userId];
        }
    }

}

- (void)setIsPlaying:(bool)isPlaying {
    if (_isPlaying != isPlaying) {
        _isPlaying = isPlaying;
        
        if (_isPlaying) {
            [loading startAnimating];
            playIndicator.hidden = YES;
            voiceLengthLabel.hidden = YES;
        } else {
            [loading stopAnimating];
            playIndicator.hidden = NO;
            voiceLengthLabel.hidden = NO;
        }
    }
}

- (void)setVoiceLength:(int)voiceLength {
    if (_voiceLength != voiceLength) {
        _voiceLength = voiceLength;
        voiceLengthLabel.text = [NSString stringWithFormat:@"%d”", voiceLength];
    }
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        UIImageView *bg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"moonhalf1.png"]];
        bg.frame = CGRectMake(8, 1, 140, 64);
        [self addSubview:bg];
        [bg release];
        
        avatar = [[ImageView alloc] initWithImage:[UIImage imageNamed:@"baby_logo.png"]];
        //avatar.backgroundColor = [UIColor redColor];
        avatar.frame = CGRectMake(18, 15, 46, 46);
        avatar.layer.cornerRadius = 23;
        if (self.isComment) {
            avatar.layer.borderColor = [Shared bbYellow].CGColor;
        } else {
            avatar.layer.borderColor = [UIColor whiteColor].CGColor;
        }
        avatar.layer.borderWidth = 2;
        avatar.layer.masksToBounds = YES;
        [self addSubview:avatar];
        [avatar release];
        
        userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 14, 46, 16)];
        userNameLabel.backgroundColor = [UIColor clearColor];
        userNameLabel.font = [UIFont systemFontOfSize:14];
        userNameLabel.textColor = [UIColor darkGrayColor];
        [self addSubview:userNameLabel];
        [userNameLabel release];
        
        ageLabel = [[UILabel alloc] initWithFrame:CGRectMake(101, 33, 46, 20)];
        ageLabel.backgroundColor = [UIColor clearColor];
        ageLabel.font = [UIFont systemFontOfSize:10];
        ageLabel.textColor = [UIColor grayColor];
        [self addSubview:ageLabel];
        [ageLabel release];
        
        timestampLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 49, 50, 14)];
        timestampLabel.backgroundColor = [UIColor clearColor];
        timestampLabel.minimumFontSize = 10.0f;
        timestampLabel.numberOfLines = 1;
        timestampLabel.font = [UIFont systemFontOfSize:12];
        timestampLabel.textColor = [UIColor grayColor];
        [self addSubview:timestampLabel];
        [timestampLabel release];
        
        loading = [[UIActivityIndicatorView alloc]
                   initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        loading.frame = CGRectMake(72, 31, 10, 10);
        loading.hidesWhenStopped = YES;
        [self addSubview:loading];
        [loading release];
        
        playIndicator = [[UIImageView alloc] initWithFrame:CGRectMake(73, 27, 10, 10)];
        playIndicator.image = [UIImage imageNamed:@"play_indicator"];
        [self addSubview:playIndicator];
        [playIndicator release];
        
        voiceLengthLabel = [[UILabel alloc] initWithFrame:CGRectMake(65, 40, 27, 14)];
        voiceLengthLabel.backgroundColor = [UIColor clearColor];
        voiceLengthLabel.font = [UIFont systemFontOfSize:11];
        voiceLengthLabel.textAlignment = NSTextAlignmentCenter;
        voiceLengthLabel.textColor = [UIColor whiteColor];
        [self addSubview:voiceLengthLabel];
        [voiceLengthLabel release];
        
        UIButton *avatarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        avatarBtn.frame = avatar.frame;
        [avatarBtn addTarget:self action:@selector(avatarTouched) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:avatarBtn];
        
        UIButton *voiceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        voiceBtn.frame = CGRectMake(60, 10, 50, 50);
        [voiceBtn addTarget:self action:@selector(voiceTouched) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:voiceBtn];
    }
    return self;
}

- (void)updateLayout
{
//    if (self.isComment) {
        if (!self.user.avatarMid.length) {
            avatar.imagePath = nil;
            avatar.image = nil;
//            avatar.image = [UIImage imageNamed:@"baby_logo.png"];
        } else {
            avatar.imagePath = self.user.avatarMid;
        }
//    } else {
//        avatar.imagePath = self.user.avatarMid;
//    }
    
    avatar.layer.borderColor = self.user.isTeacher? [Shared bbYellow].CGColor: [UIColor colorWithWhite:.9 alpha:1].CGColor;
// (chenxin)
    if (!self.isComment) {
        userNameLabel.text = self.user.showName;
        
        if ([RegexManager isPhoneNum:self.user.showName]) {
            userNameLabel.text = @"匿名";
        }
        
        ageLabel.text = [NSString stringWithFormat:@"%d岁", self.gallery.age];
        voiceLengthLabel.text = [NSString stringWithFormat:@"%d”", self.voiceLength];
        timestampLabel.text = [TOOL formattedStringFromDate:[TOOL dateFromUnixTime:self.gallery.createTime]];
    } else {
        if (self.user) {
            userNameLabel.text = self.user.showName;
            
            if ([RegexManager isPhoneNum:self.user.showName]) {
                userNameLabel.text = @"匿名";
            }
        } else {
            userNameLabel.text = @"暂无";
        }
        ageLabel.text = @"热门评论";
        voiceLengthLabel.text = [NSString stringWithFormat:@"%d”", self.voiceLength];
        if (self.gallery.commentTime) {
            timestampLabel.text = [TOOL formattedStringFromDate:[TOOL dateFromUnixTime:self.gallery.commentTime]];
        } else {
            timestampLabel.text = @"";
        }
    }
}

- (void)avatarTouched {
    if (self.delegate) {
        [self.delegate showUserDetail:self.user._id];
    }
}

- (void)voiceTouched {
    if (self.delegate) {
        [self.delegate playVoiceForGallery:self.galleryId atIndex:self.page isComment:self.isComment];
    }
}


@end
