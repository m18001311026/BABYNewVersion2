//
//  SchoolTask.m
//  baby
//
//  Created by zhang da on 14-4-5.
//  Copyright (c) 2014年 zhang da. All rights reserved.
//

#import "SchoolTask.h"
#import "School.h"
#import "SchoolPicture.h"
#import "MemContainer.h"

@implementation SchoolTask

- (id)initSchoolList {
    self = [super initWithUrl:SERVERURL method:POST];
    if (self) {
        [self addParameter:@"action" value:@"school_Query"];
        self.responseCallbackBlock = ^(bool succeeded, id userInfo) {
            NSArray *schools = [userInfo objectForKey:@"school"];
            
            if (schools && schools.count > 0) {
                NSMutableArray *schoolIds = [[NSMutableArray alloc] initWithCapacity:0];
                for (NSDictionary *schoolDict in schools) {
                    School *s = (School *)[[MemContainer me] instanceFromDict:schoolDict
                                                                        clazz:[School class]];
                    [schoolIds addObject:@(s._id)];
                }
                [self doLogicCallBack:YES info:[schoolIds autorelease]];
            } else {
                [self doLogicCallBack:YES info:nil];
            }

        };
    }
    return self;
}

- (id)initSchoolDetail:(long)schoolId {
    self = [super initWithUrl:SERVERURL method:POST];
    if (self) {
        [self addParameter:@"action" value:@"school_Query"];
        [self addParameter:@"school_id" value:[NSString stringWithFormat:@"%ld", schoolId]];
        
        self.responseCallbackBlock = ^(bool succeeded, id userInfo) {
            if (succeeded) {
                NSDictionary *schoolDict = [userInfo objectForKey:@"school"];
                [[MemContainer me] instanceFromDict:schoolDict clazz:[School class]];
                NSArray *pictures = [schoolDict objectForKey:@"pictures"];
                if (pictures) {
                    for (NSDictionary *pictureDict in pictures) {
                        [[MemContainer me] instanceFromDict:pictureDict clazz:[SchoolPicture class]];
                    }
                }
                [self doLogicCallBack:YES info:nil];
            } else {
                [self doLogicCallBack:NO info:userInfo];
            }
        };
    }
    return self;
}

@end
