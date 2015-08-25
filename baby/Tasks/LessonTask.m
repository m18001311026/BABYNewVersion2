//
//  LessonTask.m
//  baby
//
//  Created by zhang da on 14-3-31.
//  Copyright (c) 2014年 zhang da. All rights reserved.
//

#import "LessonTask.h"
#import "MemContainer.h"
#import "Lesson.h"
#import "User.h"
#import "LComment.h"

#import "ConfigManager.h"
#import "Session.h"

@implementation LessonTask

- (void)dealloc {
    
    [super dealloc];
}

- (id)initGetLesson:(int)type age:(int)age page:(int)page count:(int)count {
    self = [super initWithUrl:SERVERURL method:POST];
    if (self) {
        [self addParameter:@"action" value:@"lesson_Query"];
        [self addParameter:@"type" value:[NSString stringWithFormat:@"%d", type]];
        [self addParameter:@"age" value:[NSString stringWithFormat:@"%d", age]];
        [self addParameter:@"page" value:[NSString stringWithFormat:@"%d", page]];
        [self addParameter:@"count" value:[NSString stringWithFormat:@"%d", count]];
        
        self.responseCallbackBlock = ^(bool succeeded, id userInfo) {
            if (succeeded) {
                NSArray *lessons = [userInfo objectForKey:@"lessons"];
                
                if (lessons && lessons.count > 0) {
                    NSMutableArray *lessonIds = [[NSMutableArray alloc] initWithCapacity:0];
                    for (NSDictionary *lessonDict in lessons) {
                        Lesson *l = (Lesson *)[[MemContainer me] instanceFromDict:lessonDict
                                                                            clazz:[Lesson class]];
                        [lessonIds addObject:@(l._id)];
                    }
                    [self doLogicCallBack:YES info:[lessonIds autorelease]];
                } else {
                    [self doLogicCallBack:YES info:nil];
                }
            } else {
                [self doLogicCallBack:NO info:userInfo];
            }
        };
    }
    return self;
}

- (id)initLCommentList:(long)lessonId page:(int)page count:(int)count {
    self = [super initWithUrl:SERVERURL method:POST];
    if (self) {
        [self addParameter:@"action" value:@"lcomment_Query"];
        [self addParameter:@"lesson_id" value:[NSString stringWithFormat:@"%ld", lessonId]];
        [self addParameter:@"page" value:[NSString stringWithFormat:@"%d", page]];
        [self addParameter:@"count" value:[NSString stringWithFormat:@"%d", count]];
        
        self.responseCallbackBlock = ^(bool succeeded, id userInfo) {
            if (succeeded) {
                NSDictionary *dict = (NSDictionary *)userInfo;
                NSArray *comments = [dict objectForKey:@"comments"];
                
                if (comments && comments.count > 0) {
                    NSMutableArray *commentIds = [[NSMutableArray alloc] initWithCapacity:0];
                    for (NSDictionary *commentDict in comments) {
                        NSDictionary *userDict = [commentDict objectForKey:@"user"];
                        [[MemContainer me] instanceFromDict:userDict clazz:[User class]];
                        
                        LComment *g = (LComment *)[[MemContainer me] instanceFromDict:commentDict clazz:[LComment class]];
                        [commentIds addObject:@(g._id)];
                    }
                    [self doLogicCallBack:YES info:[commentIds autorelease]];
                } else {
                    [self doLogicCallBack:YES info:nil];
                }
            } else {
                [self doLogicCallBack:NO info:userInfo];
            }
        };
    }
    return self;

}

- (id)initSimilarLesson:(int)lessonId page:(int)page count:(int)count {
    self = [super initWithUrl:SERVERURL method:POST];
    if (self) {
        [self addParameter:@"action" value:@"lesson_Similar"];
        [self addParameter:@"lesson_id" value:[NSString stringWithFormat:@"%d", lessonId]];
        [self addParameter:@"page" value:[NSString stringWithFormat:@"%d", page]];
        [self addParameter:@"count" value:[NSString stringWithFormat:@"%d", count]];
        
        self.responseCallbackBlock = ^(bool succeeded, id userInfo) {
            if (succeeded) {
                NSArray *lessons = [userInfo objectForKey:@"lessons"];
                
                if (lessons && lessons.count > 0) {
                    NSMutableArray *lessonIds = [[NSMutableArray alloc] initWithCapacity:0];
                    for (NSDictionary *lessonDict in lessons) {
                        Lesson *l = (Lesson *)[[MemContainer me] instanceFromDict:lessonDict
                                                                            clazz:[Lesson class]];
                        [lessonIds addObject:@(l._id)];
                    }
                    [self doLogicCallBack:YES info:[lessonIds autorelease]];
                } else {
                    [self doLogicCallBack:YES info:nil];
                }
            } else {
                [self doLogicCallBack:NO info:userInfo];
            }
        };
    }
    return self;
}

- (id)initDeleteLComment:(long)commentId {
    self = [super initWithUrl:SERVERURL method:POST session:[[ConfigManager me] getSession].session];
    if (self) {
        [self addParameter:@"action" value:@"lcomment_Delete"];
        [self addParameter:@"comment_id" value:[NSString stringWithFormat:@"%ld", commentId]];
        
        self.responseCallbackBlock = ^(bool succeeded, id userInfo) {
            if (succeeded) {
                [self doLogicCallBack:YES info:nil];
            } else {
                [self doLogicCallBack:NO info:userInfo];
            }
        };
    }
    return self;
}

- (id)initRecommendLessonList {
    self = [super initWithUrl:SERVERURL method:POST];
    if (self) {
        [self addParameter:@"action" value:@"lesson_Recommend"];
        
        self.responseCallbackBlock = ^(bool succeeded, id userInfo) {
            if (succeeded) {
                NSArray *lessons = [userInfo objectForKey:@"lessons"];
                
                if (lessons && lessons.count > 0) {
                    NSMutableArray *lessonList = [[NSMutableArray alloc] initWithCapacity:0];
                    for (NSDictionary *lessonDict in lessons) {
                        Lesson *l = (Lesson *)[[MemContainer me] instanceFromDict:lessonDict
                                                                            clazz:[Lesson class]];
                        [lessonList addObject:l];
                    }
                    [self doLogicCallBack:YES info:[lessonList autorelease]];
                } else {
                    [self doLogicCallBack:YES info:nil];
                }
            } else {
                [self doLogicCallBack:NO info:userInfo];
            }
        };
    }
    return self;
}


@end
