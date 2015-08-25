//
//  PostTask.m
//  baby
//
//  Created by zhang da on 14-3-3.
//  Copyright (c) 2014年 zhang da. All rights reserved.
//

#import "PostTask.h"
#import "ConfigManager.h"
#import "Session.h"
#import "MemContainer.h"
#import "GalleryPictureLK.h"
#import "Picture.h"


#import "User.h"

@implementation PostTask

- (void)dealloc {

    [super dealloc];
}

- (id)initNewPicture:(UIImage *)image voice:(NSData *)voice length:(int)voiceLength {
    self = [super initWithUrl:SERVERURL method:POST session:[[ConfigManager me] getSession].session];
    if (self) {
        [self addParameter:@"action" value:@"picture_Add"];
        if (image) {
            [self addParameter:@"image" value:UIImageJPEGRepresentation(image, 1.0) fileName:@"image.jpg"];
        }
        if (voice && voiceLength > 0) {
            [self addParameter:@"voice" value:voice fileName:@"voice.mp3"];
            [self addParameter:@"voice_length" value:[NSString stringWithFormat:@"%d", voiceLength]];
        }
        self.responseCallbackBlock = ^(bool succeeded, id userInfo) {
            if (succeeded) {
                NSDictionary *dict = (NSDictionary *)userInfo;
                [self doLogicCallBack:YES info:dict];
            } else {
                [self doLogicCallBack:NO info:userInfo];
            }
        };
    }
    return self;
}

- (id)initNewGallery:(NSArray *)pictures
             content:(NSString *)content
                city:(int)city {
    if (!pictures) {
        return nil;
    }
    
    self = [super initWithUrl:SERVERUR method:POST session:[[ConfigManager me] getSession].session];
    if (self) {
        [self addParameter:@"action" value:@"gallery_Add"];
        
        NSMutableDictionary *galleryJson = [[NSMutableDictionary alloc] init];
        if (content) {
            [galleryJson setValue:content forKey:@"content"];
        }
        if (city > 0) {
            [galleryJson setValue:[NSString stringWithFormat:@"%d", city] forKey:@"cityId"];
        }
        [galleryJson setValue:pictures forKey:@"pictures"];

        
        NSString *json = nil;
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:galleryJson
                                                           options:(NSJSONWritingOptions)0
                                                             error:&error];
        [galleryJson release];
        
        if (!jsonData) {
            NSLog(@"error: %@", error.localizedDescription);
            return nil;
        } else {
            json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            NSLog(@"%@", json);
            [self addParameter:@"gallery_json" value:json];
            [json release];
        }
        
        self.responseCallbackBlock = ^(bool succeeded, id userInfo) {
            if (succeeded) {
                NSDictionary *dict = (NSDictionary *)userInfo;
                
                NSDictionary *gallery = [dict objectForKey:@"gallery"];
                NSArray *LKs = [gallery objectForKey:@"pictures"];
                
                if (LKs && LKs.count > 0) {
                    for (NSDictionary *pictureLKDict in LKs) {
                        [[MemContainer me] instanceFromDict:pictureLKDict clazz:[GalleryPictureLK class]];
                        if ([pictureLKDict objectForKey:@"picture"]) {
                            [[MemContainer me] instanceFromDict:[pictureLKDict objectForKey:@"picture"]
                                                          clazz:[Picture class]];
                        }
                    }
                }
                
                [self doLogicCallBack:YES info:dict];
            } else {
                [self doLogicCallBack:NO info:userInfo];
            }
        };
    }
    return self;
}

- (id)initNewGallery:(NSString *)galleryId topicId:(NSString *)topicId {

    self = [super initWithUrl:SERVERUR method:POST session:[[ConfigManager me] getSession].session];
    if (self) {
        [self addParameter:@"action" value:@"topic_Relation"];
        [self addParameter:galleryId value:@"gallery_id"];
        [self addParameter:topicId value:@"topic_id"];
        
        self.responseCallbackBlock = ^(bool succeeded, id userInfo) {
            if (succeeded) {
                NSDictionary *dict = (NSDictionary *)userInfo;

                [self doLogicCallBack:YES info:dict];
            } else {
                [self doLogicCallBack:NO info:userInfo];
            }
        };
    }
    return self;
}

//评论刷新
- (id)initNewGCommentForGallery:(long)galleryId
                        replyTo:(NSString *)replyTo
                          voice:(NSData *)voice
                         length:(int)voiceLength
                        content:(NSString *)content
{

    self = [super initWithUrl:SERVERURL method:POST session:[[ConfigManager me] getSession].session];
    if (self)
    {
      //  NSLog(@"%@",self);
        [self addParameter:@"action" value:@"gcomment_Add"];
        
        [self addParameter:@"gallery_id" value:[NSString stringWithFormat:@"%ld", galleryId]];
     //   [self addParameter:@"replyTo" value:[NSString stringWithFormat:@"%@",replyTo]];
        
        NSLog(@"who are you replyTo %@",replyTo);
        
        if (replyTo)
        {
            [self addParameter:@"reply_to" value:[NSString stringWithFormat:@"%@",replyTo]];
            
            NSLog(@"eeeeeeeeeeeee%@",replyTo);
            
        }

        
        
        if (voice && voiceLength > 0)
        {
            [self addParameter:@"voice" value:voice fileName:@"voice.mp3"];
            [self addParameter:@"voice_length" value:[NSString stringWithFormat:@"%d", voiceLength]];
        }
        //chulijian重要
        if (content)
        {
            [self addParameter:@"content" value:content];
            
        }
        
        self.responseCallbackBlock = ^(bool succeeded, id userInfo) {
            if (succeeded) {
                NSDictionary *dict = (NSDictionary *)userInfo;
                [self doLogicCallBack:YES info:dict];
            } else {
                [self doLogicCallBack:NO info:userInfo];
            }
        };
    }
    return self;
}

- (id)initNewLCommentForLesson:(long)lessonId
                       replyTo:(NSString *)replyTo
                         voice:(NSData *)voice
                        length:(int)voiceLength
                       content:(NSString *)content
{
    self = [super initWithUrl:SERVERURL method:POST session:[[ConfigManager me] getSession].session];
    if (self)
    {
        [self addParameter:@"action" value:@"lcomment_Add"];
        [self addParameter:@"lesson_id" value:[NSString stringWithFormat:@"%ld", lessonId]];
        if (voice && voiceLength > 0) {
            [self addParameter:@"voice" value:voice fileName:@"voice.mp3"];
            [self addParameter:@"voice_length" value:[NSString stringWithFormat:@"%d", voiceLength]];
        }
        if (content)
        {
            [self addParameter:@"content" value:content];
        }
        if (replyTo)
        {
            [self addParameter:@"reply_to" value:replyTo];
        }
        self.responseCallbackBlock = ^(bool succeeded, id userInfo) {
            if (succeeded) {
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
