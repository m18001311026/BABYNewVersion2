//
//  RegisterViewController.m
//  baby
//
//  Created by zhang da on 14-3-2.
//  Copyright (c) 2014年 zhang da. All rights reserved.
//

#import "RegisterViewController.h"
#import "UIButtonExtra.h"

#import "UserTask.h"
#import "TaskQueue.h"
#import "BBExp.h"

#import "IntroducerViewController.h"
#import "MobClick.h"

@interface RegisterViewController ()

@end

@implementation RegisterViewController

- (void)dealloc {
    
    [userName release];
    [validcode release];
    [password release];
    [nickName release];
    [birthday release];
    [qq release];
    [weixin release];
    [ifJoin release];
    [birthdayPicker release];

    [super dealloc];
    
}

- (id)init {
    self = [super init];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setViewTitle:@"注册新用户"];
    bbTopbar.backgroundColor = [UIColor colorWithRed:234/255.0 green:166/255.0 blue:31/255.0 alpha:1];
    
    UIButton *back = [UIButton buttonWithCustomStyle:CustomButtonStyleBack];
    [back addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [bbTopbar addSubview:back];
    
    registerTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, 320, screentContentHeight - 44)
                                                 style:UITableViewStylePlain];
    if ([registerTable respondsToSelector:@selector(setSeparatorInset:)]) {
        [registerTable setSeparatorInset:UIEdgeInsetsZero];
    }
    registerTable.delegate = self;
    registerTable.dataSource = self;
    registerTable.scrollEnabled = YES;
    [self.view addSubview:registerTable];
    [registerTable release];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    tap.cancelsTouchesInView = NO;
    [registerTable addGestureRecognizer:tap];
    [tap release];
    
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
    footer.backgroundColor = [UIColor clearColor];
    registerTable.tableFooterView = footer;
    [footer release];

    UIButton *loginBtn = [UIButton simpleButton:@"确定" y:screentContentHeight - 50];
    [loginBtn addTarget:self action:@selector(doRegister) forControlEvents:UIControlEventTouchUpInside];
    loginBtn.frame = CGRectMake(20, 10, 280, 40);
    [footer addSubview:loginBtn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 注册页面（chenxin）
#pragma table view section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 3;
    } else {
        // 修改部分
        return 2;
//        return 4;
    }
}

- (UITextField *)getField {
    UITextField *field = [[UITextField alloc] initWithFrame:CGRectMake(80, 5, 230, 34)];
    field.font = [UIFont systemFontOfSize:16];
    field.delegate = self;
    field.clearButtonMode = UITextFieldViewModeWhileEditing;
    field.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    field.textColor = [UIColor grayColor];
    return [field autorelease];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell= [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                  reuseIdentifier:nil] autorelease];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 65, 34)];
    title.font = [UIFont systemFontOfSize:16];
    title.textColor = [UIColor lightGrayColor];
    [cell addSubview:title];
    [title release];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            //user name
            title.text = @"手机";
            if (!userName) {
                userName = [[self getField] retain];
            }
            [cell addSubview:userName];
        } else if (indexPath.row == 1) {
            //user password
            title.text = @"验证码";
            
            if (!validcode) {
                validcode = [[self getField] retain];
                validcode.frame = CGRectMake(75, 5, 140, 34);
            }
            [cell addSubview:validcode];
            
            validCodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            validCodeBtn.frame = CGRectMake(220, 7, 80, 30);
            [validCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
            [validCodeBtn setBackgroundColor:[UIColor colorWithRed:234/255.0 green:166/255.0 blue:31/255.0 alpha:1]];
            [validCodeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [validCodeBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
            [validCodeBtn addTarget:self action:@selector(getVerfiCode) forControlEvents:UIControlEventTouchUpInside];
            validCodeBtn.titleLabel.font = [UIFont boldSystemFontOfSize:13];
            [validCodeBtn.layer setCornerRadius:2.0];
            [cell addSubview:validCodeBtn];
        } else {
            title.text = @"密码";
            
            if (!password) {
                password = [[self getField] retain];
                password.secureTextEntry = YES;
            }
            [cell addSubview:password];
        }
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
        }
//        else if (indexPath.row == 2) {
//            title.text = @"QQ";
//            if (!qq) {
//                qq = [[self getField] retain];
//            }
//            [cell addSubview:qq];
//        } else if (indexPath.row == 3) {
//            title.text = @"微信";
//            if (!weixin) {
//                weixin = [[self getField] retain];
//            }
//            [cell addSubview:weixin];
//        }
        else if (indexPath.row == 2) {
            title.frame = CGRectMake(10, 13, 160, 17);
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
        } else if (indexPath.row == 3) {
            title.frame = CGRectMake(10, 13, 160, 17);
            title.text = @"如何知道宝贝计画";
            
            if (!introducer) {
                introducer = [[self getField] retain];
                introducer.frame = CGRectMake(180, 5, 130, 34);
            }
            [cell addSubview:introducer];
            introducer.enabled = NO;
        }
    }

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 3) {
        IntroducerViewController *iCtr = [[IntroducerViewController alloc] initWIthCallback:^(NSString *intro) {
            introducer.text = intro;
        }];
        [ctr pushViewController:iCtr animation:ViewSwitchAnimationSwipeR2L];
        [iCtr release];
    }
}


#pragma mark ui event
- (void)back {
    [ctr popViewControllerAnimated:YES];
}

- (void)dismissKeyboard {
    [userName resignFirstResponder];
    [validcode resignFirstResponder];
    [password resignFirstResponder];
    [nickName resignFirstResponder];
    [birthday resignFirstResponder];
    //[qq resignFirstResponder];
    //[weixin resignFirstResponder];
    [birthdayPicker removeFromSuperview];

    registerTable.contentInset = UIEdgeInsetsZero;

}

- (void)tap:(UITapGestureRecognizer *)tap {
    [self dismissKeyboard];
}

- (void)chooseDate:(UIDatePicker *)picker {
    birthday.text = [TOOL dateString:birthdayPicker.date];
}

- (void)doRegister {
    [self dismissKeyboard];
    
    if ([userName.text length] != 11) {
        [UI showAlert:@"错误的手机号"];
        return;
    }
    
    if ([password.text length] < 6) {
        [UI showAlert:@"密码至少为6位"];
        return;
    }
    
    [UI showIndicator];
    
    UserTask *task = [[UserTask alloc] initRegister:userName.text
                                           password:password.text
                                         verifiCode:validcode.text
                                           atSchool:ifJoin.selectedIndex == 0
                                         introducer:introducer.text];
    task.logicCallbackBlock = ^(bool successful, id userInfo) {
        if (successful) {
            [MobClick endEvent:UMENG_REGISTER_CHANNEL label:introducer.text];
#warning to be finished!!!!!!!!!!!!!
            [MobClick endEvent:UMENG_USER_YEAR label:introducer.text];
            [MobClick endEvent:UMENG_USER_GENDER label:introducer.text];

            UserTask *editTask = [[UserTask alloc] initEdit:nickName.text
                                                         qq:qq.text
                                                     weixin:weixin.text
                                                   birthday:birthdayPicker.date
                                                     gender:0
                                                     avatar:nil
                                                       city:0];
            editTask.logicCallbackBlock = ^(bool successful, id userInfo) {
                
                [UI hideIndicator];

                [UI showAlert:@"恭喜你，注册成功"];
                [ctr popViewControllerAnimated:YES];
            };
            [TaskQueue addTaskToQueue:editTask];
            [editTask release];
        } else {
            [UI showAlert:((BBExp *)userInfo).msg];
        }
    };
    [TaskQueue addTaskToQueue:task];
    [task release];
}

- (void)getVerfiCode {
    if ([userName.text length] != 11) {
        [UI showAlert:@"错误的手机号"];
        return;
    }
    
    UserTask *task = [[UserTask alloc] initGetVerifiCode:userName.text type:0];
    task.logicCallbackBlock = ^(bool successful, id userInfo) {
        if (successful) {
            [UI showAlert:@"发送成功"];
        } else {
            
            //备注    服务器返回数据为空 无法判断   失败时没有返回信息
        //    [UI showAlert:((BBExp *)userInfo).msg];
            NSLog(@"%@",((BBExp *)userInfo).msg) ;
            [UI showAlert:@"您的手机号已注册"];
        }
    };
    [TaskQueue addTaskToQueue:task];
    [task release];
}


#pragma mark uitextfield delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    registerTable.contentInset = UIEdgeInsetsMake(0, 0, 240, 0);
    if (birthdayPicker) {
        [birthdayPicker removeFromSuperview];
    }

    if (textField == userName) {

    } else if (textField == validcode) {
    
    } else if (textField == password) {

    } else if (textField == nickName) {
        [registerTable setContentOffset:CGPointMake(0, 100) animated:YES];
    } else if (textField == birthday) {
        [self dismissKeyboard];
        registerTable.contentInset = UIEdgeInsetsMake(0, 0, 240, 0);
        [registerTable setContentOffset:CGPointMake(0, 130) animated:YES];
        if (!birthdayPicker) {
            birthdayPicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, screentContentHeight - 200, 320, 200)];
            birthdayPicker.backgroundColor = [UIColor colorWithRed:234/255.0 green:166/255.0 blue:31/255.0 alpha:1];
            birthdayPicker.datePickerMode = UIDatePickerModeDate;
            birthdayPicker.maximumDate = [NSDate date];
            NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_cn"];
            birthdayPicker.locale = locale;
            [locale release];
            [birthdayPicker addTarget:self action:@selector(chooseDate:) forControlEvents:UIControlEventValueChanged];
        }
        [self.view addSubview:birthdayPicker];
        return NO;
    }
//    else if (textField == qq) {
//        [registerTable setContentOffset:CGPointMake(0, 160) animated:YES];
//    } else if (textField == weixin) {
//        [registerTable setContentOffset:CGPointMake(0, 190) animated:YES];
//    }
    else {
        [self dismissKeyboard];
        [registerTable setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == userName) {
        [validcode becomeFirstResponder];
    } else if (textField == validcode) {
        [password becomeFirstResponder];
    } else if (textField == password) {
        [nickName becomeFirstResponder];
    } else if (textField == nickName) {
        [birthday becomeFirstResponder];
    } else if (textField == birthday) {
        [self dismissKeyboard];
        //[qq becomeFirstResponder];
    }
    //else if (textField == qq) {
     //   [weixin becomeFirstResponder];
    //}
    else {
        [self dismissKeyboard];
    }
    return YES;
}


#pragma mark simple segment delegate
- (void)segmentSelected:(int)index {
    
}


@end
