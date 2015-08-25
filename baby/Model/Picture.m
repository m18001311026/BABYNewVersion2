//
//  Picture.m
//  baby
//
//  Created by zhang da on 14-3-9.
//  Copyright (c) 2014年 zhang da. All rights reserved.
//

#import "Picture.h"
#import "MemContainer.h"

@implementation Picture

@dynamic _id, voice, voiceLength, imageSmall, imageMid, imageBig, userId, createTime;

- (void)dealloc
{
    self.localImage = nil;
    self.localVoice = nil;
    
    [super dealloc];
}

- (void)nnnnn:(long)userId
{
   
    NSLog(@"%ld",self.userId);

}

+ (NSString *)primaryKey
{
    
    return @"_id";
}

+ (NSDictionary *)mapping {
    static NSDictionary *map = nil;
    if (!map) {
        map = [@{
                 @"_id": @"id"
                 } retain];
    }
    return map;
}

+ (Picture *)getPictureWithId:(long)_id
{
    return (Picture *)[[MemContainer me] getObject:[NSPredicate predicateWithFormat:@"_id = %ld", _id]
                                             clazz:[Picture class]];
    
}
- (long)showUserId
{
    NSLog(@"iiiiiiiiiiiiiiiiiii%ld",self.userId);

    return self.userId;
}

@end
