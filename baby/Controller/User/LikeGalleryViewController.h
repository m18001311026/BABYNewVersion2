//
//  UserViewController.h
//  baby
//
//  Created by zhang da on 14-3-23.
//  Copyright (c) 2014年 zhang da. All rights reserved.
//

#import "BBViewController.h"
#import "PullTableView.h"
#import "UserVoiceInfoView.h"
#import "GalleryCell.h"

@interface LikeGalleryViewController : BBViewController
<UITableViewDataSource, UITableViewDelegate, GalleryCellDelegate, PullTableViewDelegate, UserVoiceInfoViewDelegate>{
    
    int currentPage;
    NSMutableArray *galleries;
    PullTableView *galleryTable;
    
}

@end
