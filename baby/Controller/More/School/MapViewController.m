//
//  MapViewController.m
//  baby
//
//  Created by zhang da on 14-5-8.
//  Copyright (c) 2014年 zhang da. All rights reserved.
//

#import "MapViewController.h"
#import "UIButtonExtra.h"
#import "SchoolAnnotation.h"
#import "School.h"

@interface MapViewController ()

@end

@implementation MapViewController

- (void)dealloc {
    
    [super dealloc];
}

- (id)initWithSchool:(School *)school {
    self = [super init];
    if (self) {
        mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 44, 320, screentContentHeight - 44)];
        mapView.mapType = MKMapTypeStandard;
        mapView.exclusiveTouch = NO;
        [self.view addSubview:mapView];
        [mapView release];
        
        UIButton *back = [UIButton buttonWithCustomStyle:CustomButtonStyleBack];
        [back addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        [bbTopbar addSubview:back];
        
        //set region
        double latitude = [school.latitude doubleValue], longitude = [school.longitude doubleValue];
        MKCoordinateRegion region;
        region.center.latitude = latitude;
        region.center.longitude = longitude;
        region.span.latitudeDelta = 0.01;
        region.span.longitudeDelta = 0.01;
        
        if (region.center.latitude < -90 || region.center.latitude > 90) {
            region.center.latitude = 0;
        }
        if (region.center.longitude < -180 || region.center.longitude > 180) {
            region.center.longitude = 0;
        }
        if (region.span.latitudeDelta <= 0) {
            region.span.latitudeDelta = 0.01;
        }
        if (region.span.longitudeDelta <=0 ) {
            region.span.longitudeDelta = 0.01;
        }
        [mapView setRegion:region animated:YES];
        
        // set pin annotaiton
        CLLocationCoordinate2D theCoordinate;
        theCoordinate.latitude = latitude;
        theCoordinate.longitude = longitude;
        
        SchoolAnnotation *flag = [[SchoolAnnotation alloc] initWithCoordinate:theCoordinate
                                                                         name:school.title
                                                                      address:school.address];
        [mapView addAnnotation:flag];
        [flag release];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setViewTitle:@"分校位置"];
    bbTopbar.backgroundColor = [UIColor colorWithRed:234/255.0 green:166/255.0 blue:31/255.0 alpha:1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma ui event
- (void)back {
    [ctr popViewControllerAnimated:YES];
}


@end
