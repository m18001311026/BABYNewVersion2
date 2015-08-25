//
//  LKTask.m
//  baby
//
//  Created by zhang da on 14-3-23.
//  Copyright (c) 2014年 zhang da. All rights reserved.
//

#import "LKTask.h"
#import "ConfigManager.h"
#import "Session.h"
#import "Gallery.h"
#import "User.h"

@implementation LKTask

- (id)initGalleryRelation:(long)galleryId like:(bool)like {
    self = [super initWithUrl:SERVERURL method:POST session:[[ConfigManager me] getSession].session];
    if (self) {
        [self addParameter:@"action" value:@"gallery_Relation"];
        [self addParameter:@"gallery_id" value:[NSString stringWithFormat:@"%ld", galleryId]];
        [self addParameter:@"relation" value:[NSString stringWithFormat:@"%d", like]];

        self.responseCallbackBlock = ^(bool succeeded, id userInfo) {
            if (succeeded) {
                Gallery *g = [Gallery getGalleryWithId:galleryId];
                g.liked = [NSNumber numberWithBool:like];
                g.likeCnt = g.likeCnt + (like? 1: -1);
                
                NSDictionary *dict = (NSDictionary *)userInfo;
                [self doLogicCallBack:YES info:dict];
            } else {
                [self doLogicCallBack:NO info:userInfo];
            }
        };
    }
    return self;
}
//chulijian





- (id)initUserRelation:(long)userId follow:(bool)follow
{
    self = [super initWithUrl:SERVERURL method:POST session:[[ConfigManager me] getSession].session];
    if (self) {
        [self addParameter:@"action" value:@"user_Relation"];
        [self addParameter:@"user_id" value:[NSString stringWithFormat:@"%ld", userId]];
        [self addParameter:@"relation" value:[NSString stringWithFormat:@"%d", follow]];

        self.responseCallbackBlock = ^(bool succeeded, id userInfo) {
            if (succeeded) {
                User *u = [User getUserWithId:userId];
                u.following = [NSNumber numberWithBool:follow];
                
                NSDictionary *dict = (NSDictionary *)userInfo;
                [self doLogicCallBack:YES info:dict];
            } else {
                [self doLogicCallBack:NO info:userInfo];
            }
        };
    }
    return self;
}

@end
