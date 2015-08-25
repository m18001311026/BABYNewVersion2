//
//  CinemaAnnotation.h
//  kokozu
//
//  Created by  nina on 11-7-23.
//  Copyright 2011年 kokozu. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface SchoolAnnotation : NSObject <MKAnnotation> {

}

@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *address;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

- (id)initWithCoordinate:(CLLocationCoordinate2D)c name:(NSString *)name address:(NSString *)address;

@end