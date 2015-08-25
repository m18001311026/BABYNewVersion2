//
//  LCommentCell.m
//  baby
//
//  Created by zhang da on 14-3-6.
//  Copyright (c) 2014年 zhang da. All rights reserved.
//

#import "LCommentCell.h"
#import "ImageView.h"
#import "LComment.h"
#import "User.h"
#import "MemContainer.h"
#import "ConfigManager.h"


@interface LCommentCell ()

@property (nonatomic, retain) LComment *comment;

@end


@implementation LCommentCell

- (void)dealloc {
    self.comment = nil;
    self.delegate = nil;
    [voiceBtn release];
    
    [super dealloc];
}

- (void)setCommentId:(long)commentId {
    if (_commentId != commentId)
    {
        _commentId = commentId;
        self.comment = [LComment getCommentWithId:_commentId];
    }
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [Shared bbWhite];
        
        avatar = [[ImageView alloc] initWithImage:[UIImage imageNamed:@"baby_logo.png"]];
        avatar.frame = CGRectMake(10, 10, 40, 40);
        avatar.layer.cornerRadius = 20;
        avatar.layer.borderColor = [UIColor colorWithRed:234/255.0 green:166/255.0 blue:31/255.0 alpha:1].CGColor;
        avatar.layer.borderWidth = 1;
        avatar.layer.masksToBounds = YES;
        [self addSubview:avatar];
        [avatar release];
        
        contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 28, 220, 20)];
        contentLabel.textColor = [UIColor darkGrayColor];
        contentLabel.backgroundColor = [UIColor clearColor];
      //  contentLabel.backgroundColor=[UIColor blackColor];
        
        contentLabel.numberOfLines = 0;
        contentLabel.font = [UIFont systemFontOfSize:DEFAULTFONT];
        [self addSubview:contentLabel];
        [contentLabel release];
        
        voiceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        voiceBtn.frame = CGRectMake(146, (DEFAULTCOMMENT_HEIGHT - 30)/2, DEFAULTVOICE_WIDTH, 26);
        [voiceBtn setBackgroundColor:[UIColor colorWithRed:234/255.0 green:166/255.0 blue:31/255.0 alpha:1]];
        [voiceBtn addTarget:self action:@selector(playVoice) forControlEvents:UIControlEventTouchUpInside];
        [voiceBtn.layer setCornerRadius:13];
        [voiceBtn retain];
        
        loading = [[UIActivityIndicatorView alloc]
                   initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        loading.frame = CGRectMake(DEFAULTVOICE_WIDTH - 20,
                                   (voiceBtn.frame.size.height - 14)/2, 14, 14);
        loading.hidesWhenStopped = YES;
        [voiceBtn addSubview:loading];
        [loading release];
        
        playIndicator = [[UIImageView alloc] initWithFrame:CGRectMake(DEFAULTVOICE_WIDTH - 18,
                                                                      (voiceBtn.frame.size.height - 10)/2, 10, 10)];
        playIndicator.image = [UIImage imageNamed:@"play_indicator"];
        [voiceBtn addSubview:playIndicator];
        [playIndicator release];
        
        voiceLength = [[UILabel alloc] initWithFrame:CGRectMake(6, (voiceBtn.frame.size.height - 14)/2, 30, 14)];
        voiceLength.textColor = [UIColor whiteColor];
        voiceLength.backgroundColor = [UIColor clearColor];
        voiceLength.font = [UIFont systemFontOfSize:12];
        [voiceBtn addSubview:voiceLength];
        [voiceLength release];
        
        deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        deleteBtn.frame = CGRectZero;
        [deleteBtn setImage:[UIImage imageNamed:@"ic_delete.png"] forState:UIControlStateNormal];
        [deleteBtn setImageEdgeInsets:UIEdgeInsetsMake(12, 12, 12, 12)];
        [deleteBtn addTarget:self action:@selector(deleteComment) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:deleteBtn];
    }
    return self;
}

- (void)prepareForReuse {

}

//- (void)drawRect:(CGRect)rect {
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSetLineWidth(context, 0);
//    [[Shared bbWhite] set];
//    CGContextAddRect(context, CGRectMake(0, 0, 320, self.frame.size.height));
//    CGContextDrawPath(context, kCGPathFillStroke);
//    
//    [[UIColor whiteColor] set];
//    CGContextSetLineWidth(context, 1);
//    CGContextMoveToPoint(context, 0, rect.size.height - 1);
//    CGContextAddLineToPoint(context, 320, rect.size.height - 1);
//    CGContextClosePath(context);
//    CGContextDrawPath(context, kCGPathFillStroke);
//}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (void)playVoice {
    if (self.delegate && [self.delegate respondsToSelector:@selector(playVoice:url:)]) {
        [self.delegate playVoice:self url:self.comment.voice];
    }
}

- (void)updateLayout {
    User *user = [User getUserWithId:self.comment.userId];
    avatar.imagePath = user.avatarMid;
    
    if (self.comment.content) {
        [voiceBtn removeFromSuperview];
        
        NSString *text = [NSString stringWithFormat:@"%@: %@", user.showName, self.comment.content];
        CGSize textSize = [text sizeWithFont:[UIFont systemFontOfSize:DEFAULTFONT]
                           constrainedToSize:CGSizeMake(220, INFINITY)
                               lineBreakMode:NSLineBreakByCharWrapping];
        
        if (textSize.height + 10 > DEFAULTCOMMENT_HEIGHT) {
            contentLabel.frame = CGRectMake(60, 5, 220, self.frame.size.height - 10);
        } else {
            contentLabel.frame = CGRectMake(60, (DEFAULTCOMMENT_HEIGHT - textSize.height)/2, 220, textSize.height);
        }
        contentLabel.text = text;
    } else {
        [self addSubview:voiceBtn];

        NSString *text = [NSString stringWithFormat:@"%@: ", user.showName];
        CGSize textSize = [text sizeWithFont:[UIFont systemFontOfSize:DEFAULTFONT]
                           constrainedToSize:CGSizeMake(220, INFINITY)
                               lineBreakMode:NSLineBreakByCharWrapping];
        contentLabel.frame = CGRectMake(60,
                                        (DEFAULTCOMMENT_HEIGHT - DEFAULTFONT + 1)/2,
                                        MIN(textSize.width,220 - DEFAULTVOICE_WIDTH),
                                        DEFAULTFONT + 1);
        contentLabel.text = text;
        voiceBtn.frame = CGRectMake(contentLabel.frame.origin.x + contentLabel.frame.size.width,
                                    (DEFAULTCOMMENT_HEIGHT - 26)/2,
                                    DEFAULTVOICE_WIDTH,
                                    26);
        voiceLength.text = [NSString stringWithFormat:@"%d\"", self.comment.voiceLength];
        if (self.loadingVoice) {
            [loading startAnimating];
            playIndicator.hidden = YES;
        } else {
            [loading stopAnimating];
            playIndicator.hidden = NO;
        }
    }
    
    if (self.comment.userId == [ConfigManager me].userId) {
        deleteBtn.frame = CGRectMake(280, 10, 40, 40);
        deleteBtn.hidden = NO;
    } else {
        deleteBtn.hidden = YES;
        deleteBtn.frame = CGRectZero;
    }
}

- (void)deleteComment {
    if (self.delegate && self.commentId) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:@"确认删除？删除后将无法恢复!"
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"删除", nil];
        [alert show];
        [alert release];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [self.delegate deleteComment:self.commentId];
    }
}

+ (float)height:(long)commentId {
    LComment *comment = [LComment getCommentWithId:commentId];
    User *user = [User getUserWithId:comment.userId];
    
    if (comment.content) {
        NSString *text = [NSString stringWithFormat:@"%@: %@", user.name, comment.content];
        CGSize textSize = [text sizeWithFont:[UIFont systemFontOfSize:DEFAULTFONT]
                           constrainedToSize:CGSizeMake(220, INFINITY)
                               lineBreakMode:NSLineBreakByCharWrapping];
        return MAX(textSize.height + 10, DEFAULTCOMMENT_HEIGHT);
    } else {
        return DEFAULTCOMMENT_HEIGHT;
    }
    
}

@end
