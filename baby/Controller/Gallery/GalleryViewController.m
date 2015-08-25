//
//  GalleryViewController.m
//  baby
//
//  Created by zhang da on 14-3-6.
//  Copyright (c) 2014年 zhang da. All rights reserved.
//

#import "GalleryViewController.h"
#import "UIButtonExtra.h"
#import "GCommentCell.h"
#import "AudioPlayer.h"
#import "UserViewController.h"
#import "SelfGalleryViewController.h"
#import "AudioPlayer.h"

#import "Gallery.h"
#import "Picture.h"

#import "GalleryPictureLk.h"
#import "GalleryTask.h"
#import "PostTask.h"
#import "TaskQueue.h"
#import "ConfigManager.h"
#import "ShareManager.h"

#import "Macro.h"

#define PAGESIZE 50
#define EDITVIEW_HEIGHT 60

@interface GalleryViewController ()
@property (nonatomic, assign) int pictureIndex;
@property (nonatomic, assign) long playingCommentId;

@property (nonatomic, assign) bool playingTopGallery;
@property (nonatomic, assign) bool playingTopComment;


@property (nonatomic,assign)  long commenterIdStr;
@property (nonatomic,assign)  long commenterId;

@property (nonatomic,assign)   long chulijianId;
@property (nonatomic,assign)   long didSelectedRowNum;

@property (nonatomic,assign)   NSString * didSelectedRow;

@property (nonatomic,assign)   NSString * zhouwuStr ;

@property (nonatomic,assign)   NSArray * commentersArr;

@property (nonatomic,assign)   NSString * nameBBB ;
@property (nonatomic,assign)   NSString * textChu ;
@property (nonatomic,assign)   NSArray * arrChu ;
@property (nonatomic,assign)   NSString  * userNameChu ;
@property (nonatomic,assign)   NSMutableArray * transferReplyTo;

@property (nonatomic,assign)   NSMutableArray * getReplyId;
@property (nonatomic,assign)   NSString * replyNameChu;


@end


@implementation GalleryViewController

- (void)dealloc
{
   // [comments release];
    comments = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"Sundy" object:nil];
    
    [super dealloc];
}
//  userviewController中339有应用
- (id)initWithGallery:(long)galleryId {
    self = [super init];
    if (self) {
        comments = [[NSMutableArray alloc] initWithCapacity:0];
        self.galleryId = galleryId;
        
        commentTable = [[PullTableView alloc] initWithFrame:CGRectMake(0, 44, 320, screentContentHeight - 44) style:UITableViewStylePlain];
        commentTable.delegate = self;
        commentTable.dataSource = self;
        commentTable.pullDelegate = self;
        commentTable.pullBackgroundColor = [Shared bbWhite];
        commentTable.backgroundColor = [Shared bbWhite];
        [commentTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [self.view addSubview:commentTable];
        [commentTable release];
        
        editView = [[EditView alloc] initWithFrame:CGRectMake(0, screentContentHeight - EDITVIEW_HEIGHT, 320, EDITVIEW_HEIGHT)];
        editView.delegate = self;
        editView.tag = 100;
        [self.view addSubview:editView];//评论框
        [editView release];
    }
    
    
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Custom initialization
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setViewTitle:@"图片详情"];
    bbTopbar.backgroundColor = [UIColor colorWithRed:234/255.0 green:166/255.0 blue:31/255.0 alpha:1];
    
    UIButton *back = [UIButton buttonWithCustomStyle:CustomButtonStyleBack];
    [back addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [bbTopbar addSubview:back];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(monday:) name:@"monday" object:nil];

    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(comment:) name:@"Sundy" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(ttt:) name:@"chuanshuo" object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(zhouwu:) name:@"zhouwu" object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(zhouri:) name:@"userInformation" object:nil];
    
  //  [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(zhouyi:) name:@"zhouyi" object:nil];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (userFlags.initAppear)
    {
        currentPage = 1;
        commentTable.isRefreshing = YES;
       [self loadComment];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [AudioPlayer stopPlay];
}


#pragma mark ui event
- (void)back
{
    [ctr popViewControllerAnimated:YES];
}

//加载评论




- (void)loadComment
{
    GalleryTask *task = [[GalleryTask alloc] initGCommentList:self.galleryId page:currentPage count:PAGESIZE];
    
    
    NSLog(@"%@",task.userDictArr);
    task.logicCallbackBlock = ^(bool succeeded, id userInfo)
    {
        if (succeeded)
        {
            if (currentPage == 1)
            {
             
                [comments removeAllObjects];
            }
            if (userInfo)
            {
                [comments addObjectsFromArray:(NSArray *)userInfo];
                NSLog(@"userInfo GMV %@",userInfo);
                //userInfo 存储方式为获得评论编号
                
            }
            [commentTable reloadData];
        }
        [commentTable stopLoading];
        if ([((NSArray *)userInfo) count] < PAGESIZE)
        {
            commentTable.hasMore = NO;
        }
        else
        {
            commentTable.hasMore = YES;
        }
    };
    
    
    [TaskQueue addTaskToQueue:task];
    [task release];
    
}
//加载评论

- (void)startPlayVoice
{
    Gallery *g = [Gallery getGalleryWithId:self.galleryId];
    self.playingCommentId = -1;

    if (self.playingTopComment) {
        [Voice getVoice:g.commentVoice
               callback:^(NSString *url, NSData *voice) {
                   if ([url isEqualToString:g.commentVoice] && voice) {
                       [AudioPlayer startPlayData:voice finished:^{
                           self.playingTopComment = NO;
                           [commentTable reloadData];
                       }];
                   } else {
                       self.playingTopComment = NO;
                       [commentTable reloadData];
                   }
               }];
    }
    else if (self.playingTopGallery)
    {
        NSArray *gPictures = [GalleryPictureLK getPicturesForGallery:self.galleryId];
        if (gPictures.count > self.pictureIndex) {
            GalleryPictureLK *lk = [gPictures objectAtIndex:self.pictureIndex];
            Picture *pic = [Picture getPictureWithId:lk.pictureId];
            
            if (pic.voice) {
                [Voice getVoice:pic.voice
                       callback:^(NSString *url, NSData *voice) {
                           if ([url isEqualToString:pic.voice] && voice) {
                               [AudioPlayer startPlayData:voice finished:^{
                                   self.playingTopGallery = NO;
                                   [commentTable reloadData];
                               }];
                           } else {
                               self.playingTopComment = NO;
                               [commentTable reloadData];
                           }
                       }];
            }
        }
        else
        {
            [UI showAlert:@"请等待数据加载完毕"];
            [self playVoiceForGallery:0 atIndex:0 isComment:NO];
        }
    }
}

- (void)stopPlayVoice
{
    [AudioPlayer stopPlay];
}


#pragma table view section
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

   
    if(comments.count>0)
    {
   //     NSLog(@"评论数目不为零");
        NSString * commenterId=[NSString stringWithFormat:@"%ld",(unsigned long)comments.count];
        NSLog(@"评论数目是%@个",commenterId);
        self.chulijianId=comments.count;
        
    }
    if (section == 0)
    {
        return 1;
    }
    else
    {
        
//        NSLog(@"sssssssssssssss%d",comments.count);
        return comments.count;

        //indexPath.row的总数
    }
    

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (void)configCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    
    
    //chulijian重要
    if (indexPath.section == 0)
    {
        GalleryCell *gCell = (GalleryCell *)cell;
        gCell.galleryId = self.galleryId;
        gCell.playingComment = self.playingTopComment;
        gCell.playingIntro = self.playingTopGallery;
        gCell.delegate = self;
        if (gCell.playingIntro)
        {
            gCell.currentIndex = self.pictureIndex;
        }
        [gCell updateLayout];
        [gCell loadFullGallery];
        }
        else
        {
            if (comments.count > indexPath.row)
            {
                GCommentCell *cCell = (GCommentCell *)cell;
                cCell.commentId = [[comments objectAtIndex:indexPath.row] longValue];
                if (cCell.commentId == self.playingCommentId)
                {
                    cCell.loadingVoice = YES;
                }
                else
                {
                    cCell.loadingVoice = NO;
                }
                [cCell updateLayout];
        }
    }
    

    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0)
    {
        static NSString *cellId = @"gallerycell";
        GalleryCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        
        
        
        if (!cell)
        {
            //chulijian注意
            cell = [[[GalleryCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:cellId] autorelease];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.userInfoDelegate = self;
        }
        [self configCell:cell atIndexPath:indexPath];
        return cell;
    }
    else
    {
        static NSString *cellId = @"commentcell";
        GCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell)
        {
            cell = [[[GCommentCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:cellId] autorelease];
          //  cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;
            

        }
        [self configCell:cell atIndexPath:indexPath];
        
        
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        Gallery *g = [Gallery getGalleryWithId:self.galleryId];
        return [GalleryCell cellHeight:g.content];
    }
    else
    {
        if (indexPath.row < comments.count - 1)
        {
            long commentId = [[comments objectAtIndex:indexPath.row] longValue];
            return [GCommentCell height:commentId];
        }
        return DEFAULTCOMMENT_HEIGHT;
    }
}



- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return nil;
    }
    UIView *bg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, EDITVIEW_HEIGHT)];
    bg.backgroundColor = [Shared bbWhite];
    return [bg autorelease];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    }
    return EDITVIEW_HEIGHT;
}
-(void)ttt:(NSNotification *)notif
{
    NSString * commentIdString  =[notif object];
    
    self.commenterIdStr=(long)[commentIdString integerValue];
}


-(void)cccttt:(NSNotification *)popo
{
    NSString * nameStr  =[popo object];
    
    NSLog(@"%@",nameStr);
    
    
}
-(void)zhouri:(NSNotification *)notifiName
{
    self.userNameChu=[notifiName object];

}
-(void)monday:(NSNotification *)monday
{
    self.getReplyId=[monday object];
    NSLog(@"uuuuuuuuutttttttttttt%@",self.getReplyId);

}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section != 0)
    {

        NSString * string=[NSString stringWithFormat:@"%ld",(long)indexPath.row];
        self.didSelectedRow=string;
        self.didSelectedRowNum=indexPath.row;
        
        NSNotification * chuanhua =[NSNotification notificationWithName:@"chuanhua" object:string userInfo:nil];
        [[NSNotificationCenter defaultCenter] postNotification:chuanhua];
        if(self.commentersArr)
        {
            self.nameBBB=[self.commentersArr objectAtIndex:self.didSelectedRowNum];
        }
        
        
        if(self.getReplyId)
        {
            self.replyNameChu=[self.getReplyId objectAtIndex:self.didSelectedRowNum];
            NSLog(@"selected id is %@",self.replyNameChu);
        
        }
        
        

    }
}

- (void)comment:(NSNotification *)notification
{
    NSString *text = notification.object;
    
    if (self.didSelectedRow&&text.length != 0)
    {
     //   NSString *commentText = [NSString stringWithFormat:@"回复%@:%@",_nameBBB,text];
        
      //  [self newText:commentText];
    }
}

//chulijian


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath*)indexPath
{
    return YES;
}

//chulijian
#pragma mark pull table view delegate
- (void)pullTableViewDidTriggerRefresh:(PullTableView*)pullTableView {
    currentPage = 1;
    [self loadComment];
}

- (void)pullTableViewDidTriggerLoadMore:(PullTableView*)pullTableView {
    currentPage ++;
    [self loadComment];
}


#pragma mark editview delegate
- (void)newVoice:(NSData *)mp3 length:(int)length
{
    if (length >= 3) {
        
        
        
        PostTask *task = [[PostTask alloc] initNewGCommentForGallery:self.galleryId
                                                             replyTo:nil
                                                               voice:mp3
                                                              length:length
                                                             content:nil];
        [UI showIndicator];
        task.logicCallbackBlock = ^(bool succeeded, id userInfo) {
            if (succeeded) {
                [self loadComment];
            }
            [UI hideIndicator];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:UserDidAddCommentNotification
                                                                object:nil
                                                              userInfo:nil];
            
            
        };
        [TaskQueue addTaskToQueue:task];
        [task release];
    } else {
        [UI showAlert:@"评论时长不足3s"];
    }
}
//chulijian重要
//- (void)zhouyi:(NSNotification *)zhouyi
//{
//    self.transferReplyTo=[NSMutableArray array];
//    self.transferReplyTo=[zhouyi object];
//    NSLog(@"55555555555%@",self.transferReplyTo);
//    
//    NSNotification * zhouzhou =[NSNotification notificationWithName:@"zhouzhou" object:self.transferReplyTo userInfo:nil];
//    
//    [[NSNotificationCenter defaultCenter] postNotification:zhouzhou];
//    
//    
//}

- (void)zhouwu:(NSNotification *)zhouwu
{
    self.commentersArr=[zhouwu object];
    
    NSLog(@"9999999999999999%@",self.commentersArr);
    
    
}

- (void)newText:(NSString *)text
{
    self.textChu=text;
    if(self.nameBBB)
    {
        PostTask *task = [[PostTask alloc] initNewGCommentForGallery:self.galleryId
                                                             replyTo:self.replyNameChu
                                                               voice:nil
                                                              length:0
                                                             content:text];
        [UI showIndicator];
        
        
        NSLog(@"HHHHHHHHHHHHHH%@",self.nameBBB);
        task.logicCallbackBlock = ^(bool succeeded, id userInfo) {
            if (succeeded) {
                [self loadComment];
                [editView resetText];
                [UI hideIndicator];
            }
        };
        [TaskQueue addTaskToQueue:task];
        [task release];

    
    }
    else
    {
        PostTask *task = [[PostTask alloc] initNewGCommentForGallery:self.galleryId
                                                             replyTo:nil
                                                               voice:nil
                                                              length:0
                                                             content:text];
        [UI showIndicator];
        
        
    //    NSLog(@"PPPPPPPPPPPPPPPPPPPP");
        task.logicCallbackBlock = ^(bool succeeded, id userInfo) {
            if (succeeded) {
                [self loadComment];
                [editView resetText];
                [UI hideIndicator];
            }
        };
        [TaskQueue addTaskToQueue:task];
        [task release];

    
    }
   }


#pragma mark gallery cell delegate
- (void)deleteGallery:(long)galleryId {
    GalleryTask *task = [[GalleryTask alloc] initDeleteGallery:galleryId];
    task.logicCallbackBlock = ^(bool successful, id userInfo) {
        if (successful) {
            [UI showAlert:@"删除成功"];
            [ctr popViewControllerAnimated:YES];
        }
    };
    [TaskQueue addTaskToQueue:task];
    [task release];
}

- (void)shareGallery:(long)galleryId
{
    Gallery *g = [Gallery getGalleryWithId:galleryId];
    if (g) {
        UIImage *local = [IMG getImageFromDisk:g.cover];
        if (local) {
            [[ShareManager me] showShareMenuWithTitle:@"宝贝计画"
                                              content:g.content
                                                image:local
                                              pageUrl:[NSString stringWithFormat:GALLERY_PAGE, galleryId]
                                             soundUrl:g.introVoice];
        }
        
        else
        
        {
            [[ShareManager me] showShareMenuWithTitle:@"宝贝计画"
                                              content:g.content
                                             imageUrl:g.cover
                                              pageUrl:[NSString stringWithFormat:GALLERY_PAGE, galleryId]
                                             soundUrl:g.introVoice];
        }
    } else {
        [UI showAlert:@"图片详情尚未加载完成"];
    }
}


#pragma mark comment cell delegate
- (void)playVoice:(GCommentCell *)cell url:(NSString *)voicePath {
    [AudioPlayer stopPlay];

    self.playingTopGallery = NO;
    self.playingTopComment = NO;

    if (self.playingCommentId != cell.commentId)
    {
        [Voice getVoice:voicePath
               callback:^(NSString *url, NSData *voice) {
                   if ([url isEqualToString:voicePath] && voice) {
                       [AudioPlayer startPlayData:voice finished:^{
                           self.playingCommentId = -1;
                           [commentTable reloadData];
                       }];
                   } else {
                       self.playingCommentId = -1;
                       [commentTable reloadData];
                   }
               }];
        self.playingCommentId = cell.commentId;
    } else {
        self.playingCommentId = -1;
    }
    
    [commentTable reloadData];
}

- (void)deleteComment:(long)commentId {
    GalleryTask *task = [[GalleryTask alloc] initDeleteGComment:commentId];
    
    self.commenterId=commentId;
    
    
    task.logicCallbackBlock = ^(bool successful, id userInfo) {
        if (successful) {
            [comments removeObject:@(commentId)];
            [commentTable reloadData];
            [UI showAlert:@"删除成功"];
        }
    };
    [TaskQueue addTaskToQueue:task];
    [task release];
}


#pragma UserVoiceInfoViewDelegate
- (void)showUserDetail:(long)userId
{
    if (userId == [ConfigManager me].userId)
    {
        SelfGalleryViewController *sCtr = [[SelfGalleryViewController alloc] init];
        [ctr pushViewController:sCtr animation:ViewSwitchAnimationSwipeR2L];
        [sCtr release];
    } else {
        UserViewController *uCtr = [[UserViewController alloc] initWithUser:userId];
        [ctr pushViewController:uCtr animation:ViewSwitchAnimationSwipeR2L];
        [uCtr release];
    }
}

- (void)playVoiceForGallery:(long)galleryId atIndex:(int)page isComment:(bool)isComment {
    [self stopPlayVoice];
    
    self.pictureIndex = page;

    if (self.playingTopGallery && !isComment) {
        self.playingTopGallery = NO;
    } else if (self.playingTopComment && isComment){
        self.playingTopComment = NO;
    } else {
        self.playingTopComment = isComment;
        self.playingTopGallery = !isComment;
        [self startPlayVoice];
    }
    
    [commentTable reloadData];
}


@end
