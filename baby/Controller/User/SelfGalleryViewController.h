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
#import "UserVoiceInfoView.h"
#import "GridGalleryCell.h"
#import "GalleryCell.h"
#import "SelfView.h"


@interface SelfGalleryViewController : BBViewController
<UITableViewDataSource, UITableViewDelegate, SimpleSegmentDelegate, PullTableViewDelegate,
UserVoiceInfoViewDelegate, GridGalleryCellDelegate, GalleryCellDelegate, AccountViewDelegate>{
    
    int currentPage;
    NSMutableArray *galleries;

    PullTableView *galleryTable;
    SimpleSegment *galleryView;
    SelfView *header;
    
}

@end
