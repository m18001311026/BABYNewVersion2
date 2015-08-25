//
//  AddVoiceViewController.m
//  baby
//
//  Created by zhang da on 14-3-10.
//  Copyright (c) 2014年 zhang da. All rights reserved.
//

#import "AddVoiceViewController.h"
#import "UIButtonExtra.h"
#import "NewGalleryViewController.h"
#import "AudioRecorder.h"
#import "AudioPlayer.h"
#import "UIImageExtra.h"
#import "NSDictionaryExtra.h"
#import "PostTask.h"
#import "TaskQueue.h"
#import "VoiceMask.h"

#import "TopicTask.h"
#import "Topic.h"


#define BOTTOM_HEIGHT 100

@interface AddVoiceViewController (){
    UITableView *_tableView;
    NSInteger _selectedIndexPath;
    UIButton *_selectAgeBtn;
    NSMutableArray *_topics;
    Topic *_selectedTopic;
}


@end

@implementation AddVoiceViewController

- (void)dealloc {
    [voiceMask release];
    [_tableView release];
    [_topics release];
    [super dealloc];
}

- (id)initWithImage:(UIImage *)image {
    self = [super init];
    if (self) {
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
        
        showImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 44, 320, screentHeight - BOTTOM_HEIGHT - 44)];
        showImage.backgroundColor = [UIColor blackColor];
        showImage.contentMode = UIViewContentModeScaleAspectFit;
        [self.view addSubview:showImage];
        showImage.image = image;
        [showImage release];
        
        UIButton *voiceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        voiceBtn.frame = CGRectMake(125, screentHeight - BOTTOM_HEIGHT + 10, 70, 70);
        [voiceBtn setImage:[UIImage imageNamed:@"record_btn"] forState:UIControlStateNormal];
        [voiceBtn addTarget:self action:@selector(startRecord) forControlEvents:UIControlEventTouchDown];
        [voiceBtn addTarget:self action:@selector(stopRecord)
           forControlEvents: UIControlEventTouchUpInside|UIControlEventTouchCancel];
        [voiceBtn addTarget:self action:@selector(cancelRecord) forControlEvents: UIControlEventTouchUpOutside];
        [self.view addSubview:voiceBtn];
        
        playbackBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        playbackBtn.frame = CGRectMake(255, screentHeight - BOTTOM_HEIGHT + 25, 50, 50);
        //[playbackBtn setImage:[UIImage imageNamed:@"cam_btn"] forState:UIControlStateNormal];
        [playbackBtn setTitle:@"回放" forState:UIControlStateNormal];
        [playbackBtn addTarget:self action:@selector(playback) forControlEvents:UIControlEventTouchUpInside];
        playbackBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        playbackBtn.layer.cornerRadius = 2;
        playbackBtn.layer.borderWidth = 1;
        playbackBtn.layer.masksToBounds = YES;
        [self.view addSubview:playbackBtn];
        
        voiceMask = [[VoiceMask alloc] initWithFrame:showImage.frame];
        
        UILabel *info = [[UILabel alloc] initWithFrame:
                         CGRectMake(125, screentHeight - BOTTOM_HEIGHT + 83, 70, 13)];
        info.textAlignment = UITextAlignmentCenter;
        info.backgroundColor = [UIColor clearColor];
        info.textColor = [UIColor whiteColor];
        info.font = [UIFont systemFontOfSize:11];
        info.text = @"按住评画";
        [self.view addSubview:info];
        [info release];
        
        [playbackBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        playbackBtn.enabled = NO;
        
        _selectAgeBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, screentHeight - BOTTOM_HEIGHT + 25, 50, 50)];
        [_selectAgeBtn setTitle:@"分类" forState:UIControlStateNormal];
        [_selectAgeBtn addTarget:self action:@selector(selectAge) forControlEvents:UIControlEventTouchUpInside];
        _selectAgeBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        _selectAgeBtn.layer.cornerRadius = 2;
        _selectAgeBtn.layer.borderWidth = 1;
        _selectAgeBtn.layer.masksToBounds = YES;
        [self.view addSubview:_selectAgeBtn];
    }
    return self;
}

- (id)initWithImage:(UIImage *)image root:(NewGalleryViewController *)root {
    self = [self initWithImage:image];
    if (self) {
        self.root = root;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blackColor];
    bbTopbar.backgroundColor = [UIColor blackColor];
    
    UIButton *back = [UIButton buttonWithCustomStyle:CustomButtonStyleBack];
    [back addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [bbTopbar addSubview:back];
    
    UIButton *done = [UIButton buttonWithCustomStyle:CustomButtonStyleDone];
    done.frame = CGRectMake(284, 7, 30, 30);
    [done addTarget:self action:@selector(uploadPicture) forControlEvents:UIControlEventTouchUpInside];
    [bbTopbar addSubview:done];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.view.frame = CGRectMake(0, 0, 320, screentHeight);
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [AudioPlayer stopPlay];
}


#pragma ui events
- (void)back {
    [ctr popViewControllerAnimated:YES];
}

- (void)startRecord {
    [AudioPlayer stopPlay];
    
    [playbackBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    playbackBtn.enabled = YES;
    
    [AudioRecorder startRecord];
    
    [delegate.window addSubview:voiceMask];
    [voiceMask startAnimation];
}

- (void)stopRecord {
    [playbackBtn setTitleColor:[UIColor colorWithRed:234/255.0 green:166/255.0 blue:31/255.0 alpha:1] forState:UIControlStateNormal];
    playbackBtn.enabled = YES;
    
    [AudioRecorder stopRecord];
    
    [voiceMask removeFromSuperview];
    [voiceMask stopAnimation];
}

- (void)cancelRecord {
    [playbackBtn setTitleColor:[UIColor colorWithRed:234/255.0 green:166/255.0 blue:31/255.0 alpha:1] forState:UIControlStateNormal];
    playbackBtn.enabled = YES;
    
    [AudioRecorder stopRecord];
    
    [voiceMask removeFromSuperview];
    [voiceMask stopAnimation];
}

- (void)playback {
    [AudioPlayer startPlayFile:[AudioRecorder cafFile] finished:^{
        
    }];
}

- (void)uploadPicture
{
    if (self.isUploading)
    {
        [UI showAlert:@"请等待图片上传完成"];
        return;
    }
    
//    if (_selectedTopic == nil)
//    {
//        [UI showAlert:@"请选择分类"];
//        return;
//    }
    
    NSTimeInterval length = [AudioRecorder voiceLength];
    
    
    
        self.isUploading = YES;
        [UI showIndicator];
        
        NSData *mp3 = [AudioRecorder dumpMP3];
        
        NSData*imageData = UIImageJPEGRepresentation(showImage.image, 0.5);
        UIImage * image=[UIImage imageWithData:imageData];
    
    
    
        PostTask *task = [[PostTask alloc] initNewPicture:image
                                                    voice:mp3
                                                   length:length];
        
        
        NSLog(@"unKnown img is %@",showImage.image);
        
        
        task.logicCallbackBlock = ^(bool succeeded, id userInfo)
        {
            
            if (succeeded)
                
            {
                NSDictionary *dict = (NSDictionary *)userInfo;
                NSLog(@"userInfo is equle to %@",userInfo);
                //         NSLog(@"pictureID is %@",[userInfo objectForKey:@"pictureId"]);
                
                int picId = [dict intForKey:@"pictureId"];
                if (picId > 0)
                    
                    
                    
                {
                    
                    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                    dispatch_async(queue, ^{
                        UIImage *img = [image decodedImageToSize:CGSizeMake(200, 200) fill:YES];
                        //chulijian
                        //                    NSData*imageData = UIImageJPEGRepresentation(img, 0.75);
                        //                        UIImage * image=[UIImage imageWithData:imageData];
                        //
                        //                    //chulijian
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            self.isUploading = NO;
                            [UI hideIndicator];
                            [UI showAlert:@"图片添加成功"];
                            
                            if (self.root) {
                                
                                [self.root addPicture:img voice:[AudioRecorder cafFile] id:[dict intForKey:@"pictureId"]];
                                self.root.topic = _selectedTopic;
                                [ctr popToViewController:self.root animation:ViewSwitchAnimationSwipeL2R];
                            }
                        });
                    });
                    return;
                }
            }
            
            self.isUploading = NO;
            [UI hideIndicator];
            [UI showAlert:@"图片添加失败，请重试"];
        };
        [TaskQueue addTaskToQueue:task];
        [task release];
    
//    else {
//        [UI showAlert:@"语音时间不足1s"];
//    }

    
    
//    if (length >= 1)
//    {
//        self.isUploading = YES;
//        [UI showIndicator];
//        
//        NSData *mp3 = [AudioRecorder dumpMP3];
//        
//        NSData*imageData = UIImageJPEGRepresentation(showImage.image, 0.5);
//        UIImage * image=[UIImage imageWithData:imageData];
//        
//        PostTask *task = [[PostTask alloc] initNewPicture:image
//                                                    voice:mp3
//                                                   length:length];
//        
//        
//        NSLog(@"unKnown img is %@",showImage.image);
//        
//        
//        task.logicCallbackBlock = ^(bool succeeded, id userInfo)
//        {
//            
//            if (succeeded)
//                
//            {
//                NSDictionary *dict = (NSDictionary *)userInfo;
//                NSLog(@"userInfo is equle to %@",userInfo);
//                //         NSLog(@"pictureID is %@",[userInfo objectForKey:@"pictureId"]);
//                
//                int picId = [dict intForKey:@"pictureId"];
//                if (picId > 0)
//                    
//                    
//                    
//                {
//                    
//                    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//                    dispatch_async(queue, ^{
//                        UIImage *img = [image decodedImageToSize:CGSizeMake(200, 200) fill:YES];
//                        //chulijian
//                        //                    NSData*imageData = UIImageJPEGRepresentation(img, 0.75);
//                        //                        UIImage * image=[UIImage imageWithData:imageData];
//                        //
//                        //                    //chulijian
//                        dispatch_async(dispatch_get_main_queue(), ^{
//                            
//                            self.isUploading = NO;
//                            [UI hideIndicator];
//                            [UI showAlert:@"图片添加成功"];
//                            
//                            if (self.root) {
//                                
//                                [self.root addPicture:img voice:[AudioRecorder cafFile] id:[dict intForKey:@"pictureId"]];
//                                self.root.topic = _selectedTopic;
//                                [ctr popToViewController:self.root animation:ViewSwitchAnimationSwipeL2R];
//                            }
//                        });
//                    });
//                    return;
//                }
//            }
//            
//            self.isUploading = NO;
//            [UI hideIndicator];
//            [UI showAlert:@"图片添加失败，请重试"];
//        };
//        [TaskQueue addTaskToQueue:task];
//        [task release];
//    } else {
//        [UI showAlert:@"语音时间不足1s"];
//    }
}



- (void)selectAge {
    
    UIView *tableViewBg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_width, kScreen_height)];
    tableViewBg.tag = 1002;
    tableViewBg.backgroundColor = [[[UIColor alloc] initWithRed:0 green:0 blue:0 alpha:0.8] autorelease];
    [self.view addSubview:tableViewBg];
    [tableViewBg release];
    
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(20, 60, (kScreen_width-40), kScreen_height - 150) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [tableViewBg addSubview:_tableView];
    
    _tableView.tableFooterView = [[[UIView alloc] init] autorelease];
    
    TopicTask *task = [[TopicTask alloc] initTopicList];
    task.logicCallbackBlock = ^(bool succeeded, id userInfo) {
        
        if (succeeded) {
            NSDictionary *dict = (NSDictionary *)userInfo;
            
            if (dict[@"normal"]) {
                //                [_topics addObjectsFromArray:dict[@"normal"]];
                //                _topics = [dict[@"normal"] copy];
                if (_topics != nil) {
                    [_topics release];
                }
                _topics = [[NSMutableArray alloc] init];
                for (Topic *topic in dict[@"normal"]) {
                    if (topic.icon != nil) {
                        //                        Topic *atopic = [[Topic alloc] init];
                        //                        atopic.content = topic.content;
                        [_topics addObject:topic];
                    }
                }
                
            }
            [_tableView reloadData];
        }
        
    };
    [TaskQueue addTaskToQueue:task];
    [task release];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _topics.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
    }
    
    NSLog(@"%@", _topics);
    
    Topic *topic = _topics[indexPath.row];
    cell.textLabel.text = (NSString *)topic.content;
    if (indexPath.row == _selectedIndexPath) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    _selectedIndexPath = indexPath.row;
    UIView *tableViewBg = [self.view viewWithTag:1002];
    [tableViewBg removeFromSuperview];
    
    
    Topic *topic = _topics[indexPath.row];
    //    NSString *title = (NSString *)topic.content;
    _selectedTopic = topic;
    //    [_selectAgeBtn setTitle:title forState:UIControlStateNormal];
}

@end
