//
//  AccountTask.h
//  baby
//
//  Created by zhang da on 14-3-2.
//  Copyright (c) 2014年 zhang da. All rights reserved.
//

#import "BBNetworkTask.h"

@interface UserTask : BBNetworkTask

- (id)initLogin:(NSString *)mobile password:(NSString *)password;

/*
 type 0注册 1重置密码
 */
- (id)initGetVerifiCode:(NSString *)mobile type:(int)type;

- (id)initRegister:(NSString *)mobile
          password:(NSString *)password
        verifiCode:(NSString *)code
          atSchool:(bool)atSchool
        introducer:(NSString *)introducer;
- (id)initRegister:(NSString *)mobile
          password:(NSString *)password
          atSchool:(bool)atSchool
        introducer:(NSString *)introducer;

- (id)initReset:(NSString *)mobile password:(NSString *)password verifiCode:(NSString *)code;

- (id)initUserDetail:(long)userId;
// mag : comment_message, system_message
- (id)initUserDetail:(long)userId msg:(NSString *)msg;

/*
 gender <0 unknown 0女 1男
 */
- (id)initEdit:(NSString *)nickName
            qq:(NSString *)qq
        weixin:(NSString *)weixin
      birthday:(NSDate *)birthday
        gender:(int)male
        avatar:(UIImage *)avatar
          city:(int)cityId;

- (id)initEditHome:(UIImage *)home;

- (id)initFanList:(long)userId page:(int)page count:(int)count;

- (id)initFriendList:(long)userId page:(int)page count:(int)count;


@end
