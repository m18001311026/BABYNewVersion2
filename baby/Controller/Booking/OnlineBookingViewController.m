//
//  OnlineBookingViewController.m
//  baby
//
//  Created by zhang da on 14-3-2.
//  Copyright (c) 2014年 zhang da. All rights reserved.
//

#import "OnlineBookingViewController.h"
#import "UIButtonExtra.h"
#import "SchoolListViewController.h"

#import "School.h"
#import "UserTask.h"
#import "BookingTask.h"
#import "TaskQueue.h"
#import "BBExp.h"

@interface OnlineBookingViewController ()

@property (nonatomic, assign) long schoolId;

@end

@implementation OnlineBookingViewController

- (void)dealloc {
    
    [bookingTime release];
    [mobile release];
    [userName release];
    [school release];
    [timePicker release];

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
    
    [self setViewTitle:@"在线预约"];
    bbTopbar.backgroundColor = [UIColor colorWithRed:234/255.0 green:166/255.0 blue:31/255.0 alpha:1];
    
    UIButton *back = [UIButton buttonWithCustomStyle:CustomButtonStyleBack];
    [back addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [bbTopbar addSubview:back];
    
    bookingTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, 320, 390)
                                                 style:UITableViewStylePlain];
    if ([bookingTable respondsToSelector:@selector(setSeparatorInset:)]) {
        [bookingTable setSeparatorInset:UIEdgeInsetsZero];
    }
    bookingTable.delegate = self;
    bookingTable.dataSource = self;
    bookingTable.scrollEnabled = YES;
    [self.view addSubview:bookingTable];
    [bookingTable release];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    tap.cancelsTouchesInView = NO;
    [bookingTable addGestureRecognizer:tap];
    [tap release];
    
    UIButton *loginBtn = [UIButton simpleButton:@"确定" y:410];
    [loginBtn addTarget:self action:@selector(doRegister) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma table view section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
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
    
    if (indexPath.row == 0) {
        title.text = @"预约时间";
        if (!bookingTime) {
            bookingTime = [[self getField] retain];
        }
        [cell addSubview:bookingTime];
    } else if (indexPath.row == 1) {
        title.text = @"手机号";
        
        if (!mobile) {
            mobile = [[self getField] retain];
        }
        [cell addSubview:mobile];
    } else if (indexPath.row == 2) {
        title.text = @"联系人";
        
        if (!userName) {
            userName = [[self getField] retain];
        }
        [cell addSubview:userName];
    } else {
        title.text = @"学校";
        
        if (!school) {
            school = [[self getField] retain];
        }
        [cell addSubview:school];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}


#pragma mark ui event
- (void)back {
    [ctr popViewControllerAnimated:YES];
}

- (void)dismissKeyboard {
    [bookingTime resignFirstResponder];
    [mobile resignFirstResponder];
    [userName resignFirstResponder];
    [school resignFirstResponder];

    [timePicker removeFromSuperview];

    bookingTable.contentInset = UIEdgeInsetsZero;
}

- (void)tap:(UITapGestureRecognizer *)tap {
    [self dismissKeyboard];
}

- (void)chooseDate:(UIDatePicker *)picker {
    bookingTime.text = [TOOL stringFromDate:picker.date format:@"M月d日（eeee） hh:mm"];
}

- (void)doRegister {
    [self dismissKeyboard];
    
    if ([mobile.text length] != 11) {
        [UI showAlert:@"错误的手机号"];
        return;
    }
    
    if ([bookingTime.text length] < 6) {
        [UI showAlert:@"错误的预约时间"];
        return;
    }
    
    BookingTask *task = [[BookingTask alloc] initBooking:timePicker.date
                                                  school:self.schoolId
                                                    name:userName.text
                                                  mobile:mobile.text];
    task.logicCallbackBlock = ^(bool successful, id userInfo) {
        if (successful) {
            [ctr popViewControllerAnimated:YES];
            [UI showAlert:@"预约成功"];
        } else {
            [UI showAlert:((BBExp *)userInfo).msg];
        }
    };
    [TaskQueue addTaskToQueue:task];
    [task release];
}


#pragma mark uitextfield delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    bookingTable.contentInset = UIEdgeInsetsMake(0, 0, 240, 0);
    if (timePicker) {
        [timePicker removeFromSuperview];
    }

    if (textField == bookingTime) {
        [self dismissKeyboard];
        bookingTable.contentInset = UIEdgeInsetsMake(0, 0, 240, 0);
        if (!timePicker) {
            timePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, screentContentHeight - 200, 320, 200)];
            timePicker.backgroundColor = [UIColor colorWithRed:234/255.0 green:166/255.0 blue:31/255.0 alpha:1];
            timePicker.datePickerMode = UIDatePickerModeDateAndTime;
            timePicker.minimumDate = [NSDate date];
            timePicker.minuteInterval = 10;
            NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_cn"];
            timePicker.locale = locale;
            [locale release];
            [timePicker addTarget:self action:@selector(chooseDate:) forControlEvents:UIControlEventValueChanged];
            timePicker.date = [NSDate date];
        }
        [self.view addSubview:timePicker];
        return NO;
    } else if (textField == mobile) {
    
    } else if (textField == userName) {

    } else if (textField == school) {
        [self dismissKeyboard];
        [bookingTable setContentOffset:CGPointMake(0, 0) animated:YES];
        SchoolListViewController *sCtr = [[SchoolListViewController alloc] initWithCallback:^(long schoolId) {
            self.schoolId = schoolId;
            School *s = [School getSchoolWithId:self.schoolId];
            school.text = s.title;
        }];
        [ctr pushViewController:sCtr animation:ViewSwitchAnimationSwipeR2L];
        [sCtr release];
        return NO;
    } else {
        [self dismissKeyboard];
        [bookingTable setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == mobile) {
        [userName becomeFirstResponder];
    } else if (textField == userName) {
        [self dismissKeyboard];
    }
    return YES;
}


@end
