//
//  LessonCommentView.m
//  baby
//
//  Created by zhang da on 14-3-25.
//  Copyright (c) 2014年 zhang da. All rights reserved.
//

#import "LessonCommentView.h"
#import "UIButtonExtra.h"
#import "LCommentCell.h"
#import "AudioPlayer.h"
#import "AudioPlayer.h"
#import "Gallery.h"
#import "LessonTask.h"
#import "PostTask.h"
#import "TaskQueue.h"


#define PAGESIZE 10
#define EDITVIEW_HEIGHT 60


@interface LessonCommentView ()

@property (nonatomic, assign) long playingCommentId;

@end


@implementation LessonCommentView

- (void)dealloc {
    [comments release];
    comments = nil;
    
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame lesson:(long)lessonId {
    self = [super initWithFrame:frame];
    if (self) {

        comments = [[NSMutableArray alloc] initWithCapacity:0];
        self.lessonId = lessonId;
        
        commentTable = [[PullTableView alloc] initWithFrame:CGRectMake(0, 0, 320, frame.size.height - EDITVIEW_HEIGHT)
                                                      style:UITableViewStylePlain];
        commentTable.delegate = self;
        commentTable.dataSource = self;
        commentTable.pullDelegate = self;
        commentTable.pullBackgroundColor = [Shared bbWhite];
        commentTable.backgroundColor = [Shared bbWhite];
        [commentTable setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
        commentTable.separatorColor = [UIColor whiteColor];
        if ([commentTable respondsToSelector:@selector(setSeparatorInset:)]) {
            [commentTable setSeparatorInset:UIEdgeInsetsZero];
        }
        [self addSubview:commentTable];
        [commentTable release];
        
        editView = [[EditView alloc] initWithFrame:
                    CGRectMake(0, frame.size.height - EDITVIEW_HEIGHT, 320, EDITVIEW_HEIGHT)];
        editView.delegate = self;
        [self addSubview:editView];
        [editView release];
        
        currentPage = 1;
        commentTable.isRefreshing = YES;
        [self loadComment];
    }
    return self;
}

#pragma mark ui event
- (void)back {
    [ctr popViewControllerAnimated:YES];
}

- (void)loadComment {
    LessonTask *task = [[LessonTask alloc] initLCommentList:self.lessonId
                                                       page:currentPage
                                                      count:PAGESIZE];
    task.logicCallbackBlock = ^(bool succeeded, id userInfo) {
        if (succeeded) {
            if (currentPage == 1) {
                [comments removeAllObjects];
            }
            if (userInfo) {
                [comments addObjectsFromArray:(NSArray *)userInfo];
            }
            [commentTable reloadData];
        }
        
        [commentTable stopLoading];
        
        if ([((NSArray *)userInfo) count] < PAGESIZE) {
            commentTable.hasMore = NO;
        } else {
            commentTable.hasMore = YES;
        }
        
        if (comments.count == 0) {
            [commentTable showPlaceHolder:@"还没有评价哦，快来评价吧"];
        } else {
            [commentTable showPlaceHolder:nil];
        }
    };
    [TaskQueue addTaskToQueue:task];
    [task release];
}


#pragma table view section
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return comments.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (void)configCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    if (comments.count > indexPath.row) {
        LCommentCell *cCell = (LCommentCell *)cell;
        cCell.commentId = [[comments objectAtIndex:indexPath.row] longValue];
        if (cCell.commentId == self.playingCommentId) {
            cCell.loadingVoice = YES;
        } else {
            cCell.loadingVoice = NO;
        }
        [cCell updateLayout];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"commentcell";
    LCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[[LCommentCell alloc] initWithStyle:UITableViewCellStyleDefault
                                   reuseIdentifier:cellId] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
    }
    [self configCell:cell atIndexPath:indexPath];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < comments.count - 1) {
        long commentId = [[comments objectAtIndex:indexPath.row] longValue];
        return [LCommentCell height:commentId];
    }
    return DEFAULTCOMMENT_HEIGHT;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *bg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, EDITVIEW_HEIGHT)];
    bg.backgroundColor = [Shared bbWhite];
    return [bg autorelease];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    }
    return EDITVIEW_HEIGHT;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}


#pragma mark pull table view delegate
- (void)pullTableViewDidTriggerRefresh:(PullTableView*)pullTableView {
    currentPage = 1;
    [self loadComment];
}

- (void)pullTableViewDidTriggerLoadMore:(PullTableView*)pullTableView {
    currentPage ++;
    [self loadComment];
}


#pragma mark editview delegate
- (void)newVoice:(NSData *)mp3 length:(int)length
{
    if (length >= 3)
    {
        PostTask *task = [[PostTask alloc] initNewLCommentForLesson:self.lessonId
                                                            replyTo:nil
                                                              voice:mp3
                                                             length:length
                                                            content:nil];
        [UI showIndicator];
        task.logicCallbackBlock = ^(bool succeeded, id userInfo) {
            if (succeeded) {
                [self loadComment];
            }
            [UI hideIndicator];
        };
        [TaskQueue addTaskToQueue:task];
        [task release];
    }
    else
    {
        [UI showAlert:@"语音时间不足3s"];
    }
}

- (void)newText:(NSString *)text
{
    PostTask *task = [[PostTask alloc] initNewLCommentForLesson:self.lessonId replyTo:nil voice:nil length:0 content:text];
    
    [UI showIndicator];
    
    task.logicCallbackBlock = ^(bool succeeded, id userInfo)
    {
        if (succeeded)
        {
            [self loadComment];
            [editView resetText];
            [UI hideIndicator];
        }
    };
    
    [TaskQueue addTaskToQueue:task];
    [task release];
}


#pragma mark comment cell delegate
- (void)playVoice:(LCommentCell *)cell url:(NSString *)voicePath {
    [AudioPlayer stopPlay];
    
    if (self.playingCommentId != cell.commentId)
    {
        [Voice getVoice:voicePath
               callback:^(NSString *url, NSData *voice)
        {
                   if ([url isEqualToString:voicePath] && voice)
                   {
                       [AudioPlayer startPlayData:voice finished:^{
                           self.playingCommentId = -1;
                           [commentTable reloadData];
                       }];
                   } else {
                       self.playingCommentId = -1;
                       [commentTable reloadData];
                   }
               }];
        self.playingCommentId = cell.commentId;
    }
    else
    {
        self.playingCommentId = -1;
    }
    
    [commentTable reloadData];
}

- (void)deleteComment:(long)commentId {
    LessonTask *task = [[LessonTask alloc] initDeleteLComment:commentId];
    task.logicCallbackBlock = ^(bool successful, id userInfo) {
        if (successful) {
            [comments removeObject:@(commentId)];
            [commentTable reloadData];
            [UI showAlert:@"删除成功"];
        }
    };
    [TaskQueue addTaskToQueue:task];
    [task release];
}

@end
