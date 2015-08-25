//
//  LKTask.h
//  baby
//
//  Created by zhang da on 14-3-23.
//  Copyright (c) 2014年 zhang da. All rights reserved.
//

#import "BBNetworkTask.h"

@interface LKTask : BBNetworkTask

- (id)initGalleryRelation:(long)galleryId like:(bool)like;
- (id)initUserRelation:(long)userId follow:(bool)follow;

@end
