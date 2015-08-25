//
//  AddVoiceViewController.h
//  baby
//
//  Created by zhang da on 14-3-10.
//  Copyright (c) 2014年 zhang da. All rights reserved.
//

#import "BBViewController.h"

@class NewGalleryViewController;
@class VoiceMask;

@interface AddVoiceViewController : BBViewController<UITableViewDataSource, UITableViewDelegate> {
    UIImageView *showImage;
    UIButton *playbackBtn;
    VoiceMask *voiceMask;
}

@property (nonatomic, assign) NewGalleryViewController *root;
@property (nonatomic, assign) bool isUploading;

- (id)initWithImage:(UIImage *)image root:(NewGalleryViewController *)root;

@end
