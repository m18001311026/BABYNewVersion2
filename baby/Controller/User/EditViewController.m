//
//  RegisterViewController.m
//  baby
//
//  Created by zhang da on 14-3-2.
//  Copyright (c) 2014年 zhang da. All rights reserved.
//

#import "EditViewController.h"
#import "UIButtonExtra.h"
#import "ImageView.h"
#import "ImagePickerController.h"

#import "User.h"
#import "MemContainer.h"
#import "ConfigManager.h"

#import "UserTask.h"
#import "TaskQueue.h"

@interface EditViewController ()

@end

@implementation EditViewController

- (void)dealloc {
    [nickName release];
    [birthday release];
    [qq release];
    [weixin release];
    [ifJoin release];
    [birthdayPicker release];
    [avatar release];
    self.callback = nil;

    [super dealloc];
    
}

- (id)initWithCallback:(EditCallback)callback {
    self = [super init];
    if (self) {
        self.callback = callback;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setViewTitle:@"编辑信息"];
    bbTopbar.backgroundColor = [UIColor colorWithRed:234/255.0 green:166/255.0 blue:31/255.0 alpha:1];
    
    UIButton *back = [UIButton buttonWithCustomStyle:CustomButtonStyleBack];
    [back addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [bbTopbar addSubview:back];
    
    editTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, 320, screentContentHeight - 44)
                                                 style:UITableViewStylePlain];
    if ([editTable respondsToSelector:@selector(setSeparatorInset:)]) {
        [editTable setSeparatorInset:UIEdgeInsetsZero];
    }
    editTable.delegate = self;
    editTable.dataSource = self;
    editTable.scrollEnabled = YES;
    editTable.backgroundColor = [Shared bbWhite];
    [self.view addSubview:editTable];
    [editTable release];
    [editTable reloadData];
    
    UIButton *done = [UIButton buttonWithCustomStyle:CustomButtonStyleDone];
    done.frame = CGRectMake(283, 7, 30, 30);
    [done addTarget:self action:@selector(doEdit) forControlEvents:UIControlEventTouchUpInside];
    [bbTopbar addSubview:done];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    tap.cancelsTouchesInView = NO;
    [editTable addGestureRecognizer:tap];
    [tap release];
    
//    UIButton *loginBtn = [UIButton simpleButton:@"确定" y:410];
//    [loginBtn addTarget:self action:@selector(doRegister) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:loginBtn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (userFlags.initAppear) {
        [self loadUserDetail];
    }
}


#pragma mark ui event
- (void)loadUserDetail {
    CallbackBlock update = ^(bool successful, id userInfo) {
        if (successful) {
            User *user = [User getUserWithId:[ConfigManager me].userId];
            if (user) {
                avatar.imagePath = user.avatarMid;
                nickName.text = user.showName;
                birthday.text = [TOOL dateString:[TOOL dateFromUnixTime:user.birthday]];
                qq.text = user.qq;
                weixin.text = user.weixin;
            }
        } else {
            [UI showAlert:@"加载用户信息失败，请稍后重试"];
        }
    };

    User *user = [User getUserWithId:[ConfigManager me].userId];
    if (!user) {
        UserTask *task = [[UserTask alloc] initUserDetail:[ConfigManager me].userId];
        task.logicCallbackBlock = update;
        [TaskQueue addTaskToQueue:task];
        [task release];
    } else {
        update(YES, nil);
    }
}

- (void)back {
    [ctr popViewControllerAnimated:YES];
}

- (void)dismissKeyboard {
    [nickName resignFirstResponder];
    [birthday resignFirstResponder];
    [qq resignFirstResponder];
    [weixin resignFirstResponder];
    [birthdayPicker removeFromSuperview];
    
    editTable.contentInset = UIEdgeInsetsZero;
}

- (void)doEdit
{
    [self dismissKeyboard];
    [UI showIndicator];
    
    UserTask *editTask = [[UserTask alloc] initEdit:nickName.text
                                                 qq:qq.text
                                             weixin:weixin.text
                                           birthday:birthdayPicker.date
                                             gender:0
                                             avatar:avatar.image
                                               city:0];
    editTask.logicCallbackBlock = ^(bool successful, id userInfo) {
        [UI hideIndicator];
        
        if (successful) {
            UserTask *task = [[UserTask alloc] initUserDetail:[ConfigManager me].userId];
            [TaskQueue addTaskToQueue:task];
            [task release];
            
            self.callback(YES);
            self.callback = nil;
            
            [ctr popViewControllerAnimated:YES];
        } else {
            [UI showAlert:@"保存失败，请稍后重试"];
        }
    };
    [TaskQueue addTaskToQueue:editTask];
    [editTask release];
}

- (void)tap:(UITapGestureRecognizer *)tap {
    [self dismissKeyboard];
}

- (void)chooseDate:(UIDatePicker *)picker {
    NSLog(@"%@", [TOOL dateString:birthdayPicker.date]);
    birthday.text = [TOOL dateString:birthdayPicker.date];
}


#pragma table view section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else {
        return 5;
    }
}

- (UITextField *)getField {
    UITextField *field = [[UITextField alloc] initWithFrame:CGRectMake(80, 5, 230, 34)];
    field.font = [UIFont systemFontOfSize:16];
    field.delegate = self;
    field.backgroundColor = [UIColor clearColor];
    field.clearButtonMode = UITextFieldViewModeWhileEditing;
    field.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    field.textColor = [UIColor grayColor];
    return [field autorelease];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell= [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                  reuseIdentifier:nil] autorelease];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.contentView.backgroundColor = [Shared bbWhite];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 65, 34)];
    title.font = [UIFont systemFontOfSize:16];
    title.backgroundColor = [UIColor clearColor];
    title.textColor = [UIColor lightGrayColor];
    [cell addSubview:title];
    [title release];
    
    if (indexPath.section == 0) {
        title.text = @"头像";
        title.frame = CGRectMake(10, 41, 65, 18);
        if (!avatar) {
            avatar = [[ImageView alloc] initWithFrame:CGRectMake(80, 15, 70, 70)];
            avatar.layer.cornerRadius = 35;
            avatar.layer.borderColor = [UIColor whiteColor].CGColor;
            avatar.layer.borderWidth = 2;
            avatar.layer.masksToBounds = YES;
        }
        [cell addSubview:avatar];
    } else {
        if (indexPath.row == 0) {
            title.text = @"昵称";
            if (!nickName) {
                nickName = [[self getField] retain];
            }
            [cell addSubview:nickName];
        } else if (indexPath.row == 1) {
            title.text = @"生日";
            if (!birthday) {
                birthday = [[self getField] retain];
            }
            [cell addSubview:birthday];
        } else if (indexPath.row == 2) {
            title.text = @"QQ";
            if (!qq) {
                qq = [[self getField] retain];
            }
            [cell addSubview:qq];
        } else if (indexPath.row == 3) {
            title.text = @"微信";
            if (!weixin) {
                weixin = [[self getField] retain];
            }
            [cell addSubview:weixin];
        } else if (indexPath.row == 4) {
            title.frame = CGRectMake(10, 5, 160, 34);
            title.text = @"是否在宝贝计画学习";
            
            if (!ifJoin) {
                ifJoin = [[SimpleSegment alloc] initWithFrame:CGRectMake(180, 7, 130, 30)
                                                       titles:@[@"是", @"否"]];
                ifJoin.selectedTextColor = [UIColor whiteColor];
                ifJoin.selectedBackgoundColor = [UIColor colorWithRed:234/255.0 green:166/255.0 blue:31/255.0 alpha:1];
                ifJoin.normalTextColor = [UIColor colorWithRed:234/255.0 green:166/255.0 blue:31/255.0 alpha:1];
                ifJoin.normalBackgroundColor = [UIColor whiteColor];
                ifJoin.borderColor = [UIColor colorWithRed:234/255.0 green:166/255.0 blue:31/255.0 alpha:1];
                ifJoin.delegate = self;
                ifJoin.layer.cornerRadius = 2;
                [ifJoin updateLayout];
            }
            //[ifJoin setTintColor:[UIColor colorWithRed:234/255.0 green:166/255.0 blue:31/255.0 alpha:1]];
            //[ifJoin setSelectedSegmentIndex:0];
            [cell addSubview:ifJoin];
        }
    }

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 100;
    }
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        ImagePickerController *imgPicker = [[ImagePickerController alloc] initWithCallback:^(UIImage *image) {
            avatar.image = image;
        } editable:YES];
        [ctr pushViewController:imgPicker animation:ViewSwitchAnimationSwipeR2L];
        [imgPicker release];
    }
}


#pragma mark uitextfield delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    editTable.contentInset = UIEdgeInsetsMake(0, 0, 240, 0);
    if (birthdayPicker) {
        [birthdayPicker removeFromSuperview];
    }

    if (textField == nickName) {
        [editTable setContentOffset:CGPointMake(0, 100) animated:YES];
    } else if (textField == birthday) {
        [self dismissKeyboard];
        editTable.contentInset = UIEdgeInsetsMake(0, 0, 240, 0);
        [editTable setContentOffset:CGPointMake(0, 130) animated:YES];
        if (!birthdayPicker) {
            birthdayPicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, screentContentHeight - 200, 320, 200)];
            birthdayPicker.backgroundColor = [UIColor colorWithRed:234/255.0 green:166/255.0 blue:31/255.0 alpha:1];
            birthdayPicker.datePickerMode = UIDatePickerModeDate;
            birthdayPicker.maximumDate = [NSDate date];
            NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_cn"];
            birthdayPicker.locale = locale;
            [locale release];
            [birthdayPicker addTarget:self action:@selector(chooseDate:) forControlEvents:UIControlEventValueChanged];
            
            User *user = [User getUserWithId:[ConfigManager me].userId];
            birthdayPicker.date = [TOOL dateFromUnixTime:user.birthday];
        }
        [self.view addSubview:birthdayPicker];
        return NO;
    } else if (textField == qq) {
        [editTable setContentOffset:CGPointMake(0, 160) animated:YES];
    } else if (textField == weixin) {
        [editTable setContentOffset:CGPointMake(0, 190) animated:YES];
    } else {
        [self dismissKeyboard];
        [editTable setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == nickName) {
        [birthday becomeFirstResponder];
    } else if (textField == birthday) {
        [qq becomeFirstResponder];
    } else if (textField == qq) {
        [weixin becomeFirstResponder];
    } else {
        [self dismissKeyboard];
    }
    return YES;
}


#pragma mark simple segment delegate
- (void)segmentSelected:(int)index {
    
}


@end
