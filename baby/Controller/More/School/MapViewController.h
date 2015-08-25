//
//  MapViewController.h
//  baby
//
//  Created by zhang da on 14-5-8.
//  Copyright (c) 2014年 zhang da. All rights reserved.
//

#import "BBViewController.h"
#import <MapKit/MapKit.h>

@class School;

@interface MapViewController : BBViewController <MKMapViewDelegate> {
    
    MKMapView *mapView;

}

- (id)initWithSchool:(School *)school;

@end
