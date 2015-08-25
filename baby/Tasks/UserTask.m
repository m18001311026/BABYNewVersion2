//
//  AccountTask.m
//  baby
//
//  Created by zhang da on 14-3-2.
//  Copyright (c) 2014年 zhang da. All rights reserved.
//

#import "UserTask.h"
#import "NSStringExtra.h"
#import "NSDictionaryExtra.h"
#import "NSDateExtra.h"
#import "Session.h"
#import "User.h"
#import "ConfigManager.h"
#import "MemContainer.h"


@implementation UserTask

- (void)dealloc {
    [super dealloc];
}

- (id)initLogin:(NSString *)mobile password:(NSString *)password {
    self = [super initWithUrl:SERVERURL method:GET];
    if (self) {
        [self addParameter:@"action" value:@"user_login"];
        [self addParameter:@"mobile" value:mobile];
        [self addParameter:@"password" value:[password MD5String]];

        self.responseCallbackBlock = ^(bool succeeded, id userInfo) {
            if (succeeded) {
            
                //chulijian  userInfo -> user->id
              
                NSNumber * xDic=[[userInfo objectForKey:@"user"] objectForKey:@"id"];
                NSInteger id =  [xDic integerValue];
                NSString * userId=[NSString stringWithFormat:@"%d",id];
               
                NSLog(@"string 类型 is %@",userId);
                
                NSNotification * notification =[NSNotification notificationWithName:@"userInformation" object:userId userInfo:nil];
                
                [[NSNotificationCenter defaultCenter] postNotification:notification];
               
                //-----------tongzhichu

                NSMutableDictionary *resultDic = (NSMutableDictionary *)userInfo;
                NSMutableDictionary *userDic = [resultDic objectForKey:@"user"];
                NSMutableDictionary *sessionDic = [resultDic objectForKey:@"session"];
                
                NSString *idString = [userDic objectForKey:@"id"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"userId" object:idString];
                
                Session *session = (Session *)[Session instanceFromDict:sessionDic];
                [[ConfigManager me] setSession:session];

                [[MemContainer me] instanceFromDict:userDic clazz:[User class]];

                [self doLogicCallBack:YES info:nil];
                
            } else {
                [self doLogicCallBack:NO info:userInfo];
            }
        };
    }
    return self;
}

- (id)initUserDetail:(long)userId {
    self = [super initWithUrl:SERVERURL method:GET session:[[ConfigManager me] getSession].session];
    if (self) {
        [self addParameter:@"action" value:@"user_Query"];
        [self addParameter:@"user_id" value:[NSString stringWithFormat:@"%ld", userId]];
        
        self.responseCallbackBlock = ^(bool succeeded, id userInfo) {
            if (succeeded) {
                NSDictionary *dict = (NSDictionary *)userInfo;
                NSDictionary *uDict = [dict objForKey:@"user"];
                if (uDict) {
                    
                    User *user = (User *)[[MemContainer me] instanceFromDict:uDict clazz:[User class]];

                    if ([dict objectForKey:@"following"]) {
                        user.following = [dict objectForKey:@"following"];
                    }
                    
                    [self doLogicCallBack:YES info:user];
                    
                }
                
            } else {
                [self doLogicCallBack:NO info:userInfo];
            }
        };
    }
    return self;
}

// mag : comment_message, system_message
- (id)initUserDetail:(long)userId msg:(NSString *)msg {
    self = [super initWithUrl:SERVERURL method:GET session:[[ConfigManager me] getSession].session];
    if (self) {
//        [self addParameter:@"action" value:@"user_ResetMessage"];
//        [self addParameter:@"user_id" value:[NSString stringWithFormat:@"%ld", userId]];

        
        [self addParameter:@"action" value:@"user_Query1"];
        [self addParameter:@"user_id" value:[NSString stringWithFormat:@"%ld", userId]];
        [self addParameter:@"message" value:msg];
        
        self.responseCallbackBlock = ^(bool succeeded, id userInfo) {
            if (succeeded) {
               
                
                
            } else {
                [self doLogicCallBack:NO info:userInfo];
            }
        };
    }
    return self;
}

- (id)initGetVerifiCode:(NSString *)mobile type:(int)type {
    self = [super initWithUrl:SERVERURL method:GET];
    if (self) {
        [self addParameter:@"action" value:@"verificode_Query"];
        [self addParameter:@"mobile" value:mobile];
        [self addParameter:@"verifi_type" value:[NSString stringWithFormat:@"%d", type]];
        
        self.responseCallbackBlock = ^(bool succeeded, id userInfo) {
            if (succeeded) {
                NSDictionary *dict = (NSDictionary *)userInfo;
                NSString *code = [dict stringForKey:@"code"];
                [self doLogicCallBack:YES info:code];
            } else {
                [self doLogicCallBack:NO info:userInfo];
            }
        };
    }
    return self;
}

- (id)initRegister:(NSString *)mobile
          password:(NSString *)password
        verifiCode:(NSString *)code
          atSchool:(bool)atSchool
        introducer:(NSString *)introducer {
    
    self = [super initWithUrl:SERVERURL method:GET];
    if (self) {
        [self addParameter:@"action" value:@"user_Register"];
        [self addParameter:@"mobile" value:mobile];
        [self addParameter:@"password" value:[password MD5String]];
        [self addParameter:@"at_school" value:atSchool? @"1": @"0"];
        [self addParameter:@"introducer" value:introducer];

        [self addParameter:@"verifi_code" value:code];

        self.responseCallbackBlock = ^(bool succeeded, id userInfo) {
            if (succeeded) {
                NSDictionary *dict = (NSDictionary *)userInfo;
                [self doLogicCallBack:YES info:dict];
            } else {
                [self doLogicCallBack:NO info:userInfo];
            }
        };
    }
    return self;
}

- (id)initRegister:(NSString *)mobile
          password:(NSString *)password
          atSchool:(bool)atSchool
        introducer:(NSString *)introducer {
    
    self = [super initWithUrl:SERVERURL method:GET];
    if (self) {
        [self addParameter:@"action" value:@"user_Register1"];
        [self addParameter:@"mobile" value:mobile];
        [self addParameter:@"password" value:[password MD5String]];
        [self addParameter:@"at_school" value:atSchool? @"1": @"0"];
        [self addParameter:@"introducer" value:introducer];
        
        
        self.responseCallbackBlock = ^(bool succeeded, id userInfo) {
            if (succeeded) {
                NSDictionary *dict = (NSDictionary *)userInfo;
                [self doLogicCallBack:YES info:dict];
            } else {
                [self doLogicCallBack:NO info:userInfo];
            }
        };
    }
    return self;
}

- (id)initReset:(NSString *)mobile password:(NSString *)password verifiCode:(NSString *)code {
    self = [super initWithUrl:SERVERURL method:GET];
    if (self) {
        [self addParameter:@"action" value:@"user_Reset"];
        [self addParameter:@"mobile" value:mobile];
        [self addParameter:@"password" value:[password MD5String]];
        [self addParameter:@"verifi_code" value:code];
        
        self.responseCallbackBlock = ^(bool succeeded, id userInfo) {
            if (succeeded) {
                NSDictionary *dict = (NSDictionary *)userInfo;
                [self doLogicCallBack:YES info:dict];
            } else {
                [self doLogicCallBack:NO info:userInfo];
            }
        };
    }
    return self;
}

- (id)initEdit:(NSString *)nickName
            qq:(NSString *)qq
        weixin:(NSString *)weixin
      birthday:(NSDate *)birthday
        gender:(int)male
        avatar:(UIImage *)avatar
          city:(int)cityId {
    self = [super initWithUrl:SERVERURL method:POST session:[[ConfigManager me] getSession].session];
    if (self) {
        [self addParameter:@"action" value:@"user_Edit"];
        if (birthday) {
            [self addParameter:@"birthday" value:[birthday dateString]];
        }
        if (nickName) {
            [self addParameter:@"nick_name" value:nickName];
        }
        if (qq) {
            [self addParameter:@"qq" value:qq];
        }
        if (weixin) {
            [self addParameter:@"weixin" value:weixin];
        }
        if (male >= 0 && male < 2) {
            [self addParameter:@"gender" value:[NSString stringWithFormat:@"%d", male]];
        }
        if (avatar) {
            [self addParameter:@"avatar" value:UIImageJPEGRepresentation(avatar, 1.0) fileName:@"avatar.jpg"];
        }
        if (cityId > 0) {
            [self addParameter:@"city_id" value:[NSString stringWithFormat:@"%d", cityId]];
        }
        self.responseCallbackBlock = ^(bool succeeded, id userInfo) {
            if (succeeded) {
                NSDictionary *dict = (NSDictionary *)userInfo;
                [self doLogicCallBack:YES info:dict];
            } else {
                [self doLogicCallBack:NO info:userInfo];
            }
        };
    }
    return self;
}

- (id)initEditHome:(UIImage *)home {
    self = [super initWithUrl:SERVERURL method:POST session:[[ConfigManager me] getSession].session];
    if (self) {
        [self addParameter:@"action" value:@"user_Home"];
        if (home) {
            [self addParameter:@"home" value:UIImageJPEGRepresentation(home, 1.0) fileName:@"home.jpg"];
        }
        self.responseCallbackBlock = ^(bool succeeded, id userInfo) {
            if (succeeded) {
                NSDictionary *dict = (NSDictionary *)userInfo;
                [self doLogicCallBack:YES info:dict];
            } else {
                [self doLogicCallBack:NO info:userInfo];
            }
        };
    }
    return self;
}

- (id)initFanList:(long)userId page:(int)page count:(int)count {
    self = [super initWithUrl:SERVERURL method:POST];
    if (self) {
        [self addParameter:@"action" value:@"user_Fans"];
        [self addParameter:@"user_id" value:[NSString stringWithFormat:@"%ld", userId]];
        [self addParameter:@"page" value:[NSString stringWithFormat:@"%d", page]];
        [self addParameter:@"count" value:[NSString stringWithFormat:@"%d", count]];
        
        self.responseCallbackBlock = ^(bool succeeded, id userInfo) {
            if (succeeded) {
                NSDictionary *dict = (NSDictionary *)userInfo;
                NSArray *fans = [dict objectForKey:@"fans"];
                
                if (fans && fans.count > 0) {
                    NSMutableArray *fanIds = [[NSMutableArray alloc] initWithCapacity:0];
                    for (NSDictionary *fanDict in fans) {
                        NSDictionary *userDict = [fanDict objectForKey:@"user"];
                        User *u = (User *)[[MemContainer me] instanceFromDict:userDict clazz:[User class]];
                        [fanIds addObject:@(u._id)];
                    }
                    [self doLogicCallBack:YES info:[fanIds autorelease]];
                } else {
                    [self doLogicCallBack:YES info:nil];
                }
            } else {
                [self doLogicCallBack:NO info:userInfo];
            }
        };
    }
    return self;
}

- (id)initFriendList:(long)userId page:(int)page count:(int)count {
    self = [super initWithUrl:SERVERURL method:POST];
    if (self) {
        [self addParameter:@"action" value:@"user_Friends"];
        [self addParameter:@"user_id" value:[NSString stringWithFormat:@"%ld", userId]];
        [self addParameter:@"page" value:[NSString stringWithFormat:@"%d", page]];
        [self addParameter:@"count" value:[NSString stringWithFormat:@"%d", count]];
        
        self.responseCallbackBlock = ^(bool succeeded, id userInfo) {
            if (succeeded) {
                NSDictionary *dict = (NSDictionary *)userInfo;
                NSArray *friends = [dict objectForKey:@"friends"];
                
                if (friends && friends.count > 0) {
                    NSMutableArray *friendIds = [[NSMutableArray alloc] initWithCapacity:0];
                    for (NSDictionary *friendDict in friends) {
                        NSDictionary *userDict = [friendDict objectForKey:@"user"];
                        User *u = (User *)[[MemContainer me] instanceFromDict:userDict clazz:[User class]];
                        [friendIds addObject:@(u._id)];
                    }
                    [self doLogicCallBack:YES info:[friendIds autorelease]];
                } else {
                    [self doLogicCallBack:YES info:nil];
                }
            } else {
                [self doLogicCallBack:NO info:userInfo];
            }
        };
    }
    return self;
}


@end
