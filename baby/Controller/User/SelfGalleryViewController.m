//
//  AccountViewController.m
//  baby
//
//  Created by zhang da on 14-3-3.
//  Copyright (c) 2014年 zhang da. All rights reserved.
//

#import "SelfGalleryViewController.h"
#import "GalleryViewController.h"
#import "SelfView.h"
#import "GalleryTask.h"
#import "TaskQueue.h"
#import "ConfigManager.h"
#import "Session.h"
#import "ShareManager.h"
#import "Gallery.h"
#import "GalleryPictureLK.h"
#import "AudioPlayer.h"
#import "Picture.h"
#import "EditViewController.h"
#import "UIButtonExtra.h"

#define PAGESIZE 6
#define COL_CNT 3

@interface SelfGalleryViewController ()

@property (nonatomic, assign) int pictureIndex;
@property (nonatomic, assign) long playingGalleryId;
@property (nonatomic, assign) bool isPlayingComment;

@end


@implementation SelfGalleryViewController

- (void)dealloc {
    [galleries release];
    [galleryView release];

    [super dealloc];
}

- (id)init {
    self = [super init];
    if (self) {
        galleryTable = [[PullTableView alloc] initWithFrame:CGRectMake(0, 44, 320, screentContentHeight - 44)
                                                      style:UITableViewStylePlain];
        galleryTable.pullDelegate = self;
        galleryTable.delegate = self;
        galleryTable.dataSource = self;
        [galleryTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [self.view addSubview:galleryTable];
        galleryTable.pullBackgroundColor = [Shared bbWhite];
        [galleryTable release];

        header = [[SelfView alloc] initWithFrame:CGRectMake(0, 0, 320, 220)
                                            forUser:[ConfigManager me].userId];
        header.delegate = self;
        [galleryTable setTableHeaderView:header];
        [header updateLayout];
        [header release];
        
        galleryView = [[SimpleSegment alloc] initWithFrame:CGRectMake(5, 5, 310, 29)
                                                    titles:@[@"缩略", @"详细"]];
        galleryView.selectedTextColor = [UIColor whiteColor];
        galleryView.selectedBackgoundColor = [UIColor colorWithRed:234/255.0 green:166/255.0 blue:31/255.0 alpha:1];
        galleryView.normalTextColor = [UIColor colorWithRed:234/255.0 green:166/255.0 blue:31/255.0 alpha:1];
        galleryView.normalBackgroundColor = [UIColor whiteColor];
        galleryView.borderColor = [UIColor colorWithRed:234/255.0 green:166/255.0 blue:31/255.0 alpha:1];
        galleryView.delegate = self;
        galleryView.layer.cornerRadius = 2;
        [galleryView updateLayout];
        
        UIButton *back = [UIButton buttonWithCustomStyle:CustomButtonStyleBack];
        [back addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        [bbTopbar addSubview:back];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // Custom initialization
    self.view.backgroundColor = [Shared bbWhite];
    
    galleries = [[NSMutableArray alloc] initWithCapacity:0];
    currentPage = 1;
    [self loadGallery];
    
    [self setViewTitle:@"我的画"];
    bbTopbar.backgroundColor = [UIColor colorWithRed:234/255.0 green:166/255.0 blue:31/255.0 alpha:1];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setPlayingGalleryId:(long)playingGallery {
    if (_playingGalleryId != playingGallery) {
        _playingGalleryId = playingGallery;
    }
    
    if (_playingGalleryId > 0) {
        [self startPlayVoice];
    } else {
        [self stopPlayVoice];
    }
}


#pragma ui event
- (void)back {
    [ctr popViewControllerAnimated:YES];
}

- (void)segmentSelected:(int)index {
    [galleryTable reloadData];
    [self loadGalleryDetail];
}

- (void)loadGallery {
    if ([ConfigManager me].userId < 1) {
        [UI showAlert:@"请先登录"];
        [galleryTable stopLoading];
        return;
    }
    
    header.userId = [ConfigManager me].userId;
    [header updateLayout];
    
    GalleryTask *task = [[GalleryTask alloc] initUserGalleryList:[ConfigManager me].userId
                                                            page:currentPage
                                                           count:PAGESIZE];
    task.logicCallbackBlock = ^(bool succeeded, id userInfo) {
        if (currentPage == 1) {
            [galleries removeAllObjects];
        }
        
        if (succeeded) {
            [galleries addObjectsFromArray:(NSArray *)userInfo];
            if ([((NSArray *)userInfo) count] < PAGESIZE) {
                galleryTable.hasMore = NO;
            } else {
                galleryTable.hasMore = YES;
            }
        }
        
        [galleryTable reloadData];
        [galleryTable stopLoading];
    };
    [TaskQueue addTaskToQueue:task];
    [task release];
}

- (void)startPlayVoice {
    if (self.playingGalleryId > 0) {
        if (self.isPlayingComment) {
            Gallery *g = [Gallery getGalleryWithId:self.playingGalleryId];
            [Voice getVoice:g.commentVoice
                   callback:^(NSString *url, NSData *voice) {
                       if ([url isEqualToString:g.commentVoice] && voice) {
                           [AudioPlayer startPlayData:voice finished:^{
                               self.playingGalleryId = 0;
                               [galleryTable reloadData];
                           }];
                       } else {
                           self.playingGalleryId = 0;
                           [galleryTable reloadData];
                       }
                   }];
        } else {
            NSArray *gPictures = [GalleryPictureLK getPicturesForGallery:self.playingGalleryId];
            if (gPictures.count > self.pictureIndex) {
                GalleryPictureLK *lk = [gPictures objectAtIndex:self.pictureIndex];
                Picture *pic = [Picture getPictureWithId:lk.pictureId];
                
                if (pic.voice) {
                    [Voice getVoice:pic.voice
                           callback:^(NSString *url, NSData *voice) {
                               if ([url isEqualToString:pic.voice] && voice) {
                                   [AudioPlayer startPlayData:voice finished:^{
                                       self.playingGalleryId = 0;
                                       [galleryTable reloadData];
                                   }];
                               } else {
                                   self.playingGalleryId = 0;
                                   [galleryTable reloadData];
                               }
                           }];
                }
            } else {
                [UI showAlert:@"请等待数据加载完毕"];
                [self playVoiceForGallery:self.playingGalleryId atIndex:0 isComment:self.isPlayingComment];
            }
        }
    }
}

- (void)stopPlayVoice {
    [AudioPlayer stopPlay];
}

- (void)loadGalleryDetail {
    if (galleryView.selectedIndex == 1) {
        NSArray *cells = [galleryTable visibleCells];
        for (GalleryCell *cell in cells) {
            [cell loadFullGallery];
        }
    }
}


#pragma table view section
- (void)configCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    if (galleryView.selectedIndex == 0) {
        for (int i = 0; i < COL_CNT; i++) {
            GridGalleryCell *gCell = (GridGalleryCell *)cell;
            gCell.row = indexPath.row;
            if (indexPath.row*COL_CNT + i < galleries.count) {
                long gId = [[galleries objectAtIndex:indexPath.row*COL_CNT + i] longValue];
                Gallery *g = [Gallery getGalleryWithId:gId];
                [gCell setImagePath:g.cover atCol:i];
            } else {
                [gCell setImagePath:nil atCol:i];
            }
        }
    } else {
        if (galleries.count > indexPath.row) {
            GalleryCell *gCell = (GalleryCell *)cell;
            
            gCell.galleryId = [[galleries objectAtIndex:indexPath.row] longValue];
            gCell.playingComment = (self.playingGalleryId == gCell.galleryId && self.isPlayingComment);
            gCell.playingIntro = (self.playingGalleryId == gCell.galleryId && !self.isPlayingComment);
            [gCell updateLayout];
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (galleryView.selectedIndex == 0) {
        return galleries.count/COL_CNT + (galleries.count%COL_CNT>0? 1: 0);
    } else {
        return galleries.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (galleryView.selectedIndex == 0) {
        //缩略
        static NSString *cellId = @"gridgallerycell";
        GridGalleryCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[[GridGalleryCell alloc] initWithStyle:UITableViewCellStyleDefault
                                           reuseIdentifier:cellId
                                                    colCnt:COL_CNT] autorelease];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;
        }
        [self configCell:cell atIndexPath:indexPath];
        return cell;
    } else {
        //详细
        static NSString *cellId = @"gallerycell";
        GalleryCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[[GalleryCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:cellId] autorelease];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.userInfoDelegate = self;
            cell.delegate = self;
        }
        [self configCell:cell atIndexPath:indexPath];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (galleryView.selectedIndex == 0) {
        return 320.0f/COL_CNT;
    } else {
        if (galleries.count > indexPath.row) {
            long galleryId = [[galleries objectAtIndex:indexPath.row] longValue];
            Gallery *g = [Gallery getGalleryWithId:galleryId];
            return [GalleryCell cellHeight:g.content];
        }
        return 375;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (galleryView.selectedIndex == 1 && galleries.count > indexPath.row) {
        NSNumber *g = [galleries objectAtIndex:indexPath.row];
        
        GalleryViewController *gVC = [[GalleryViewController alloc] initWithGallery:[g longValue]];
        [ctr pushViewController:gVC animation:ViewSwitchAnimationBounce];
        [gVC release];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *bg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 31)];
    bg.backgroundColor = [Shared bbWhite];
    [bg addSubview:galleryView];
    return [bg autorelease];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 39;
}


#pragma mark pull table view delegate
- (void)pullTableViewDidTriggerRefresh:(PullTableView*)pullTableView {
    currentPage = 1;
    [self loadGallery];
}

- (void)pullTableViewDidTriggerLoadMore:(PullTableView*)pullTableView {
    currentPage ++;
    [self loadGallery];
}


#pragma mark uiscrollview delegate
// called on finger up if the user dragged. decelerate is true if it will continue moving afterwards
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    NSLog(@"1");
    [self loadGalleryDetail];
}

// called on finger up as we are moving
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSLog(@"2");
    [self loadGalleryDetail];
}


#pragma UserVoiceInfoViewDelegate
- (void)showUserDetail:(long)userId { }

- (void)playVoiceForGallery:(long)galleryId atIndex:(int)page isComment:(bool)isComment {
    [self stopPlayVoice];
    
    if (self.playingGalleryId == galleryId && self.isPlayingComment == isComment) {
        self.playingGalleryId = 0;
    } else {
        //set playing comment before set playing gallery id
        self.isPlayingComment = isComment;
        self.playingGalleryId = galleryId;
    }
    
    self.pictureIndex = page;
    [galleryTable reloadData];
}


#pragma mark grid gallery view cell
- (void)galleryTouchedAtRow:(int)row andCol:(int)col {
    if (galleryView.selectedIndex == 0 && galleries.count > row*COL_CNT + col) {
        NSNumber *g = [galleries objectAtIndex:row*COL_CNT + col];
        
        GalleryViewController *gVC = [[GalleryViewController alloc] initWithGallery:[g longValue]];
        [ctr pushViewController:gVC animation:ViewSwitchAnimationBounce];
        [gVC release];
    }
}


#pragma mark gallery cell delegate
- (void)deleteGallery:(long)galleryId {
    GalleryTask *task = [[GalleryTask alloc] initDeleteGallery:galleryId];
    task.logicCallbackBlock = ^(bool successful, id userInfo) {
        if (successful) {
            [galleries removeObject:@(galleryId)];
            [galleryTable reloadData];
            [UI showAlert:@"删除成功"];
        }
    };
    [TaskQueue addTaskToQueue:task];
    [task release];
}

- (void)shareGallery:(long)galleryId {
    Gallery *g = [Gallery getGalleryWithId:galleryId];
    if (g) {
        UIImage *local = [IMG getImageFromDisk:g.cover];
        if (local) {
            
            //宝贝计画
            [[ShareManager me] showShareMenuWithTitle:@"  "
                                              content:g.content
                                                image:local
                                              pageUrl:[NSString stringWithFormat:GALLERY_PAGE, galleryId]
                                             soundUrl:g.introVoice];
        } else {
            [[ShareManager me] showShareMenuWithTitle:@"  "
                                              content:g.content
                                             imageUrl:g.cover
                                              pageUrl:[NSString stringWithFormat:GALLERY_PAGE, galleryId]
                                             soundUrl:g.introVoice];
        }
    } else {
        [UI showAlert:@"图片详情尚未加载完成"];
    }
}


#pragma mark accountview delegate
- (void)editUserDetail:(SelfView *)caller {
    EditViewController *eCtr = [[EditViewController alloc] init];
    [ctr pushViewController:eCtr animation:ViewSwitchAnimationBounce];
    [eCtr release];
}


@end
