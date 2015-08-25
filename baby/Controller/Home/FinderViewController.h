//
//  FinderViewController.h
//  baby
//
//  Created by chenxin on 14-11-11.
//  Copyright (c) 2014年 zhang da. All rights reserved.
//

#import "TabbarSubviewController.h"

@interface FinderViewController : TabbarSubviewController<UITableViewDataSource, UITableViewDelegate>

- (void)reloadData;

@end
