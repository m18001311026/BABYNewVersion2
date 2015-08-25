//
//  HomeViewController.h
//  baby
//
//  Created by zhang da on 14-3-3.
//  Copyright (c) 2014年 zhang da. All rights reserved.
//

#import "TabbarSubviewController.h"
#import "PullTableView.h"
#import "SimpleSegment.h"
#import "GalleryCell.h"
#import "UserVoiceInfoView.h"
#import "MoreViewController.h"
#import "AppDelegate.h"


@interface HomeViewController : TabbarSubviewController
<UITableViewDataSource, UITableViewDelegate, PullTableViewDelegate, SimpleSegmentDelegate,
UIScrollViewDelegate, UserVoiceInfoViewDelegate, GalleryCellDelegate>{
    MoreViewController *moreCtr;
    UIPanGestureRecognizer *panGes;
    
    int currentPage;
    PullTableView *galleryTable;
    NSMutableArray *galleries;
    SimpleSegment *galleryType;
}


@end
