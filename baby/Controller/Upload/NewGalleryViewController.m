//
//  NewGalleryViewController.m
//  baby
//
//  Created by zhang da on 14-3-10.
//  Copyright (c) 2014年 zhang da. All rights reserved.
//

#import "NewGalleryViewController.h"
#import "UIButtonExtra.h"
#import "Picture.h"
#import "PictureThumbView.h"
#import "NewPictureViewController.h"
#import "PostTask.h"
#import "TaskQueue.h"
#import "ShareView.h"
#import "ShareManager.h"
#import "Topic.h"

#import "Macro.h"

#define PICTURE_WIDTH 80
#define PICTURE_MARGIN 10
#define PLACE_HOLDER @"点击图片描述..."


@implementation NewGalleryViewController

- (void)dealloc {
    [pictureList release];
    [thumbViewList release];
    
    [super dealloc];
}

- (id)init {
    self = [super init];
    if (self) {
        self.maxPictureCount = 5;
        
        [[UIApplication sharedApplication] setStatusBarHidden:YES];

        // Initialization code
        pictureHolder = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 44, 320, 100)];
        pictureHolder.backgroundColor = [UIColor whiteColor];
        pictureHolder.alwaysBounceHorizontal = YES;
        [self.view addSubview:pictureHolder];
        [pictureHolder release];
        
        UIView *introBgView = [[UIView alloc] initWithFrame:CGRectMake(10, 144, 300, 120)];
        [self.view addSubview:introBgView];
        introBgView.backgroundColor = [Shared bbWhite];
        [introBgView release];

        introView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, 300, 90)];
        introView.backgroundColor = [UIColor clearColor];
        introView.delegate = self;
        introView.backgroundColor = [UIColor clearColor];
        introView.font = [UIFont systemFontOfSize:15];
        [introBgView addSubview:introView];
        [introView release];

        introViewPlaceHolder = [[UILabel alloc] initWithFrame:CGRectMake(8, 10, 284, 13)];
        introViewPlaceHolder.font = [UIFont systemFontOfSize:15];
        introViewPlaceHolder.backgroundColor = [UIColor clearColor];
        introViewPlaceHolder.textColor = [UIColor grayColor];
        introViewPlaceHolder.text = PLACE_HOLDER;
        introViewPlaceHolder.userInteractionEnabled = NO;
        [introBgView addSubview:introViewPlaceHolder];
        [introViewPlaceHolder release];
        
        UIButton *atBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        atBtn.frame = CGRectMake(40, 90, 70, 30);
        [atBtn setTitle:@"@" forState:UIControlStateNormal];
        [atBtn setTitleColor:[UIColor colorWithRed:234/255.0 green:166/255.0 blue:31/255.0 alpha:1] forState:UIControlStateHighlighted];
        [atBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [atBtn addTarget:self action:@selector(inputAt) forControlEvents:UIControlEventTouchUpInside];
        [introBgView addSubview:atBtn];
        
        UIButton *topicBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        topicBtn.frame = CGRectMake(190, 90, 70, 30);
        [topicBtn setTitle:@"#" forState:UIControlStateNormal];
        [topicBtn setTitleColor:[UIColor colorWithRed:234/255.0 green:166/255.0 blue:31/255.0 alpha:1] forState:UIControlStateHighlighted];
        [topicBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [topicBtn addTarget:self action:@selector(inputTopic) forControlEvents:UIControlEventTouchUpInside];
        [introBgView addSubview:topicBtn];
        
        UIButton *postBtn = [UIButton simpleButton:@"发布" y:screentContentHeight - 50];
        [self.view addSubview:postBtn];
        [postBtn addTarget:self action:@selector(postGallery) forControlEvents:UIControlEventTouchUpInside];
        
        shareView = [[ShareView alloc] initWithFrame:CGRectMake(0, 280, 320, 44)];
        [self.view addSubview:shareView];
        shareView.layer.borderColor = [Shared bbLightGray].CGColor;
        shareView.layer.borderWidth = 1;
        [shareView release];
        
        pictureList = [[NSMutableArray alloc] init];
        thumbViewList = [[NSMutableArray alloc] init];
        
        delegate.window.backgroundColor = [UIColor blackColor];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setViewTitle:@"发布我的画"];
    bbTopbar.backgroundColor = [UIColor blackColor];
    
    UIButton *back = [UIButton buttonWithCustomStyle:CustomButtonStyleBack];
    [back addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [bbTopbar addSubview:back];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self layoutScrollView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (userFlags.initAppear) {
        if (self.maxPictureCount == 1) {
            [self newPicture];
        }
    }

    self.view.frame = CGRectMake(0, 0, 320, screentHeight);
}


#pragma mark utility
- (void)layoutScrollView {
    //remove old ones
    pictureHolder.contentSize = CGSizeZero;
    for (PictureThumbView *subView in thumbViewList) {
        [subView removeFromSuperview];
    }
    [thumbViewList removeAllObjects];
    
    //add new ones
    int width = pictureList.count*PICTURE_WIDTH + (pictureList.count + 1)*PICTURE_MARGIN
    + (pictureList.count < self.maxPictureCount? PICTURE_WIDTH + PICTURE_MARGIN: 0);
    
    pictureHolder.contentSize = CGSizeMake(width, PICTURE_WIDTH + 2*PICTURE_MARGIN);
    for (int i = 0; i < pictureList.count; i ++) {
        Picture *pic = (Picture *)[pictureList objectAtIndex:i];
        
        PictureThumbView *view = [[PictureThumbView alloc] initWithFrame:
                                  CGRectMake(PICTURE_MARGIN*(i+1) + PICTURE_WIDTH*i, PICTURE_MARGIN, PICTURE_WIDTH, PICTURE_WIDTH)];
        [view setImage:pic.localImage];
        view.voiceFile = pic.localVoice;
        [thumbViewList addObject:view];
        [pictureHolder addSubview:view];
        [view release];
    }
    
    if (pictureList.count < self.maxPictureCount) {
        UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        addBtn.frame = CGRectMake(pictureList.count*PICTURE_WIDTH + (pictureList.count + 1)*PICTURE_MARGIN,
                                  PICTURE_MARGIN,
                                  PICTURE_WIDTH,
                                  PICTURE_WIDTH);
        [addBtn setImage:[UIImage imageNamed:@"addpic_btn"] forState:UIControlStateNormal];
        addBtn.backgroundColor = [UIColor clearColor];
        [addBtn addTarget:self action:@selector(newPicture) forControlEvents:UIControlEventTouchUpInside];
        [pictureHolder addSubview:addBtn];
    }
}

- (void)setInitContent:(NSString *)content {
    introView.text = content;
    introViewPlaceHolder.text = @"";
}

- (void)addPicture:(UIImage *)pic voice:(NSString *)file id:(long)pid {
    Picture *picture = [[Picture alloc] init];
    picture.localImage = pic;
    picture.localVoice = file;
    picture._id = pid;
    
    [pictureList addObject:picture];
    [picture release];
    
    [self layoutScrollView];
}


#pragma mark ui event
- (void)back {
    delegate.window.backgroundColor = [UIColor colorWithRed:234/255.0 green:166/255.0 blue:31/255.0 alpha:1];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [ctr popViewControllerAnimated:YES];
}

- (void)newPicture {
    if ([introView isFirstResponder]) {
        [introView resignFirstResponder];
    }
    
    NewPictureViewController *picCtr = [[NewPictureViewController alloc] initWithRoot:self];
    [ctr pushViewController:picCtr animation:ViewSwitchAnimationSwipeR2L];
    [picCtr release];
}

- (void)postGallery {
    if (!pictureList || pictureList.count == 0) {
        [UI showAlert:@"请先增加图片"];
        return;
    }

    NSMutableArray *galleryMapArray = [[NSMutableArray alloc] initWithCapacity:pictureList.count];
    for (Picture *pic in pictureList) {
        if ([pic exportData]) {
            [galleryMapArray addObject:@(pic._id)];
        }
    }
    PostTask *task = [[PostTask alloc] initNewGallery:galleryMapArray
                                              content:introView.text
                                                 city:0];
    task.logicCallbackBlock = ^(bool succeeded, id userInfo) {
        if (succeeded) {
            [UI showAlert:@"图片集添加成功"];
            /**/
            Picture *cover = nil;
            if (pictureList && pictureList.count > 0) {
                Picture *pic = [pictureList objectAtIndex:0];
                cover = [Picture getPictureWithId:pic._id];
            }
            
            [[UIApplication sharedApplication] setStatusBarHidden:NO];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:UserDidAddGalleryNotification
                                                                object:nil];
            
            [ctr popToRootViewControllerWithAnimation:ViewSwitchAnimationBounce];
            
            long galleryId = [[userInfo objectForKey:@"galleryId"] longValue];
            
            // topicId
            
            PostTask *task1 = [[PostTask alloc] initNewGallery:[NSString stringWithFormat:@"%ld", galleryId] topicId:[NSString stringWithFormat:@"%ld", self.topic._id]];
            task1.logicCallbackBlock = ^(bool succeeded, id userInfo) {
                
                NSLog(@"%@", userInfo);
                
            };
            [TaskQueue addTaskToQueue:task1];
            [task1 release];
            
            
            [[ShareManager me] post:[shareView enableWeixin]? ShareTypeWeixiTimeline: ShareTypeAny
                            content:introView.text
                              title:@"宝贝计画"
                           imageUrl:cover.imageMid
                            pageUrl:[NSString stringWithFormat:GALLERY_PAGE, galleryId]
                           soundUrl:cover.voice
                               done:^(bool succeeded) {
                                   
                                   [[ShareManager me] post:[shareView enableQzone]? ShareTypeQQSpace: ShareTypeAny
                                                   content:introView.text
                                                     title:@"宝贝计画"
                                                  imageUrl:cover.imageMid
                                                   pageUrl:[NSString stringWithFormat:GALLERY_PAGE, galleryId]
                                                  soundUrl:cover.voice
                                                      done:^(bool succeeded) {
                                                          
                                                      }];
                               }];
             
                                   
//                                   [[ShareManager me] post:[shareView enableWeibo]? ShareTypeSinaWeibo: ShareTypeAny
//                                                   content:introView.text
//                                                     title:@"宝贝计画APP"
//                                                  imageUrl:cover.imageMid
//                                                   pageUrl:[NSString stringWithFormat:GALLERY_PAGE, galleryId]
//                                                  soundUrl:cover.voice
//                                                      done:^(bool succeeded) {
//                                                          [[ShareManager me] post:[shareView enableQweibo]? ShareTypeTencentWeibo: ShareTypeAny
//                                                                          content:introView.text
//                                                                            title:@"宝贝计画APP"
//                                                                         imageUrl:cover.imageMid
//                                                                          pageUrl:[NSString stringWithFormat:GALLERY_PAGE, galleryId]
//                                                                         soundUrl:cover.voice
//                                                                             done:^(bool succeeded) {
//                                                                                
//                                                                             }];
//                                                      }];
//                               }];
        }
    };
    [TaskQueue addTaskToQueue:task];
    [task release];
    [galleryMapArray release];
    
}

- (void)inputAt {
    introViewPlaceHolder.text = nil;
    [introView becomeFirstResponder];
    introView.text = [NSString stringWithFormat:@"%@ @", introView.text];
}

- (void)inputTopic {
    introViewPlaceHolder.text = nil;
    [introView becomeFirstResponder];
    introView.text = [NSString stringWithFormat:@"%@ ##", introView.text];
    introView.selectedRange = NSMakeRange(introView.text.length - 1, 0);
}


#pragma mark uitextfield delegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    if ([textView.text length] + [text length] - range.length == 0 ){
        introViewPlaceHolder.text = PLACE_HOLDER;
    } else {
        introViewPlaceHolder.text = @"";
    }
    return YES;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    if (!largeScreen) {
        self.view.center = CGPointMake(160, 180);
    }
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    if (!largeScreen) {
        self.view.center = CGPointMake(160, 20 + screentContentHeight/2);
    }
    return YES;
}



@end
