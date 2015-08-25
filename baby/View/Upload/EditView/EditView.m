//
//  EditView.m
//  baby
//
//  Created by zhang da on 14-3-18.
//  Copyright (c) 2014年 zhang da. All rights reserved.
//

#import "EditView.h"
#import "AudioRecorder.h"
#import "AudioPlayer.h"
#import "VoiceMask.h"

@implementation EditView

- (void)dealloc {
    [inputView release];
    [voiceBtn release];
    [voiceMask release];
    [delBtn release];
    [self removeKeyboardNotifications];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"chuanhua" object:nil];
    
    self.delegate = nil;
    
    [super dealloc];
}

- (void)setEditMode:(EditMode)editMode {
    if (_editMode != editMode) {
        _editMode = editMode;
        if (_editMode == TextMode)
        {
            [self addSubview:inputView];
            [voiceBtn removeFromSuperview];
            [modeSwitchBtn setTitle:@"音" forState:UIControlStateNormal];
        }
         else
        {
            [self addSubview:voiceBtn];
            [inputView removeFromSuperview];
                [modeSwitchBtn setTitle:@"字" forState:UIControlStateNormal];
        }
    }
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(cccttt:) name:@"chuanhua" object:nil];

    
}

- (void)cccttt:(NSNotification *)noti
{
    self.just=[noti object];
    if(self.just)
    {
        [self performSelector:@selector(modeSwitch)];
        
        NSLog(@"10086");
    }
    
}



- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
 
    
    if (self) {
        
        
        _i=0;
        
        _editMode = VoiceMode;
        
        self.backgroundColor = [UIColor colorWithWhite:1 alpha:.6];
        
        contentHolder = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
        contentHolder.backgroundColor = [UIColor colorWithWhite:1 alpha:.6];
        [self addSubview:contentHolder];
        [contentHolder release];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
        line.backgroundColor = [UIColor colorWithRed:234/255.0 green:166/255.0 blue:31/255.0 alpha:1];
        [self addSubview:line];
        [line release];
        
        modeSwitchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        modeSwitchBtn.frame = CGRectMake(12, 12, 36, 36);
        [modeSwitchBtn setTitleColor:[UIColor colorWithRed:234/255.0 green:166/255.0 blue:31/255.0 alpha:1] forState:UIControlStateNormal];
        modeSwitchBtn.layer.borderColor = [UIColor colorWithRed:234/255.0 green:166/255.0 blue:31/255.0 alpha:1].CGColor;
        [modeSwitchBtn setTitle:@"字" forState:UIControlStateNormal];
        modeSwitchBtn.layer.borderWidth = 1;
        modeSwitchBtn.layer.masksToBounds = YES;
        modeSwitchBtn.layer.cornerRadius = 18;
        [modeSwitchBtn addTarget:self action:@selector(modeSwitch) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:modeSwitchBtn];
        
        inputView = [[UITextView alloc] initWithFrame:CGRectMake(60, 12, 248, 36)];
        inputView.layer.borderColor = [UIColor colorWithRed:234/255.0 green:166/255.0 blue:31/255.0 alpha:1].CGColor;
        inputView.font = [UIFont systemFontOfSize:14];
        inputView.delegate = self;
        inputView.layer.borderWidth = 1;
        inputView.layer.masksToBounds = YES;
        inputView.tag = 2000;
        inputView.layer.cornerRadius = 3;
      //  [self addSubview:inputView];
        
        voiceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        voiceBtn.frame = CGRectMake(60, 12, 248, 36);
        voiceBtn.backgroundColor = [UIColor colorWithRed:234/255.0 green:166/255.0 blue:31/255.0 alpha:1];
        voiceBtn.layer.cornerRadius = 3;
        voiceBtn.layer.masksToBounds = YES;
        [voiceBtn setTitle:@"按住评论" forState:UIControlStateNormal];
        [voiceBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        voiceBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        voiceBtn.titleLabel.textAlignment = UITextAlignmentCenter;
        [voiceBtn addTarget:self action:@selector(startRecord)
           forControlEvents:UIControlEventTouchDown];
        [voiceBtn addTarget:self action:@selector(stopRecord)
           forControlEvents: UIControlEventTouchUpInside|UIControlEventTouchCancel];
        [voiceBtn addTarget:self action:@selector(cancelRecord)
           forControlEvents:UIControlEventTouchUpOutside];
//        [voiceBtn addTarget:self action:@selector(showDelBtn)
//           forControlEvents:UIControlEventTouchDragOutside];
//        [voiceBtn addTarget:self action:@selector(dismissDelBtn)
//           forControlEvents:UIControlEventTouchDragInside];
        [voiceBtn retain];
        [self addSubview:voiceBtn];
        
        voiceMask = [[VoiceMask alloc] initWithFrame:
                     CGRectMake(0, 20, 320, screentContentHeight - self.frame.size.height)];
        
        delBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        delBtn.frame = CGRectMake(0, 0, 50, 50);
        delBtn.center = voiceMask.center;
        delBtn.backgroundColor = [UIColor colorWithRed:234/255.0 green:166/255.0 blue:31/255.0 alpha:1];
        delBtn.layer.cornerRadius = 4;
        delBtn.layer.masksToBounds = YES;
        [delBtn addTarget:self action:@selector(dismissDelBtn)
         forControlEvents:UIControlEventTouchDragOutside];
        [delBtn addTarget:self action:@selector(delRecord)
         forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchUpOutside];
        [delBtn retain];
        
        [self registerKeyboardNotifications];
    }
    return self;
}


#pragma mark keyboard
- (void)registerKeyboardNotifications {
  
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(justChu:) name:@"chuanhua" object:nil];
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification object:nil];
   
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

-(void)removeKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

//- (void)keyboardWillShow:(NSNotification*)notification {
//}

- (void)keyboardDidShow:(NSNotification*)notification
{
    if (![inputView isFirstResponder]) {
        return;
    }
    
    NSDictionary* info = [notification userInfo];
    CGRect endFrame = [[info valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    [UIView animateWithDuration:0.3 animations:^{
        CGRect originFrame = self.frame;
        if(!_i){
        originFrame.origin.y = originFrame.origin.y-endFrame.size.height;
        self.frame =originFrame;
           _i++;
        }
        
       
    }];
    _i=1;
}

- (void)keyboardWillHide:(NSNotification*)notification
{
    if (self.frame.origin.y + self.frame.size.height < screentContentHeight) {
        NSDictionary* info = [notification userInfo];
        CGRect endFrame = [[info valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
        [UIView animateWithDuration:0.3 animations:^{
            CGRect originFrame = self.frame;
            originFrame.origin.y += endFrame.size.height;
            self.frame = originFrame;
        }];
    }
}
- (void)justChu:(NSNotification *)justChu
{
    self.justify=[justChu object];

}

#pragma mark uitextview delegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Sundy" object:textView.text userInfo:nil];
        
        [textView resignFirstResponder];
        if (self.delegate && [self.delegate respondsToSelector:@selector(newText:)])
        {
            [self.delegate newText:textView.text];
        }
        return NO;
    }
    return YES;
}


#pragma mark ui events
- (void)modeSwitch
{

    self.editMode = (self.editMode == TextMode? VoiceMode: TextMode);
}

- (void)startRecord
{
    [delBtn removeFromSuperview];

    [AudioRecorder startRecord];

    [delegate.window addSubview:voiceMask];
    [voiceMask startAnimation];
}

- (void)stopRecord
{
    [AudioRecorder stopRecord];
    [voiceMask removeFromSuperview];
    [voiceMask stopAnimation];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(newVoice:length:)]) {
        [self.delegate newVoice:[AudioRecorder dumpMP3] length:[AudioRecorder voiceLength]];
    }
}

- (void)cancelRecord
{
    [AudioRecorder stopRecord];
    [voiceMask removeFromSuperview];
    [voiceMask stopAnimation];
}

- (void)resetText
{
    inputView.text = @"";
}

- (void)showDelBtn
{
    [voiceMask addSubview:delBtn];
    [voiceBtn resignFirstResponder];
    [delBtn becomeFirstResponder];
}

- (void)dismissDelBtn
{
    [voiceBtn becomeFirstResponder];
    [delBtn resignFirstResponder];
    [delBtn removeFromSuperview];
}

- (void)delRecord
{
    NSLog(@"del");
}


@end
