//
//  GalleryTask.h
//  baby
//
//  Created by zhang da on 14-3-16.
//  Copyright (c) 2014年 zhang da. All rights reserved.
//

#import "BBNetworkTask.h"

@interface GalleryTask : BBNetworkTask

- (id)initGalleryList:(bool)singlePage page:(int)page count:(int)count;
- (id)initRecommendGalleryList;
- (id)initTopicGalleryList:(long)topicId page:(int)page count:(int)count;
- (id)initCityGalleryList:(int)cityId page:(int)page count:(int)count;
- (id)initUserGalleryList:(long)userId page:(int)page count:(int)count;
- (id)initLikeGalleryListAtPage:(int)page count:(int)count;
- (id)initGalleryDetail:(long)galleryId;
- (id)initDeleteGallery:(long)galleryId;

- (id)initGCommentList:(long)galleryId page:(int)page count:(int)count;
- (id)initGCommentList:(long)userId;
- (id)initDeleteGComment:(long)commentId;


@property(nonatomic,retain)NSMutableArray *userDictArr;
@property(nonatomic,retain)NSMutableArray *replyDictArr;
@property(nonatomic,retain)NSMutableArray *attentionArr;

@end
