//
//  UploadViewController.m
//  baby
//
//  Created by zhang da on 14-3-9.
//  Copyright (c) 2014年 zhang da. All rights reserved.
//

#import "UploadViewController.h"
#import "NewGalleryViewController.h"
#import "NewPictureViewController.h"

@interface UploadViewController ()

@end

@implementation UploadViewController

- (void)dealloc {
    
    [super dealloc];
}

- (id)init {
    self = [super init];
    if (self) {
        self.view.backgroundColor = [UIColor colorWithWhite:.6 alpha:.6];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelViewCtr)];
        [self.view addGestureRecognizer:tap];
        [tap release];
        
        float posY = (screentContentHeight - 180)/2;
        
        UIButton *singleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        singleBtn.frame = CGRectMake(120, posY, 80, 80);
        singleBtn.layer.cornerRadius = 40;
        singleBtn.backgroundColor = [UIColor colorWithRed:234/255.0 green:166/255.0 blue:31/255.0 alpha:1];
        [singleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [singleBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        [singleBtn setTitle:@"单幅画" forState:UIControlStateNormal];
        singleBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        [singleBtn addTarget:self action:@selector(newSinglePicture) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:singleBtn];
        
        posY += 80;
        posY += 20;
        
        UIButton *multiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        multiBtn.frame = CGRectMake(120, posY, 80, 80);
        multiBtn.layer.cornerRadius = 40;
        multiBtn.layer.borderColor = [UIColor colorWithRed:234/255.0 green:166/255.0 blue:31/255.0 alpha:1].CGColor;
        multiBtn.layer.borderWidth = 2;
        multiBtn.backgroundColor = [UIColor whiteColor];
        [multiBtn setTitleColor:[UIColor colorWithRed:234/255.0 green:166/255.0 blue:31/255.0 alpha:1] forState:UIControlStateNormal];
        [multiBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        [multiBtn setTitle:@"绘本" forState:UIControlStateNormal];
        multiBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        [multiBtn addTarget:self action:@selector(newMultiPicture) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:multiBtn];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark uievent
- (void)cancelViewCtr {
    [ctr popViewControllerAnimated:YES];
}

- (void)newSinglePicture {
    
        NewGalleryViewController *ngVC = [[NewGalleryViewController alloc] init];
    
        ngVC.maxPictureCount = 1;
    
        [ctr pushViewController:ngVC animation:ViewSwitchAnimationNone finished:^{
        
        NewPictureViewController *picCtr = [[NewPictureViewController alloc] initWithRoot:ngVC];

        [ctr pushViewController:picCtr animation:ViewSwitchAnimationBounce];
        [picCtr release];
    }];
    [ngVC release];
}

- (void)newMultiPicture {
    NewGalleryViewController *ngVC = [[NewGalleryViewController alloc] init];
    [ctr pushViewController:ngVC animation:ViewSwitchAnimationBounce];
    [ngVC release];
}


@end
