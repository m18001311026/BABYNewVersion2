//
//  HomeViewController.m
//  baby
//
//  Created by zhang da on 14-3-3.
//  Copyright (c) 2014年 zhang da. All rights reserved.
//

#import "HomeViewController.h"
#import "WelcomeViewController.h"
#import "GalleryViewController.h"
#import "MoreViewController.h"
#import "UserViewController.h"
#import "SelfGalleryViewController.h"
#import "CartViewController.h"



#import "UIButtonExtra.h"
#import "ConfigManager.h"
#import "TabbarController.h"
#import "ShareManager.h"


#import "GalleryTask.h"
#import "TaskQueue.h"

#import "Gallery.h"
#import "Picture.h"
#import "AudioPlayer.h"
#import "GalleryPictureLK.h"
#import "MemContainer.h"

#import "Macro.h"


#define PAGESIZE 5

@interface HomeViewController ()

@property (nonatomic, assign) int pictureIndex;
@property (nonatomic, assign) long playingGalleryId;
@property (nonatomic, assign) bool isPlayingComment;

@end


@implementation HomeViewController

- (void)dealloc {
    [galleries release];
    [galleryType release];
    [moreCtr release];
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    [super dealloc];
}

- (id)init {
    self = [super init];
    if (self) {
        // Custom initialization
        self.view.backgroundColor = [UIColor whiteColor];

        galleryType = [[SimpleSegment alloc] initWithFrame:CGRectMake(5, 5, 310, 29)
                                                    titles:@[@"单幅画", @"绘本"]];
        galleryType.selectedTextColor = [UIColor whiteColor];
      // galleryType.selectedBackgoundColor = [UIColor colorWithRed:234/255.0 green:166/255.0 blue:31/255.0 alpha:1];
         galleryType.selectedBackgoundColor = [UIColor colorWithRed:234/255.0 green:166/255.0 blue:31/255.0 alpha:1];
        galleryType.normalTextColor = [UIColor colorWithRed:234/255.0 green:166/255.0 blue:31/255.0 alpha:1];
        galleryType.normalBackgroundColor = [UIColor whiteColor];
      // galleryType.borderColor = [Shared bbYellow];
       galleryType.borderColor =[UIColor colorWithRed:234/255.0 green:166/255.0 blue:31/255.0 alpha:1];
        galleryType.delegate = self;
        galleryType.layer.cornerRadius = 2;
        [galleryType updateLayout];

        galleryTable = [[PullTableView alloc] initWithFrame:CGRectMake(0, 44, 320, screentContentHeight - 44 - 52)
                                                      style:UITableViewStylePlain];
        galleryTable.pullDelegate = self;
        galleryTable.delegate = self;
        galleryTable.dataSource = self;
        galleryTable.pullBackgroundColor = [Shared bbWhite];
        [galleryTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [self.view addSubview:galleryTable];
        [galleryTable release];
        
        [self setViewTitle:@"宝贝计画" ];
        
    //   bbTopbar.backgroundColor = [UIColor colorWithRed:234/255.0 green:166/255.0 blue:31/255.0 alpha:1];
        bbTopbar.backgroundColor = [UIColor colorWithRed:234/255.0 green:166/255.0 blue:31/255.0 alpha:1];
    //    bbTopbar.backgroundColor=[UIColor clearColor];
        //chulijian菜单按钮
        UIButton *back = [UIButton buttonWithCustomStyle:CustomButtonStyleMenu];
        [back addTarget:self action:@selector(toggleMoreView) forControlEvents:UIControlEventTouchUpInside];
        [bbTopbar addSubview:back];
        
        galleries = [[NSMutableArray alloc] initWithCapacity:0];
        currentPage = 1;
        [self loadGallery];
        
        panGes = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
        panGes.delegate = self;
        panGes.cancelsTouchesInView = YES;
        [self.view addGestureRecognizer:panGes];
        [panGes release];


        
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(refreshGallery)
                                                     name:UserDidAddGalleryNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(refreshGallery)
                                                     name:UserDidAddCommentNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(refreshGallery)
                                                     name:UserDidLoginNotification
                                                   object:nil];

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    UIButton *shoppingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    shoppingBtn.frame = CGRectMake(kScreen_width - 40, 7, 30, 30);
    [shoppingBtn setImage:[UIImage imageNamed:@"shopping.png"] forState:UIControlStateNormal];
    [shoppingBtn addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
//    [bbTopbar addSubview:shoppingBtn];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addBagedNumber:) name:@"BagedNumber" object:nil];
}

- (void)addBagedNumber:(NSNotification *)notification
{
    UIViewController *viewController = [notification.userInfo objectForKey:@"viewController"];
    
    for (UIViewController *obj in self.tabBarController.viewControllers)
    {
        if (obj == viewController)
        {
            viewController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%ld",(long)[notification.object integerValue]];
        }
    }
}

- (void)btnAction {
    //    CartViewController
    
    CartViewController *dCtr = [[CartViewController alloc] init];
    [ctr pushViewController:dCtr animation:ViewSwitchAnimationSwipeR2L];
    [dCtr release];
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
- (void)segmentSelected:(int)index {
    currentPage = 1;
    galleryTable.isRefreshing = YES;
    self.playingGalleryId = 0;
    [self loadGallery];
}

- (void)loadGallery {
    GalleryTask *task = [[GalleryTask alloc] initGalleryList:galleryType.selectedIndex == 0
                                                        page:currentPage
                                                       count:PAGESIZE];
    task.logicCallbackBlock = ^(bool succeeded, id userInfo) {
        if (currentPage == 1) {
            [galleries removeAllObjects];
        }
        
        if (succeeded)
        {
            [galleries addObjectsFromArray:(NSArray *)userInfo];
            if ([((NSArray *)userInfo) count] < PAGESIZE) {
                galleryTable.hasMore = NO;
            } else {
                galleryTable.hasMore = YES;
            }
        }
 
        [galleryTable reloadData];
        [galleryTable stopLoading];
        
        [self loadGalleryDetail];
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

- (void)initMoreView {
    if (!moreCtr) {
        moreCtr = [[MoreViewController alloc] init];
        [delegate.window insertSubview:moreCtr.view
                          belowSubview:self.parentController.contentView];
    }
}

- (void)toggleMoreView {
    [self initMoreView];
    __block CGRect origin = self.parentController.contentView.frame;
    
    if (origin.origin.x == 0) {
        moreCtr.view.hidden = NO;
        [UIView animateWithDuration:.3
                         animations:^{
                             origin.origin.x = 270;
                             self.parentController.contentView.frame = origin;
                         }];
    } else {
        [UIView animateWithDuration:.3
                         animations:^{
                             origin.origin.x = 0;
                             self.parentController.contentView.frame = origin;
                         }];
    }
}


#pragma table view section
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return galleries.count;
}

- (void)configCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    GalleryCell *gCell = (GalleryCell *)cell;
    
    NSLog(@"config: %ld", (long)indexPath.row);
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
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"gallerycell";
    
    GalleryCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[[GalleryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.userInfoDelegate = self;
        cell.delegate = self;
    }
    [self configCell:cell atIndexPath:indexPath];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (galleries.count > indexPath.row) {
        long galleryId = [[galleries objectAtIndex:indexPath.row] longValue];
        Gallery *g = [Gallery getGalleryWithId:galleryId];
        return [GalleryCell cellHeight:g.content];
    }
    return 375;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    int galleryId = [[galleries objectAtIndex:indexPath.row] longValue];
    GalleryViewController *gVC = [[GalleryViewController alloc] initWithGallery:galleryId];
    [ctr pushViewController:gVC animation:ViewSwitchAnimationBounce];
    [gVC release];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *bg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 31)];
    bg.backgroundColor = [Shared bbWhite];
    [bg addSubview:galleryType];
    return [bg autorelease];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 39;
}

- (void)loadGalleryDetail {
    NSArray *cells = [galleryTable visibleCells];
    for (GalleryCell *cell in cells) {
        [cell loadFullGallery];
    }
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
- (void)showUserDetail:(long)userId {
    if (userId == [ConfigManager me].userId) {
        SelfGalleryViewController *sCtr = [[SelfGalleryViewController alloc] init];
        [ctr pushViewController:sCtr animation:ViewSwitchAnimationBounce];
        [sCtr release];
    } else {
        UserViewController *uCtr = [[UserViewController alloc] initWithUser:userId];
        [ctr pushViewController:uCtr animation:ViewSwitchAnimationBounce];
        [uCtr release];
    }
}

- (void)playVoiceForGallery:(long)galleryId atIndex:(int)page isComment:(bool)isComment {
    [self stopPlayVoice];

    self.pictureIndex = page;

    if (self.playingGalleryId == galleryId
        && self.isPlayingComment == isComment) {
        self.playingGalleryId = 0;
    } else {
        self.isPlayingComment = isComment;
        self.playingGalleryId = galleryId;
    }
    
    [galleryTable reloadData];
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

    //pageUrl [NSString stringWithFormat:GALLERY_PAGE, galleryId]
    
    if (g) {
        UIImage *local = [IMG getImageFromDisk:g.cover];
        if (local) {
            [[ShareManager me] showShareMenuWithTitle:@"   "
                                              content:g.content
                                                image:local
                                              pageUrl:[NSString stringWithFormat:GALLERY_PAGE, galleryId]
                                             soundUrl:g.introVoice];
            
          //  NSLog(@"11111%@",g.content);
        } else {
            [[ShareManager me] showShareMenuWithTitle:@"   "
                                              content:g.content
                                             imageUrl:g.cover
                                              pageUrl:[NSString stringWithFormat:GALLERY_PAGE, galleryId]
                                             soundUrl:g.introVoice];
        }
    } else {
        [UI showAlert:@"图片详情尚未加载完成"];
    }
}


#pragma mark notification
- (void)refreshGallery {
    
    currentPage = 1;
    [self loadGallery];
    
}


#pragma mark - GestureRecognizers
- (void)pan:(UIPanGestureRecognizer*)gesture {
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
        [self initMoreView];
        
        panOriginX = self.parentController.contentView.frame.origin.x;
        panVelocity = CGPointMake(0.0f, 0.0f);
        
        if([gesture velocityInView:self.view].x > 0) {
            swipeDirection = SwipeDirectionRight;
        } else
        {
            swipeDirection = SwipeDirectionLeft;
        }
    } else if (gesture.state == UIGestureRecognizerStateChanged) {
        
        panVelocity = [gesture velocityInView:self.view];
        if((panVelocity.x*panVelocity.x + panVelocity.y*panVelocity.y) < 0) {
            swipeDirection = (swipeDirection == SwipeDirectionRight)? SwipeDirectionLeft: SwipeDirectionRight;
        }

        CGPoint translation = [gesture translationInView:self.view];
        float totalDistance = translation.x;
        
        if (panOriginX + totalDistance > 0 && panOriginX + totalDistance < 320) {
            CGRect currentFrame = self.parentController.contentView.frame;
            currentFrame.origin.x = panOriginX + totalDistance;
            self.parentController.contentView.frame = currentFrame;
        }
        
    } else if (gesture.state == UIGestureRecognizerStateEnded
               || gesture.state == UIGestureRecognizerStateCancelled) {
        
        __block CGRect origin = self.parentController.contentView.frame;
        float changePoint = origin.size.width*0.5;

        if (origin.origin.x > changePoint) {
            moreCtr.view.hidden = NO;
            galleryTable.userInteractionEnabled = NO;
            [UIView animateWithDuration:.3
                             animations:^{
                                 origin.origin.x = 270;
                                 self.parentController.contentView.frame = origin;
                             }];
        } else {
            galleryTable.userInteractionEnabled = YES;
            [UIView animateWithDuration:.3
                             animations:^{
                                 origin.origin.x = 0;
                                 self.parentController.contentView.frame = origin;
                             }];
        }
    }
}


@end
