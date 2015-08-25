//
//  CartViewController.h
//  baby
//
//  Created by zhang da on 14-3-3.
//  Copyright (c) 2014年 zhang da. All rights reserved.
//

#import "TabbarSubviewController.h"

#import "PullTableView.h"
#import "CartCell.h"
#import "CartTotalView.h"
#import "UPPayPluginDelegate.h"

@interface CartViewController : TabbarSubviewController
<UITableViewDataSource, UITableViewDelegate, PullTableViewDelegate,
UIScrollViewDelegate, CartCellDelegate, CartTotalViewDelegate, UPPayPluginDelegate> {
    
    PullTableView *lessonTable;
    NSMutableArray *lessons;
    NSMutableArray *checkedLessons;
    CartTotalView *total;
    
}

@end
