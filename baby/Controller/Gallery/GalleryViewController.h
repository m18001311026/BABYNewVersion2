//
//  GalleryViewController.h
//  baby
//
//  Created by zhang da on 14-3-6.
//  Copyright (c) 2014年 zhang da. All rights reserved.
//

#import "BBViewController.h"
#import "PullTableView.h"
#import "EditView.h"
#import "GCommentCell.h"
#import "UserVoiceInfoView.h"
#import "GalleryCell.h"

@interface GalleryViewController : BBViewController
<UITableViewDataSource, UITableViewDelegate, GalleryCellDelegate,
PullTableViewDelegate, EditViewDelegate, GCommentCellDelegate, UserVoiceInfoViewDelegate>
{
    
    PullTableView *commentTable;
    EditView *editView;
    NSMutableArray *comments;
    int currentPage;
    UILabel *contentLabel, *voiceLength;

}

@property (nonatomic, assign) long galleryId;

- (id)initWithGallery:(long)galleryId;

@end
