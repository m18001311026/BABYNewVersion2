//
//  RegisterViewController.h
//  baby
//
//  Created by zhang da on 14-3-2.
//  Copyright (c) 2014年 zhang da. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BBViewController.h"
#import "SimpleSegment.h"


typedef void ( ^EditCallback )(bool succeeded);

@class ImageView;

@interface EditViewController : BBViewController
<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, SimpleSegmentDelegate> {
    UITableView *editTable;
    
    ImageView *avatar;
    
    UITextField *nickName, *birthday, *qq, *weixin;
    UITextField *joinBB;
    
    SimpleSegment *ifJoin;
    UIDatePicker *birthdayPicker;
    
}

@property (nonatomic, copy) EditCallback callback;

- (id)initWithCallback:(EditCallback)callback;

@end
