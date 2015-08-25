//
//  BookingTask.h
//  baby
//
//  Created by zhang da on 14-5-5.
//  Copyright (c) 2014年 zhang da. All rights reserved.
//

#import "BBNetworkTask.h"

@interface BookingTask : BBNetworkTask

- (id)initBooking:(NSDate *)time school:(long)schoolId name:(NSString *)name mobile:(NSString *)mobile;

@end
