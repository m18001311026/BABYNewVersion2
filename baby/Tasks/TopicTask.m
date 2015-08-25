//
//  TopicTask.m
//  baby
//
//  Created by zhang da on 14-4-15.
//  Copyright (c) 2014年 zhang da. All rights reserved.
//

#import "TopicTask.h"
#import "MemContainer.h"
#import "Topic.h"

@implementation TopicTask

- (id)initTopicListAtPage:(int)page count:(int)count {
    self = [super initWithUrl:SERVERURL method:POST];
    if (self) {
        [self addParameter:@"action" value:@"topic_Hot"];
        [self addParameter:@"page" value:[NSString stringWithFormat:@"%d", page]];
        [self addParameter:@"count" value:[NSString stringWithFormat:@"%d", count]];

        self.responseCallbackBlock = ^(bool succeeded, id userInfo) {
            if (succeeded) {
                NSDictionary *dict = (NSDictionary *)userInfo;
                NSArray *topics = [userInfo objectForKey:@"topics"];
                
                if (topics && topics.count > 0) {
                    NSMutableArray *normalTopics = [[NSMutableArray alloc] initWithCapacity:0];
                    NSMutableArray *simpleTopics = [[NSMutableArray alloc] initWithCapacity:0];

                    for (NSDictionary *topicDict in topics) {
                        Topic *t = (Topic *)[[MemContainer me] instanceFromDict:topicDict
                                                                          clazz:[Topic class]];
                        if (t.priority > 0) {
                            [normalTopics addObject:t];
                        } else {
                            [simpleTopics addObject:t];
                        }
                    }
                    NSDictionary *ret = [NSDictionary dictionaryWithObjectsAndKeys:
                                         normalTopics, @"normal", simpleTopics, @"simple", nil];
                    [normalTopics release];
                    [simpleTopics release];
                    
                    [self doLogicCallBack:YES info:ret];
                } else {
                    [self doLogicCallBack:YES info:dict];
                }
            } else {
                [self doLogicCallBack:NO info:userInfo];
            }
        };
    }
    return self;
}


- (id)initTopicList {
    self = [super initWithUrl:SERVERUR method:POST];
    if (self) {
        [self addParameter:@"action" value:@"topic_Hot"];
        
        self.responseCallbackBlock = ^(bool succeeded, id userInfo) {
            if (succeeded) {
                NSDictionary *dict = (NSDictionary *)userInfo;
                NSArray *topics = [userInfo objectForKey:@"topics"];
                
                if (topics && topics.count > 0) {
                    NSMutableArray *normalTopics = [[NSMutableArray alloc] initWithCapacity:0];
                    NSMutableArray *simpleTopics = [[NSMutableArray alloc] initWithCapacity:0];
                    
                    for (NSDictionary *topicDict in topics) {
                        Topic *t = (Topic *)[[MemContainer me] instanceFromDict:topicDict
                                                                          clazz:[Topic class]];
                        if (t.priority > 0) {
                            [normalTopics addObject:t];
                        } else {
                            [simpleTopics addObject:t];
                        }
                    }
                    NSDictionary *ret = [NSDictionary dictionaryWithObjectsAndKeys:
                                         normalTopics, @"normal", simpleTopics, @"simple", nil];
                    [normalTopics release];
                    [simpleTopics release];
                    
                    [self doLogicCallBack:YES info:ret];
                } else {
                    [self doLogicCallBack:YES info:dict];
                }
            } else {
                [self doLogicCallBack:NO info:userInfo];
            }
        };
    }
    return self;
}


@end
