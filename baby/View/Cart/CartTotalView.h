//
//  CartTotalView.h
//  baby
//
//  Created by zhang da on 14-3-26.
//  Copyright (c) 2014年 zhang da. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol CartTotalViewDelegate <NSObject>

@optional
- (void)selectAllTouched;
- (void)checkoutTouched;
@end


@interface CartTotalView : UIView {
    UILabel *selectAllInfo;
    UIButton *selectAllBtn;
    
    UILabel *totalLabel;
    UIButton *checkoutBtn;
}


@property (nonatomic, assign) bool selectAll;
@property (nonatomic, assign) float total;
@property (nonatomic, assign) int count;
@property (nonatomic, assign) id<CartTotalViewDelegate> delegate;

@end
