//
//  CartTotalView.m
//  baby
//
//  Created by zhang da on 14-3-26.
//  Copyright (c) 2014年 zhang da. All rights reserved.
//

#import "CartTotalView.h"

@implementation CartTotalView

- (void)dealloc {
    
    [super dealloc];
}

- (void)setSelectAll:(bool)selectAll {
    if (_selectAll != selectAll) {
        _selectAll = selectAll;
        
        if (_selectAll) {
            selectAllBtn.backgroundColor = [Shared bbHightlight];
            selectAllInfo.textColor = [Shared bbHightlight];
        } else {
            selectAllBtn.backgroundColor = [UIColor clearColor];
            selectAllInfo.textColor = [UIColor grayColor];
        }
    }
}

- (void)setCount:(int)count {
    if (_count != count) {
        _count = count;
        
        if (_count > 0) {
            [checkoutBtn setTitle:[NSString stringWithFormat:@"结算(%d)", _count]
                         forState:UIControlStateNormal];
            checkoutBtn.backgroundColor = [Shared bbHightlight];
        } else {
            [checkoutBtn setTitle:@"结算" forState:UIControlStateNormal];
            checkoutBtn.backgroundColor = [UIColor lightGrayColor];
        }
    }
}

- (void)setTotal:(float)total {
    if (_total != total) {
        _total = total;
        
        if (_total > 0) {
            totalLabel.text = [NSString stringWithFormat:@"合计：%.2f", _total];
            totalLabel.textColor = [Shared bbHightlight];
        } else {
            totalLabel.text = @"合计：0";
            totalLabel.textColor = [UIColor darkGrayColor];
        }
    }
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [Shared bbWhite];
        self.layer.borderColor = [UIColor whiteColor].CGColor;
        self.layer.borderWidth = 2;
        //height 40

        selectAllBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        selectAllBtn.frame = CGRectMake(5, 11, 18, 18);
        selectAllBtn.clipsToBounds = YES;
        selectAllBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
        selectAllBtn.layer.borderWidth = 2.0;
        selectAllBtn.layer.cornerRadius = 9;
        selectAllBtn.layer.masksToBounds = YES;
        selectAllBtn.backgroundColor = [UIColor clearColor];
        [selectAllBtn addTarget:self action:@selector(toggleSelectAll) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:selectAllBtn];

        selectAllInfo = [[UILabel alloc] initWithFrame:CGRectMake(25, 13, 30, 15)];
        selectAllInfo.text = @"全选";
        selectAllInfo.font = [UIFont systemFontOfSize:14];
        selectAllInfo.textColor = [UIColor grayColor];
        selectAllInfo.backgroundColor = [UIColor clearColor];
        [self addSubview:selectAllInfo];
        [selectAllInfo release];
        
        totalLabel = [[UILabel alloc] initWithFrame:CGRectMake(85, 13, 150, 15)];
        totalLabel.text = @"合计：0";
        totalLabel.font = [UIFont systemFontOfSize:14];
        totalLabel.textAlignment = UITextAlignmentCenter;
        totalLabel.textColor = [UIColor darkGrayColor];
        totalLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:totalLabel];
        [totalLabel release];
        
        checkoutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        checkoutBtn.frame = CGRectMake(245, 10, 70, 20);
        checkoutBtn.layer.cornerRadius = 2;
        checkoutBtn.layer.masksToBounds = YES;
        checkoutBtn.titleLabel.textAlignment = UITextAlignmentCenter;
        [checkoutBtn setTitle:@"结算" forState:UIControlStateNormal];
        checkoutBtn.backgroundColor = [UIColor lightGrayColor];
        checkoutBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [checkoutBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [checkoutBtn addTarget:self action:@selector(checkout) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:checkoutBtn];
    }
    return self;
}

- (void)toggleSelectAll {
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectAllTouched)]) {
        [self.delegate selectAllTouched];
    }
}

- (void)checkout {
    if (self.delegate && [self.delegate respondsToSelector:@selector(checkoutTouched)]) {
        [self.delegate checkoutTouched];
    }
}

@end
