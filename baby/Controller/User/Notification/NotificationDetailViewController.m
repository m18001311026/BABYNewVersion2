//
//  NotificationDetailViewController.m
//  baby
//
//  Created by zhang da on 14-5-10.
//  Copyright (c) 2014年 zhang da. All rights reserved.
//

#import "NotificationDetailViewController.h"
#import "UIButtonExtra.h"
#import "ImageView.h"
#import "Notification.h"


@interface NotificationDetailViewController ()

@end

@implementation NotificationDetailViewController {
    ImageView *cover;
    UILabel *title, *time, *detail;
}

- (id)initWithNotification:(Notification *)noti {
    self = [super init];
    if (self) {
        UIScrollView *holder = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 44, 320, screentContentHeight - 44)];
        [self.view addSubview:holder];
        holder.contentSize = CGSizeMake(320, 670);
        holder.alwaysBounceVertical = YES;
        [holder release];
        
        title = [[UILabel alloc] init];
        title.font = [UIFont systemFontOfSize:16];
        title.textAlignment = NSTextAlignmentCenter;
        title.backgroundColor = [UIColor clearColor];
        title.textColor = [UIColor blackColor];
        [holder addSubview:title];
        [title release];
        
        time = [[UILabel alloc] init];
        time.font = [UIFont systemFontOfSize:12];
        time.textAlignment = NSTextAlignmentCenter;
        time.backgroundColor = [UIColor clearColor];
        time.textColor = [UIColor lightGrayColor];
        [holder addSubview:time];
        [time release];
        
        cover = [[ImageView alloc] init];
        [holder addSubview:cover];
        [cover release];
        
        detail = [[UILabel alloc] init];
        detail.font = [UIFont systemFontOfSize:14];
        detail.backgroundColor = [UIColor clearColor];
        detail.textColor = [UIColor grayColor];
        detail.numberOfLines = 0;
        [holder addSubview:detail];
        [detail release];
        
        UIButton *back = [UIButton buttonWithCustomStyle:CustomButtonStyleBack];
        [back addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        [bbTopbar addSubview:back];
        
        float height = 10;
        
        title.frame = CGRectMake(10, height, 300, 17);
        title.text = noti.title;

        height += title.frame.size.height;
        height += 5;
        
        time.frame = CGRectMake(10, height, 300, 13);
        time.text = [NSString stringWithFormat:@"发布时间:%@",
                     [TOOL dateString:[TOOL dateFromUnixTime:noti.createTime]]];
        
        height += time.frame.size.height;
        height += 10;
        
        cover.frame = CGRectMake(0, height, 320, 0);

        if (noti.image) {
            cover.imagePath = noti.image;
            [cover setImagePath:noti.image done:^{
                CGSize imageSize = cover.image.size;
                float dHeight = imageSize.height/imageSize.width*320.0f;
                
                CGRect coverFrame = cover.frame;
                coverFrame.size.height += dHeight;
                cover.frame = coverFrame;
                
                CGRect detailFrame = detail.frame;
                detailFrame.origin.y += dHeight;
                detail.frame = detailFrame;
                
                CGSize cSize = holder.contentSize;
                cSize.height += dHeight;
                holder.contentSize = cSize;
            }];
        }
        
        height += cover.frame.size.height;
        height += 10;

        CGSize detailSize = [noti.content sizeWithFont:[UIFont systemFontOfSize:14]
                                     constrainedToSize:CGSizeMake(300, 100000)];
        detail.frame = CGRectMake(10, height, 300, detailSize.height);
        detail.text = noti.content;
        
        height += detail.frame.size.height;
        height +=10;
        
        holder.contentSize = CGSizeMake(320, height);
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [Shared bbRealWhite];
    [self setViewTitle:@"消息详情"];
    bbTopbar.backgroundColor = [UIColor colorWithRed:234/255.0 green:166/255.0 blue:31/255.0 alpha:1];
}

- (void)back {
    [ctr popViewControllerAnimated:YES];
}


@end
