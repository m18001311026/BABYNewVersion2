//
//  GalleryCell.m
//  baby
//
//  Created by zhang da on 14-3-4.
//  Copyright (c) 2014年 zhang da. All rights reserved.

#import "GalleryCell.h"
#import "ImageView.h"
#import "UIImageButton.h"
#import "User.h"
#import "Gallery.h"
#import "Picture.h"
#import "GalleryPictureLK.h"
#import "ConfigManager.h"
#import "Session.h"

#import "GalleryTask.h"
#import "LKTask.h"
#import "TaskQueue.h"


#import "ImageDetailView.h"

//-------
#import "UserViewController.h"
#import "LKTask.h"
#import "UserTask.h"
//-------
#define Chu 7

@interface GalleryCell()
{
    UIView *bg;
    UIButton * attentionBtnHH;
    NSString * userIdStr;

}

@property (nonatomic, retain) Gallery *gallery;

@end



@implementation GalleryCell

- (void)dealloc {
    self.gallery = nil;
    self.userInfoDelegate = nil;
    self.delegate = nil;
    
    [pictureViews release];
    pictureViews = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"tuesday" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"zhousan" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"zhousanyi" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"zhousaner" object:nil];

    [super dealloc];
}

- (void)setGalleryId:(long)galleryId
{
    if (_galleryId != galleryId) {
        _galleryId = galleryId;
        self.gallery = nil;
    }
}

- (void)setUserInfoDelegate:(id<UserVoiceInfoViewDelegate>)userInfoDelegate {
    if (_userInfoDelegate != userInfoDelegate) {
        _userInfoDelegate = userInfoDelegate;
        
        user.delegate = self.userInfoDelegate;
        commentator.delegate = self.userInfoDelegate;
    }
}

- (void)setPlayingComment:(bool)playingComment {
    if (_playingComment != playingComment) {
        _playingComment = playingComment;
        
        commentator.isPlaying = _playingComment;
    }
}

- (void)setPlayingIntro:(bool)playingIntro {
    if (_playingIntro != playingIntro) {
        _playingIntro = playingIntro;
        
        user.isPlaying = _playingIntro;
    }
}

- (void)setCurrentIndex:(int)currentIndex {
    if (_currentIndex != currentIndex) {
        _currentIndex = currentIndex;
    }
}

- (Gallery *)gallery
{
    //NSLog(@"call getter: %@, %d", _gallery, self.galleryId);
    if (!_gallery && self.galleryId > 0) {
        self.gallery = [Gallery getGalleryWithId:self.galleryId];
    }
    return _gallery;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
 //   [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(attentionBtnDown) name:@"chuanshuo" object:nil];
    //-------chulijian
    
    
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(ttt:) name:@"chuanshuo" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(tutu:) name:@"tuesday" object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mingming:) name:@"zhousan" object:nil];
    //-------------------下面是pic长宽测试---------------------
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(picWidth:) name:@"zhousanyi" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(picHeight:) name:@"zhousaner" object:nil];
    //-------------------急速通知-------------
 //   [[NSNotificationCenter defaultCenter] addObserver:self selector:nil name:@"zhousanyi" object:self.textChu];
    //--------------------chulijian---------------------
 //   NSLog(@"textChu=============%@",self.textChu);
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
  
    NSLog(@"%f",self.stringLength);

    
    
    if (self)
    {
        self.layer.masksToBounds = YES;
        
        self.backgroundColor = [UIColor whiteColor];
        
        bg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 374)];
        
        NSLog(@"%f",self.stringLength);
        
        bg.backgroundColor = [Shared bbRealWhite];
        [self addSubview:bg];
        
        UIImageView * imageView=[[UIImageView alloc]initWithFrame:CGRectMake(12, 5, 296, 210)];
        imageView.image=[UIImage imageNamed:@"xiangkuang.png"];
        [self addSubview:imageView];

        //chulijianzhousan
        galleryHolder = [[UIScrollView alloc] initWithFrame:CGRectMake(50, 43, 218, 130)];
    //   galleryHolder = [[UIScrollView alloc] initWithFrame:CGRectMake(50, 43, self.widthChu, self.heightChu)];
   //     NSLog(@"为什么%f,付出那么多%f",self.widthChu,self.heightChu);
        galleryHolder.pagingEnabled = YES;
        galleryHolder.backgroundColor = [Shared bbRealWhite];
     //   galleryHolder.alwaysBounceHorizontal = YES;
        galleryHolder.delegate = self;
        galleryHolder.showsHorizontalScrollIndicator = NO;
        galleryHolder.showsVerticalScrollIndicator=NO;
        galleryHolder.contentSize = CGSizeMake(218, 130);
        galleryHolder.pagingEnabled=NO;
        galleryHolder.clipsToBounds=YES;
        galleryHolder.layer.borderColor=[UIColor colorWithRed:170/255.0 green:170/255.0 blue:170/255.0 alpha:1].CGColor;
        galleryHolder.layer.borderWidth=1;
        galleryHolder.layer.shadowOffset=CGSizeMake(20, 20);
        //chulijian
        [self addSubview:galleryHolder];
        [galleryHolder release];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewTaped:)];
        [galleryHolder addGestureRecognizer:tap];
        [tap release];
        
        paging = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 200, 320, 20)];
        paging.hidesForSinglePage = YES;
        paging.userInteractionEnabled = NO;
        [self addSubview:paging];
        [paging release];
        
        pictureViews = [[NSMutableArray alloc] init];
        pictures = [[NSMutableArray alloc] init];
        
        user = [[UserVoiceInfoView alloc] initWithFrame:CGRectMake(0, 220, 160, 75)];
        user.isComment = NO;
        user.backgroundColor = [Shared bbRealWhite];
        [self addSubview:user];
        [user release];
        
        
        commentator = [[UserVoiceInfoView alloc] initWithFrame:CGRectMake(160, 220, 160, 72)];
        commentator.isComment = YES;
        commentator.backgroundColor = [Shared bbRealWhite];
        [self addSubview:commentator];
        [commentator release];
        
        
        topic = [[UILabel alloc] initWithFrame:CGRectMake(10, 295, 300, 17)];
        topic.backgroundColor = [Shared bbRealWhite];
        topic.textColor = [UIColor grayColor];
        topic.font = [UIFont systemFontOfSize:16];
        topic.text = @"";
        [self addSubview:topic];
        [topic release];
        
        
        likeBtn = [[UIImageButton alloc] initWithFrame:CGRectMake(0, 317, 81, 55)
                                                 image:@"ic_heart_yellow.png"
                                           imageHeight:18
                                                  text:@"0"
                                              fontSize:16];
        likeBtn.backgroundColor = [Shared bbRealWhite];
        likeBtn.textNormalColor = [UIColor colorWithRed:234/255.0 green:166/255.0 blue:31/255.0 alpha:1];
        likeBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        likeBtn.layer.borderWidth = 2.0f;
        likeBtn.layer.masksToBounds = NO;
        [likeBtn addTarget:self action:@selector(likeGallery) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:likeBtn];
        [likeBtn release];
        
        commentBtn = [[UIImageButton alloc] initWithFrame:CGRectMake(80, 317, 80, 55)image:@"ic_message_yellow.png"imageHeight:18 text:@"0"
        fontSize:16];
        commentBtn.backgroundColor = [Shared bbRealWhite];
        commentBtn.textNormalColor = [UIColor colorWithRed:234/255.0 green:166/255.0 blue:31/255.0 alpha:1];
        commentBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        commentBtn.layer.borderWidth = 1.0f;
        commentBtn.layer.masksToBounds = NO;
        commentBtn.userInteractionEnabled = NO;
        [self addSubview:commentBtn];
        [commentBtn release];
        
       
        UIButton * attentionBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        attentionBtn.frame=CGRectMake(160, 317, 80, 55);
        [attentionBtn addTarget:self action:@selector(attentionBtnDown:) forControlEvents:UIControlEventTouchUpInside];
        attentionBtnHH=attentionBtn;
        UIImageView * image=[[UIImageView alloc]initWithFrame:CGRectMake((attentionBtnHH.frame.size.width-20)/2-10, (attentionBtnHH.frame.size.height-20)/2, 20, 20)];
       // UIImage * yesImg=[UIImage imageNamed:@"YES.png"
        
        
        image.image=[UIImage imageNamed:@"ic_heart_add_yellow(2).png"];
        UILabel * lab=[[UILabel alloc]initWithFrame:CGRectMake((attentionBtnHH.frame.size.width-20)/2+15, (attentionBtnHH.frame.size.height-20)/2, 30, 20)];
        lab.text=@"关注";
        lab.textColor= [UIColor colorWithRed:234/255.0 green:166/255.0 blue:31/255.0 alpha:1];
        [attentionBtn addSubview:image];
        attentionBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        attentionBtn.layer.borderWidth = 1.0f;
        attentionBtn.layer.masksToBounds = NO;
        lab.font=[UIFont systemFontOfSize:10];
        
        [attentionBtn setTitle:@"关注" forState:UIControlStateNormal];
        [attentionBtn setTitleColor:[UIColor colorWithRed:234/255.0 green:166/255.0 blue:31/255.0 alpha:1] forState:UIControlStateNormal];
        attentionBtn.titleLabel.font=[UIFont systemFontOfSize:14];
        [attentionBtn  setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -38)];
        
        [self addSubview:attentionBtn];
        lab.tag=666;
        attentionBtn.tag=1000;
        //chulijian
        
        shareBtn = [[UIImageButton alloc] initWithFrame:CGRectMake(240, 317, 80, 55)
                                                  image:@"ic_share_yellow.png"
                                            imageHeight:18
                                                   text:@""
                                               fontSize:16];
        shareBtn.backgroundColor = [Shared bbRealWhite];
        shareBtn.textNormalColor = [UIColor colorWithRed:234/255.0 green:166/255.0 blue:31/255.0 alpha:1];
        shareBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        shareBtn.layer.borderWidth = 1.0f;
        shareBtn.layer.masksToBounds = NO;
        [shareBtn addTarget:self action:@selector(shareGallery) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:shareBtn];
        [shareBtn release];
        
        deleteBtn = [[UIImageButton alloc] initWithFrame:CGRectMake(320, 317, 80, 55)
                                                   image:@"delete_pic.png"
                                             imageHeight:18
                                                    text:@""
                                                fontSize:16];
        deleteBtn.backgroundColor = [Shared bbRealWhite];
        deleteBtn.textNormalColor = [UIColor colorWithRed:234/255.0 green:166/255.0 blue:31/255.0 alpha:1];
        deleteBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        deleteBtn.layer.borderWidth = 1.0f;
        deleteBtn.layer.masksToBounds = NO;
        [deleteBtn addTarget:self action:@selector(deleteGallery) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:deleteBtn];
        [deleteBtn release];
        
        
        
    }
//准备刷新cell    [self updateScrollView];

    return self;
}
//------------------chulijian----关注按钮触发事件------------、


-(void)ttt:(NSNotification *)notify
{
    userIdStr =[notify object];

    self.userId=(long)[userIdStr integerValue];
    
    
}
-(void)tutu:(NSNotification *)noti
{
   // self.userId=(long)[[noti object] integerValue];
   // NSLog(@"%ld",self.userId);
}
- (void)mingming:(NSNotification *)notify
{
    self.heightAndWidth=[notify object];
    
 //   NSLog(@"%@",self.heightAndWidth);
}

//--------------------tupian长宽---------------
-(void)picWidth:(NSNotification *)notify
{
    self.strWidthChu=[notify object];
  //  NSLog(@"i2i2i2i2i2i2i2i2i2    %@",self.strWidthChu);
    self.widthChu=[self.strWidthChu floatValue];
 //   NSLog(@"宽%f",self.widthChu);
}
-(void)picHeight:(NSNotification *)notify
{
    self.strHeightChu=[notify object];
   // NSLog(@"w2w2w2w2w2w2w2w2w2    %@",self.strHeightChu);
    self.heightChu=[self.strHeightChu floatValue];
    
 //   NSLog(@"高%f",self.heightChu);
}

//--------------------tupian长宽---------------

- (void)attentionBtnDown:(UIButton *)btn
{
    UILabel * lab=(UILabel *)[self viewWithTag:666];
    lab.text=@"已关注";
   // NSLog(@"galleryID %ld",self.galleryId);
    LKTask *task = [[LKTask alloc] initUserRelation:self.userId follow:YES];
    [UI showIndicator];
    task.logicCallbackBlock = ^(bool successful, id userInfo)
    {
        if (successful)
        {
            [UI showAlert:@"关注成功"];
        }
        else
        {
           [UI showAlert:@"已关注"];
        }
        [UI hideIndicator];
    };
    [TaskQueue addTaskToQueue:task];
    [task release];
}

- (void)updateLayoutNew
{
    
    
    User *userhh = [User getUserWithId:self.userId];
    
    avatar.imagePath = userhh.avatarMid;
    title.text = userhh.showName;
    
    
    if (self.isFriends) {
       // [btn setTitle:@"取消关注" forState:UIControlStateNormal];
    }
    else
    {
        [self loadRelation];
    }
    
}

- (void)loadRelation
{
    NSLog(@"loadRelation");
    
    UIButton * btn=(UIButton *)[self viewWithTag:1000];
    CallbackBlock block = ^(bool successful, id userInfo)
    {
        if (successful) {
            User *userqq = [User getUserWithId:self.userId];
            
                if (!userqq.following)
                {
                    UserTask *task = [[UserTask alloc] initUserDetail:self.userId];
                    task.logicCallbackBlock = ^(bool successful, id userInfo)
                    {
                        if (userqq.following)
                        {
                            //chulijian 关注更改处
                            [btn setTitle:[userqq.following boolValue]? @"已关注": @"关注"
                                     forState:UIControlStateNormal];
                            
                        }
                    };
                    [TaskQueue addTaskToQueue:task];
                    [task release];
                }
                else if (userqq.following)
                {
                    [btn setTitle:[userqq.following boolValue]? @"已关注": @"关注"
                             forState:UIControlStateNormal];
                }
            }
        
    };
    
    User *userpp = [User getUserWithId:self.userId];
    if (userpp) {
        block(YES, nil);
    } else {
        UserTask *task = [[UserTask alloc] initUserDetail:self.userId];
        task.logicCallbackBlock = ^(bool successful, id userInfo) {
            block(YES, nil);
        };
        [TaskQueue addTaskToQueue:task];
        [task release];
    }
    
}

//------------------chulijian---------------------
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (ImageView *)viewForReuse
{
    ImageView *view = nil;
    for (ImageView *v in pictureViews) {
        if (![v superview]) {
            view = v;
            break;
        }
    }
    if (!view) {
        view = [[ImageView alloc] initWithFrame:CGRectMake(0, 0, 218, 130)];
        view.backgroundColor = [Shared bbRealWhite];
        view.clipsToBounds = YES;
        view.userInteractionEnabled = YES;
        //view.contentMode = UIViewContentModeCenter;
        view.imagePath = self.gallery.cover;
        [pictureViews addObject:view];
        [view release];
    }
    return view;
}

- (void)updateScrollView
{
    for (ImageView *v in pictureViews)
    {
        [v removeFromSuperview];
    }
    
    paging.numberOfPages = self.gallery.pictureCnt;
    
    [pictures removeAllObjects];
    
    //prepare data
    //chulijianupdateScrollView
    NSArray *gPictures = [GalleryPictureLK getPicturesForGallery:self.galleryId];
    [pictures addObjectsFromArray:gPictures];
    
    for (int i = 0 ; i < pictures.count; i ++ )
    {
        ImageView *view = [self viewForReuse];
    //  UIImageView * viewChu=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 296, 210)];
     //   NSLog(@"123");
        
     //   view.frame = CGRectMake(218*i, 0, self.widthChu,self.heightChu );
     //   NSLog(@"宽是%f,高是%f",self.widthChu,self.heightChu);
        
      
       view.frame = CGRectMake(218*i, 0, 218,130 );

        //now 218 130
        
//    UIImageView * imageView=[[UIImageView alloc]initWithFrame:CGRectMake(218*i, 0, 218, 130)];
//      imageView.image=view.image;
//       imgViewChu=[[UIImageView alloc]initWithFrame:CGRectMake(218*i, 0, 218, 130)];
//        imgViewChu.image=view.image;
        
        [galleryHolder addSubview:view];
       // [imgViewChu release];
       // [imageView release];
        GalleryPictureLK *lk = [pictures objectAtIndex:i];
        Picture *pic = [Picture getPictureWithId:lk.pictureId];
        view.imagePath = pic? pic.imageMid: nil;
    }
    
    galleryHolder.scrollEnabled = (pictures.count != 1);
    galleryHolder.contentSize = CGSizeMake(218*pictures.count, 130);
    if (self.currentIndex < pictures.count)
    {
        galleryHolder.contentOffset = CGPointMake(218*self.currentIndex, 0);
    }
    
}

- (void)loadFullGallery
{
    NSArray *gPictures = [GalleryPictureLK getPicturesForGallery:self.galleryId];
    if (!gPictures || gPictures.count == 0) {
        GalleryTask *task = [[GalleryTask alloc] initGalleryDetail:self.galleryId];
        task.logicCallbackBlock = ^(bool succeeded, id userInfo) {
            if (succeeded) {
                int galleryId = [[(NSDictionary *)userInfo objectForKey:@"galleryId"] intValue];
                
                if (galleryId == self.galleryId) {
                    [self updateLayout];
                    
                }
            }
        };
        [TaskQueue addTaskToQueue:task];
        [task release];
    }
    
}

- (void)likeGallery
{
    if ([[ConfigManager me] getSession]) {
        
        CallbackBlock likeBlock = ^(bool succeeded, id userInfo) {
            if (succeeded && self.gallery.liked) {
                LKTask *lkTask = [[LKTask alloc] initGalleryRelation:self.galleryId
                                                                like:![self.gallery.liked boolValue]];
                lkTask.logicCallbackBlock = ^(bool succeeded, id userInfo) {
                    if (succeeded) {
                        likeBtn.text.text = [NSString stringWithFormat:@"%ld", self.gallery.likeCnt];
                    } else {
                        
                    }
                };
                [TaskQueue addTaskToQueue:lkTask];
                [lkTask release];
            }
        };
        
        if (!self.gallery.liked) {
            GalleryTask *task = [[GalleryTask alloc] initGalleryDetail:self.galleryId];
            task.logicCallbackBlock = likeBlock;
            [TaskQueue addTaskToQueue:task];
            [task release];
        } else {
            likeBlock(YES, nil);
        }
    }
}

- (void)deleteGallery
{
    if (self.delegate && self.galleryId) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:@"确认删除？删除后将无法恢复!"
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"删除", nil];
        [alert show];
        [alert release];
    }
}

- (void)shareGallery
{
    if (self.delegate
        && self.galleryId
        && [self.delegate respondsToSelector:@selector(shareGallery:)]) {
        [self.delegate shareGallery:self.galleryId];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [self.delegate deleteGallery:self.galleryId];
    }
}

- (void)updateLayout
{
    user.galleryId = self.galleryId;
    user.page = self.currentIndex;
    user.isComment = NO;
    if (pictures.count > self.currentIndex) {
        GalleryPictureLK *lk = [pictures objectAtIndex:self.currentIndex];
        Picture *pic = [Picture getPictureWithId:lk.pictureId];
        user.voiceLength = pic.voiceLength;
    } else {
        user.voiceLength = self.gallery.introLength;
    }
    
    [user updateLayout];
    
    commentator.galleryId = self.galleryId;
    commentator.isComment = YES;
    commentator.voiceLength = self.gallery.commentLength;
    [commentator updateLayout];
    
    //timestampLabel.text = [TOOL prettyStringFromUnixTime:self.gallery.createTime];
    
    CGSize textSize = [self.gallery.content sizeWithFont:[UIFont systemFontOfSize:16]forWidth:300 lineBreakMode:NSLineBreakByWordWrapping];
    topic.numberOfLines=0;
    topic.lineBreakMode=UILineBreakModeCharacterWrap;
    topic.text = self.gallery.content;
    
    //NSLog(@"wwwwww%@",topic.text);
    //NSLog(@"%d",topic.text.length);
    //NSLog(@"%f",textSize.height);
    if(topic.text.length>19)
    {
        textSize.height=(topic.text.length/19+1)*textSize.height;
    }
    self.stringLength=textSize.height;
    topic.frame = CGRectMake(10, 295, 300, textSize.height);
    likeBtn.text.text = [NSString stringWithFormat:@"%ld", self.gallery.likeCnt];
    [likeBtn centerContent];
    
    commentBtn.text.text = [NSString stringWithFormat:@"%ld", self.gallery.commentCnt];
    [commentBtn centerContent];
    
    if (self.gallery.content.length < 1)
    {
        textSize.height = -3;
    }
    float y = 295 + textSize.height + 3;
    
 
    
    if (self.gallery.userId == [ConfigManager me].userId)
    {
        likeBtn.frame =    CGRectMake(0, y, 81, 55);
        commentBtn.frame = CGRectMake(80, y, 80, 55);
        shareBtn.frame =   CGRectMake(160, y, 80, 55);
        deleteBtn.frame =  CGRectMake(240, y, 80, 55);
        attentionBtnHH.frame=CGRectMake(320, y, 80, 55);
    }
    else
    {
        likeBtn.frame =      CGRectMake(0, y, 81, 55);
        commentBtn.frame=    CGRectMake(80, y, 80, 55);
        attentionBtnHH.frame = CGRectMake(160, y, 80, 55);
        shareBtn.frame =     CGRectMake(240, y, 80, 55);
        deleteBtn.frame=CGRectMake(320, y, 80, 55);
    }
    bg.frame = CGRectMake(0, 0, 320, y+55+textSize.height);
    [self updateScrollView];
}

+ (float)cellHeight:(NSString *)content
{
    CGSize textSize = [content sizeWithFont:[UIFont systemFontOfSize:16]
    forWidth:300 lineBreakMode:NSLineBreakByWordWrapping];
    if (content.length < 1)
    {
        textSize.height = -3;
    }
    else
    {
        textSize.height=(content.length/19+1)*20;
    }

    return 295 + textSize.height + 3 + 56 + 5;
}

- (void)scrollViewTaped:(UITapGestureRecognizer *)tap
{
    
    ImageDetailView *detail = [[ImageDetailView alloc] initWithFrame:delegate.window.bounds];
    detail.backgroundColor = [Shared bbRealWhite];
    
    for (UIView *view in [galleryHolder subviews]) {
        if ([view isKindOfClass:[ImageView class]]) {
            int page = (int)((view.frame.origin.x / galleryHolder.bounds.size.width));
            if (page == paging.currentPage) {
                GalleryPictureLK *lk = [pictures objectAtIndex:page];
                Picture *pic = [Picture getPictureWithId:lk.pictureId];
                [detail setImagePath:pic.imageBig];
                //[detail setImage:((ImageView *)view).image];
            }
        }
    }
    
    [delegate.window addSubview:detail];
    [detail release];
}


#pragma uiscorllview Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //    if (scrollView.contentSize.width > 320) {

    if (scrollView.contentSize.width > 320) {
        int newpage = (int)((galleryHolder.contentOffset.x / galleryHolder.bounds.size.width));
        if (paging.currentPage != newpage) {
            paging.currentPage = newpage;
            user.page = paging.currentPage;
            self.currentIndex = paging.currentPage;
            
            GalleryPictureLK *lk = [pictures objectAtIndex:user.page];
            Picture *pic = [Picture getPictureWithId:lk.pictureId];
            user.voiceLength = pic.voiceLength;
        }
    }
}


@end
