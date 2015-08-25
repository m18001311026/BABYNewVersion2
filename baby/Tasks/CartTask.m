//
//  CartTask.m
//  baby
//
//  Created by zhang da on 14-3-31.
//  Copyright (c) 2014年 zhang da. All rights reserved.
//

#import "CartTask.h"
#import "ConfigManager.h"
#import "Session.h"
#import "Lesson.h"
#import "UserLessonLK.h"
#import "MemContainer.h"

@implementation CartTask

- (void)dealloc {
    
    [super dealloc];
}

- (id)initEditLesson:(long)lessonId relation:(bool)relation {
    self = [super initWithUrl:SERVERURL method:POST session:[[ConfigManager me] getSession].session];
    if (self) {
        [self addParameter:@"action" value:@"lesson_Relation"];
        [self addParameter:@"lesson_id" value:[NSString stringWithFormat:@"%ld", lessonId]];
        [self addParameter:@"relation" value:[NSString stringWithFormat:@"%d", relation]];
        
        self.responseCallbackBlock = ^(bool succeeded, id userInfo) {
            if (succeeded) {
                UserLessonLK *lk = [UserLessonLK getUserLessonLK:[[ConfigManager me] getSession].userId
                                                          lesson:lessonId];
                lk.status = relation;
                
                [self doLogicCallBack:YES info:nil];
            } else {
                [self doLogicCallBack:NO info:userInfo];
            }
        };
    }
    return self;

}

- (id)initLessonRelationQuery:(long)lessonId {
    self = [super initWithUrl:SERVERURL method:POST session:[[ConfigManager me] getSession].session];
    if (self) {
        [self addParameter:@"action" value:@"lesson_Relation"];
        [self addParameter:@"lesson_id" value:[NSString stringWithFormat:@"%ld", lessonId]];
        
        self.responseCallbackBlock = ^(bool succeeded, id userInfo) {
            if (succeeded) {
                int relation = [[userInfo objectForKey:@"relation"] intValue];
                
                UserLessonLK *lk = [UserLessonLK getUserLessonLK:[[ConfigManager me] getSession].userId
                                                          lesson:lessonId];
                if (!lk) {
                    lk = [[UserLessonLK alloc] init];
                    lk.userId = [[ConfigManager me] getSession].userId;
                    lk.lessonId = lessonId;
                    lk.status = relation;
                    [[MemContainer me] putObject:lk];
                    [lk release];
                } else {
                    lk.status = relation;
                }
                
                [self doLogicCallBack:YES info:@(relation)];
            } else {
                [self doLogicCallBack:NO info:userInfo];
            }
        };
    }
    return self;
}

- (id)initLessonCart {
    self = [super initWithUrl:SERVERURL method:POST session:[[ConfigManager me] getSession].session];
    if (self) {
        [self addParameter:@"action" value:@"lesson_Cart"];
        
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

@end
