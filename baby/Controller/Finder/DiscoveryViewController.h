//
//  AccountViewController.h
//  baby
//
//  Created by zhang da on 14-3-3.
//  Copyright (c) 2014年 zhang da. All rights reserved.
//

#import "BBViewController.h"
#import "PullTableView.h"
#import "SimpleSegment.h"
#import "GridGalleryCell.h"
#import "SelfView.h"
#import "ImagePlayerView.h"


@interface DiscoveryViewController : BBViewController
<UITableViewDataSource, UITableViewDelegate, SimpleSegmentDelegate, PullTableViewDelegate,
GridGalleryCellDelegate, ImagePlayerViewDelegate>{
    
    int currentPage;
    NSMutableArray *galleries;
    NSMutableArray *activities;

    PullTableView *galleryTable;
    SimpleSegment *cityView;
    ImagePlayerView *banner;
    
}

@end
