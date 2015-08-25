//
//  RotateImageMenuItemButton.h
//  baby
//
//  Created by zhang da on 14-3-9.
//  Copyright (c) 2014年 zhang da. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RotateMenuDef.h"

@interface RotateImageMenuItemButton : UIControl {
    UIImageView *iconView_;
    UILabel *titleLabel_;
}

@property(nonatomic, copy) RotateMenuItemSelectedBlock selectedBlock;

- (id)initWithTitle:(NSString*)title andIcon:(UIImage*)icon andSelectedBlock:(RotateMenuItemSelectedBlock)block;

@end
