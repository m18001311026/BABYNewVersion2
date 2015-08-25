//
//  ScanQRViewController.h
//  baby
//
//  Created by zhang da on 14-4-19.
//  Copyright (c) 2014年 zhang da. All rights reserved.
//

#import "BBViewController.h"
#import "ZBarSDK.h"

@class ImageView;
@class ScanView;

@interface ScanQRViewController : BBViewController
<ZBarReaderViewDelegate, UIAlertViewDelegate> {
    
    ImageView *avatar;
    UIButton *addFriendBtn;
    ScanView *mask;
}

@end
