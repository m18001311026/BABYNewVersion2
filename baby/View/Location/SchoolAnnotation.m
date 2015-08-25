//
//  CinemaAnnotation.m
//  kokozu
//
//  Created by nina on 11-7-23.
//  Copyright 2011年 kokozu. All rights reserved.
//

#import "SchoolAnnotation.h"

@implementation SchoolAnnotation

- (NSString *)subtitle {
	return @"";
}

- (NSString *)title {
	return self.name;
}

- (void)dealloc {
    self.name = nil;
    self.address = nil;
    
    [super dealloc];
}

- (id)initWithCoordinate:(CLLocationCoordinate2D)c name:(NSString *)name address:(NSString *)address {
    self = [super init];
    if (self) {
        self.coordinate = c;
        self.name = name;
        self.address = address;
    }
	return self;
}


@end
