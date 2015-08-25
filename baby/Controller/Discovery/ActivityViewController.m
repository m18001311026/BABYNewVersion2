//
//  NotificationDetailViewController.m
//  baby
//
//  Created by zhang da on 14-5-10.
//  Copyright (c) 2014年 zhang da. All rights reserved.
//

#import "ActivityViewController.h"
#import "UIButtonExtra.h"
#import "ImageView.h"
#import "Activity.h"
#import "NewGalleryViewController.h"

@interface ActivityViewController ()

@end

@implementation ActivityViewController {
    ImageView *cover;
    UILabel *title, *time, *detail;
}

- (id)initWithActivity:(Activity *)act {
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
        title.text = act.title;
        
        height += title.frame.size.height;
        height += 5;
        
        time.frame = CGRectMake(10, height, 300, 13);
        time.text = [NSString stringWithFormat:@"发布时间:%@",
                     [TOOL dateString:[TOOL dateFromUnixTime:act.createTime]]];
        
        height += time.frame.size.height;
        height += 10;
        
        if (act.icon) {
            cover.imagePath = act.icon;
            cover.frame = CGRectMake(0, height, 320, 200);
        } else {
            cover.frame = CGRectZero;
        }
        
        height += cover.frame.size.height;
        height += 10;
        
        CGSize detailSize = [act.content sizeWithFont:[UIFont systemFontOfSize:14]
                                     constrainedToSize:CGSizeMake(300, 100000)];
        detail.frame = CGRectMake(10, height, 300, detailSize.height);
        detail.text = act.content;
        
        height += detail.frame.size.height;
        height += 40;
        
        UIButton *joinBtn = [UIButton simpleButton:@"参加" y:height];
        [joinBtn addTarget:self action:@selector(joinActivity) forControlEvents:UIControlEventTouchUpInside];
        joinBtn.frame = CGRectMake(20, height, 280, 40);
        [holder addSubview:joinBtn];
        
        height += 50;
        
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
    [self setViewTitle:@"活动详情"];
    bbTopbar.backgroundColor = [UIColor colorWithRed:234/255.0 green:166/255.0 blue:31/255.0 alpha:1];
}

- (void)back {
    [ctr popViewControllerAnimated:YES];
}

- (void)joinActivity {
    NewGalleryViewController *ngVC = [[NewGalleryViewController alloc] init];
    [ngVC setInitContent:[NSString stringWithFormat:@"#%@#", title.text]];
    [ctr pushViewController:ngVC animation:ViewSwitchAnimationSwipeR2L];
    [ngVC release];
}

@end
