//
//  PostTask.h
//  baby
//
//  Created by zhang da on 14-3-3.
//  Copyright (c) 2014年 zhang da. All rights reserved.
//

#import "BBNetworkTask.h"
#import "GComment.h"
@interface PostTask : BBNetworkTask
@property (nonatomic, retain) GComment *comment;
- (id)initNewPicture:(UIImage *)image voice:(NSData *)voice length:(int)voiceLength;

- (id)initNewGallery:(NSArray *)pictureIds content:(NSString *)content city:(int)city;

- (id)initNewGCommentForGallery:(long)galleryId
                        replyTo:(NSString *)replyTo
                          voice:(NSData *)voice
                         length:(int)voiceLength
                        content:(NSString *)content;

- (id)initNewLCommentForLesson:(long)lessonId
                       replyTo:(NSString *)replyTo
                         voice:(NSData *)voice
                        length:(int)voiceLength
                       content:(NSString *)content;
- (id)initNewGallery:(NSString *)galleryId topicId:(NSString *)topicId;
@end
