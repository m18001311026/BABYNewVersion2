//
//  GalleryPictureLK.h
//  baby
//
//  Created by zhang da on 14-3-21.
//  Copyright (c) 2014年 zhang da. All rights reserved.
//

#import "Model.h"

@interface GalleryPictureLK : Model

@property (nonatomic, assign) long _id;
@property (nonatomic, assign) long galleryId;
@property (nonatomic, assign) long pictureId;
@property (nonatomic, assign) int index;

+ (NSArray *)getPicturesForGallery:(long)galleryId;

@end
