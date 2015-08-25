//
//  City.h
//  baby
//
//  Created by zhang da on 14-3-2.
//  Copyright (c) 2014年 zhang da. All rights reserved.
//

#import "Model.h"

@interface City : Model

@property (nonatomic, assign) long _id;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, assign) int type;

@end
