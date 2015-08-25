//
//  UserViewController.m
//  baby
//
//  Created by zhang da on 14-3-23.
//  Copyright (c) 2014年 zhang da. All rights reserved.
//

#import "UserViewController.h"
#import "GalleryCell.h"
#import "GalleryViewController.h"
#import "UserView.h"
#import "UIButtonExtra.h"
#import "ConfigManager.h"
#import "Session.h"
#import "LKTask.h"
#import "GalleryTask.h"
#import "UserTask.h"
#import "TaskQueue.h"
#import "Picture.h"
#import "Gallery.h"
#import "GalleryPictureLK.h"
#import "AudioPlayer.h"
#import "User.h"
#import "FanViewController.h"
#import "FriendViewController.h"


#define PAGESIZE 5

@interface UserViewController ()

@property (nonatomic, assign) int pictureIndex;
@property (nonatomic, assign) long playingGalleryId;
@property (nonatomic, assign) bool isPlayingComment;

@end


@implementation UserViewController

- (void)dealloc
{
    [galleries release];

    [super dealloc];
}

- (id)initWithUser:(long)userId {
    self = [super init];
    if (self) {
        self.userId = userId;
        
        galleryTable = [[PullTableView alloc] initWithFrame:CGRectMake(0, 44, 320, screentContentHeight - 44)
                                                      style:UITableViewStylePlain];
        galleryTable.delegate = self;
        galleryTable.dataSource = self;
        galleryTable.pullDelegate = self;
        galleryTable.pullBackgroundColor = [Shared bbWhite];
        [galleryTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [self.view addSubview:galleryTable];
        [galleryTable setContentInset:UIEdgeInsetsMake(0, 0, 44, 0)];
        [galleryTable release];
        
        UserView *header = [[UserView alloc] initWithFrame:CGRectMake(0, 0, 320, 220)
                                                         forUser:userId];
        header.delegate = self;
        [header updateLayout];
        [galleryTable setTableHeaderView:header];
        [header release];
    }
    return self;
}


- (void)viewWillAppear:(BOOL)animated
{
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(userBtnTouched) name:@"attentionBtnDown" object:nil];
    NSLog(@"xxxxxxxxxxxxxxxxxxxxxx-01");
    
}

- (void)userBtnTouched
{

    NSLog(@"yyyyyyyyyyyyyyyyyyyyy-01");
    NSLog(@"通知已接收");
    
    

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"yyyyyyyyyyyyyyyyyyyyy-01");

    self.view.backgroundColor = [UIColor whiteColor];
    
    galleries = [[NSMutableArray alloc] initWithCapacity:0];
    currentPage = 1;
    [self loadGallery];
    
    [self setViewTitle:@"我的"];
    bbTopbar.backgroundColor = [UIColor colorWithRed:234/255.0 green:166/255.0 blue:31/255.0 alpha:1];
    
    UIButton *back = [UIButton buttonWithCustomStyle:CustomButtonStyleBack];
    [back addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [bbTopbar addSubview:back];

    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(userBtnTouched) name:@"attentionBtnDown" object:nil];
    
    NSLog(@"nishiwodexiaopengguo%@",galleries);

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (userFlags.initAppear)
    {
        [self loadUserDetail];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [AudioPlayer stopPlay];
}

- (void)setPlayingGalleryId:(long)playingGallery
{
    if (_playingGalleryId != playingGallery)
    {
        _playingGalleryId = playingGallery;
        
      //  NSLog(@"playingGalleryId%ld",_playingGalleryId);
        
        
    }
    
    if (_playingGalleryId > 0)
    {
        [self startPlayVoice];
    }
    else
    {
        [self stopPlayVoice];
    }
}


#pragma mark ui event
- (void)back
{
    [ctr popViewControllerAnimated:YES];
}

- (void)loadUserDetail
{
    User *user = [User getUserWithId:self.userId];
    if (!user) {
        UserTask *task = [[UserTask alloc] initUserDetail:self.userId];
        task.logicCallbackBlock = ^(bool successful, id userInfo) {
            if (successful) {
                User *user = [User getUserWithId:self.userId];
                [self setViewTitle:user.showName];
            }
        };
        [TaskQueue addTaskToQueue:task];
        [task release];
    } else {
        [self setViewTitle:user.showName];
    }
}

- (void)loadGallery
{
    GalleryTask *task = [[GalleryTask alloc] initUserGalleryList:self.userId
page:currentPage count:PAGESIZE];
    task.logicCallbackBlock = ^(bool succeeded, id userInfo)
    {
        if (currentPage == 1)
        {
            [galleries removeAllObjects];
        }
        
        if (succeeded)
        {
            [galleries addObjectsFromArray:(NSArray *)userInfo];
            NSLog(@"nishiwodexiaopengguo%@",galleries);

            if ([((NSArray *)userInfo) count] < PAGESIZE)
            {
                galleryTable.hasMore = NO;
            }
            else
            {
                galleryTable.hasMore = YES;
            }
            NSLog(@"nishiwodexiaopengguo%@",galleries);

        }
        
        [galleryTable reloadData];
        [galleryTable stopLoading];
    };
    [TaskQueue addTaskToQueue:task];
    
    NSLog(@"nishiwodexiaopengguo%@",galleries);
    //maybe
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
            } else {
                [UI showAlert:@"请等待数据加载完毕"];
                [self playVoiceForGallery:self.playingGalleryId atIndex:0 isComment:self.isPlayingComment];
            }
        }
    }
}

- (void)stopPlayVoice
{
    [AudioPlayer stopPlay];
}

- (void)loadGalleryDetail {
    NSArray *cells = [galleryTable visibleCells];
    for (GalleryCell *cell in cells) {
        [cell loadFullGallery];
    }
}


#pragma table view section
- (void)configCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    GalleryCell *gCell = (GalleryCell *)cell;
    NSLog(@"config: %d", indexPath.row);
    if (galleries.count > indexPath.row) {
        long galleryId = [[galleries objectAtIndex:indexPath.row] longValue];
        if (gCell.galleryId != galleryId) {
            gCell.currentIndex = 0;
            gCell.galleryId = galleryId;
        }
        gCell.playingComment = (self.playingGalleryId == gCell.galleryId && self.isPlayingComment);
        gCell.playingIntro = (self.playingGalleryId == gCell.galleryId && !self.isPlayingComment);
        if (gCell.playingIntro) {
            gCell.currentIndex = self.pictureIndex;
        }
        [gCell updateLayout];
    }
//    if (galleries.count > indexPath.row) {
//        GalleryCell *gCell = (GalleryCell *)cell;
//        
//        gCell.galleryId = [[galleries objectAtIndex:indexPath.row] longValue];
//        gCell.playingComment = (self.playingGalleryId == gCell.galleryId && self.isPlayingComment);
//        gCell.playingIntro = (self.playingGalleryId == gCell.galleryId && !self.isPlayingComment);
//        [gCell updateLayout];
//    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return galleries.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"gallerycell";
    GalleryCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[[GalleryCell alloc] initWithStyle:UITableViewCellStyleDefault
                                   reuseIdentifier:cellId] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.userInfoDelegate = self;
    }
    [self configCell:cell atIndexPath:indexPath];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (galleries.count > indexPath.row) {
        long galleryId = [[galleries objectAtIndex:indexPath.row] longValue];
        Gallery *g = [Gallery getGalleryWithId:galleryId];
        return [GalleryCell cellHeight:g.content];
    }
    return 375;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (galleries.count > indexPath.row) {
        NSNumber *g = [galleries objectAtIndex:indexPath.row];
        
        GalleryViewController *gVC = [[GalleryViewController alloc] initWithGallery:[g longValue]];
        [ctr pushViewController:gVC animation:ViewSwitchAnimationSwipeR2L];
        [gVC release];
    }
}


#pragma mark pull table view delegate
- (void)pullTableViewDidTriggerRefresh:(PullTableView*)pullTableView
{
    currentPage = 1;
    [self loadGallery];
}

- (void)pullTableViewDidTriggerLoadMore:(PullTableView*)pullTableView
{
    currentPage ++;
    [self loadGallery];
}


#pragma mark uiscrollview delegate
// called on finger up if the user dragged. decelerate is true if it will continue moving afterwards
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    NSLog(@"1");
    [self loadGalleryDetail];
}

// called on finger up as we are moving
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
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


#pragma mark UserViewDelegate
- (void)editUserRelation:(UserView *)caller {
    User *user = [User getUserWithId:self.userId];
    if (user.following) {
        LKTask *task = [[LKTask alloc] initUserRelation:self.userId
                                                 follow:![user.following boolValue]];
        task.logicCallbackBlock = ^(bool successful, id userInfo) {
            if (successful) {
                [caller updateLayout];
            }
        };
        [TaskQueue addTaskToQueue:task];
        [task release];
    }
}

- (void)showFriend
{
    FriendViewController *fCtr = [[FriendViewController alloc] initWithUser:self.userId];
    [ctr pushViewController:fCtr animation:ViewSwitchAnimationSwipeR2L];
    [fCtr release];
}

- (void)showFan
{
    FanViewController *fCtr = [[FanViewController alloc] initWithUser:self.userId];
    [ctr pushViewController:fCtr animation:ViewSwitchAnimationSwipeR2L];
    [fCtr release];
}

@end
