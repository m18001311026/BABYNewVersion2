//
//  InfinitePagingView.h
//  simpleread
//
//  Created by zhang da on 11-4-24.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//


@class InfinitePagingView;


@protocol InfinitePagingViewDelegate <NSObject>

@required

- (void)configPage:(UIView *)page forIndex:(int)index;
- (int)numberOfPages;
- (float)widthForPage;

@optional
- (void)selectedPageChangedTo:(int)newPage;

@end



@interface InfinitePagingView : UIView < UIScrollViewDelegate >{
    
    UIScrollView *holderScrollView;
        
    NSMutableSet *visiblePages;
    NSMutableSet *recycledPages;

}


@property (nonatomic, assign) id <InfinitePagingViewDelegate> delegate;
@property (nonatomic, assign) int currentPage;
@property (nonatomic, assign) BOOL dragging;
@property (nonatomic, readonly) BOOL decelerating;

- (void)reloadData;
- (void)scrollToRowAtIndex:(int)index animated:(BOOL)animated;

@end
