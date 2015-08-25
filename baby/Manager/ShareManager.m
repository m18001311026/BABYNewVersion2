//
//  ShareManager.m
//  baby
//
//  Created by zhang da on 14-5-1.
//  Copyright (c) 2014年 zhang da. All rights reserved.
//

#import "ShareManager.h"
#import "WeiboApi.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "WXApi.h"
#import "MobClick.h"
#import "UIDeviceExtra.h"

@implementation ShareManager {
    
}

static ShareManager *_me = nil;

+ (ShareManager *)me {
    if (!_me) {
        @synchronized([ShareManager class]) {
            if (!_me) {
                NSLog(@"share manager init");
                _me = [[ShareManager alloc] init];
            }
        }
    }
    return _me;
}

- (void)dealloc {
    [super dealloc];
}

- (id)init {
    self = [super init];
    if (self) {
        [ShareSDK registerApp:@"1b15372c2920"];
        [self initializePlat];
    }
    return self;
}

- (void)initializePlat {
    /**
     连接微信应用以使用相关功能，此应用需要引用WeChatConnection.framework和微信官方SDK
     http://open.weixin.qq.com上注册应用，并将相关信息填写以下字段
     **/
    //    [ShareSDK connectWeChatWithAppId:@"wx4868b35061f87885" wechatCls:[WXApi class]];
    [ShareSDK connectWeChatWithAppId:@"wx230943e70534a958" wechatCls:[WXApi class]];
    //新浪微博连接处  chulijian
    /**
     连接新浪微博开放平台应用以使用相关功能，此应用需要引用SinaWeiboConnection.framework
     http://open.weibo.com上注册新浪微博开放平台应用，并将相关信息填写到以下字段
     **/
    //    [ShareSDK connectSinaWeiboWithAppKey:@"568898243"
    //                               appSecret:@"38a4f8204cc784f81f9f0daaf31e02e3"
    //                             redirectUri:@"http://www.sharesdk.cn"];
//    [ShareSDK connectSinaWeiboWithAppKey:@"2212006707"
//                               appSecret:@"0af0ef76b43f273d2b165eba1856258e"
//                             redirectUri:@"http://www.children-sketchbook.com"];
    /*
    [ShareSDK connectSinaWeiboWithAppKey:@"2212006707"
                               appSecret:@"0af0ef76b43f273d2b165eba1856258e"
                             redirectUri:@"http://www.children-sketchbook.com"
                             weiboSDKCls:[WeiboApi class]];
    */
    /**
     连接腾讯微博开放平台应用以使用相关功能，此应用需要引用TencentWeiboConnection.framework
     http://dev.t.qq.com上注册腾讯微博开放平台应用，并将相关信息填写到以下字段
     
     如果需要实现SSO，需要导入libWeiboSDK.a，并引入WBApi.h，将WBApi类型传入接口
     **/
    //    [ShareSDK connectTencentWeiboWithAppKey:@"801307650"
    //                                  appSecret:@"ae36f4ee3946e1cbb98d6965b0b2ff5c"
    //                                redirectUri:@"http://www.sharesdk.cn"
    //                                   wbApiCls:[WeiboApi class]];
    
    
    [ShareSDK connectTencentWeiboWithAppKey:@"801504129"
                                  appSecret:@"dc8e3760d87d2855afaf1236a87f1943"
                                redirectUri:HOMEPAGE
                                   wbApiCls:[WeiboApi class]];
    
    /**
     连接QQ空间应用以使用相关功能，此应用需要引用QZoneConnection.framework
     http://connect.qq.com/intro/login/上申请加入QQ登录，并将相关信息填写到以下字段
     
     如果需要实现SSO，需要导入TencentOpenAPI.framework,并引入QQApiInterface.h和TencentOAuth.h，将QQApiInterface和TencentOAuth的类型传入接口
     **/
    //    [ShareSDK connectQZoneWithAppKey:@"100371282"
    //                           appSecret:@"aed9b0303e3ed1e27bae87c33761161d"
    //                   qqApiInterfaceCls:[QQApiInterface class]
    //                     tencentOAuthCls:[TencentOAuth class]];
    [ShareSDK connectQZoneWithAppKey:@"1101357992"
                           appSecret:@"b45db7ab03e07fbb6244440e27c48fe9"
                   qqApiInterfaceCls:[QQApiInterface class]
                     tencentOAuthCls:[TencentOAuth class]];
    
   // NSLog(@"")
    
    [ShareSDK connectQQWithAppId:@"101083578" qqApiCls:[QQApiInterface class]];
    
    /**
     连接QQ应用以使用相关功能，此应用需要引用QQConnection.framework和QQApi.framework库
     http://mobile.qq.com/api/上注册应用，并将相关信息填写到以下字段
     **/
    //旧版中申请的AppId（如：QQxxxxxx类型），可以通过下面方法进行初始化
    //    [ShareSDK connectQQWithAppId:@"QQ075BCD15" qqApiCls:[QQApi class]];
    
    //    [ShareSDK connectQQWithQZoneAppKey:@"100371282"
    //                     qqApiInterfaceCls:[QQApiInterface class]
    //                       tencentOAuthCls:[TencentOAuth class]];
    [ShareSDK connectQQWithQZoneAppKey:@"1101357992"
                     qqApiInterfaceCls:[QQApiInterface class]
                       tencentOAuthCls:[TencentOAuth class]];
    //    //连接邮件
    //    [ShareSDK connectMail];
    //
    //    //连接短信分享
    //    [ShareSDK connectSMS];
    
    
}

- (void)shareContent:(id<ISSContent>)content {
    [delegate.window bringSubviewToFront:delegate.window.rootViewController.view];
    
    if (![content title].length) {
        [content setTitle:@"宝贝计画"];
    }
    if (![content content].length) {
        [content setContent:@"宝贝计画"];
    }
    if ([content url].length)
    {
        [content setContent:[NSString stringWithFormat:@"%@ %@", [content content], [content url]]];
    }
    
    id<ISSContainer> container = [ShareSDK container];
    [container setIPadContainerWithView:delegate.window arrowDirect:UIPopoverArrowDirectionUp];
    
    [ShareSDK showShareActionSheet:container
                         shareList:nil
                           content:content
                     statusBarTips:YES
                       authOptions:nil
                      shareOptions: nil
                            result:^(ShareType type,
                                     SSResponseState state,
                                     id<ISSPlatformShareInfo> statusInfo,
                                     id<ICMErrorInfo> error,
                                     BOOL end) {
                                
                                if (state == SSResponseStateSuccess) {
                                    
                                    [MobClick event:UMENG_SHARE_PLATFORM label:[NSString stringWithFormat:@"%d", type]];
                                    
                                    
                                    
                                    
                                    
                                    if ([[content url] rangeOfString:GALLERY_PAGE].location != NSNotFound) {
                                        [MobClick event:UMENG_SHARE_CONTENT label:@"gallery"];
                                    } else if ([[content url] rangeOfString:LESSON_PAGE].location != NSNotFound) {
                                        [MobClick event:UMENG_SHARE_CONTENT label:@"lesson"];
                                    } else if ([[content url] rangeOfString:HOMEPAGE].location != NSNotFound) {
                                        [MobClick event:UMENG_SHARE_CONTENT label:@"invite"];
                                    }
                                    
                                    [MobClick event:UMENG_SHARE_DEVICE label:[[UIDevice currentDevice] platform]];
                                    
                                    [UI showAlert:@"分享成功"];
                                } else if (state == SSResponseStateFail) {
                                    if ([error errorCode] == 20019) {
                                        [UI showAlert:@"分享失败，每分钟只能邀请一次"];
                                    } else {
                                        [UI showAlert:@"分享失败，请稍后再试"];
                                    }
                                    NSLog(@"分享失败,错误码:%ld,错误描述:%@", (long)[error errorCode], [error errorDescription]);
                                } else if (state == SSResponseStateCancel) {
//                                    [UI showAlert:@"取消分享"];
                                }
                            }];
}

/**
 *	@brief	创建分享内容对象，根据以下每个字段适用平台说明来填充参数值
 *
 *	@param 	content 	分享内容（新浪、腾讯、网易、搜狐、豆瓣、人人、开心、有道云笔记、facebook、twitter、邮件、打印、短信、微信、QQ、拷贝）
 *	@param 	defaultContent 	默认分享内容（新浪、腾讯、网易、搜狐、豆瓣、人人、开心、有道云笔记、facebook、twitter、邮件、打印、短信、微信、QQ、拷贝）
 *	@param 	image 	分享图片（新浪、腾讯、网易、搜狐、豆瓣、人人、开心、facebook、twitter、邮件、打印、微信、QQ、拷贝）
 *	@param 	title 	标题（QQ空间、人人、微信、QQ）
 *	@param 	url 	链接（QQ空间、人人、微信、QQ）
 *
 *	@return	分享内容对象
 */
- (void)showShareMenuWithTitle:(NSString *)title
                       content:(NSString *)content
                      imageUrl:(NSString *)imageUrl
                       pageUrl:(NSString *)pageUrl {
    
    id<ISSContent> c = [ShareSDK content:content
                          defaultContent:nil
                                   image:[ShareSDK imageWithUrl:imageUrl]
                                   title:title
                                     url:pageUrl
                             description:nil
                               mediaType:SSPublishContentMediaTypeNews];
    [self shareContent:c];
}

- (void)showShareMenuWithTitle:(NSString *)title
                       content:(NSString *)content
                         image:(UIImage *)image
                       pageUrl:(NSString *)pageUrl {
    id<ISSContent> c = [ShareSDK content:content
                          defaultContent:nil
                                   image:[ShareSDK jpegImageWithImage:image quality:.8f]
                                   title:title
                                     url:pageUrl
                             description:nil
                               mediaType:SSPublishContentMediaTypeNews];
    [self shareContent:c];
}

- (void)showShareMenuWithTitle:(NSString *)title
                       content:(NSString *)content
                         video:(NSString *)videoUrl
                       pageUrl:(NSString *)pageUrl {
    id<ISSContent> publishContent = [ShareSDK content:content
                                       defaultContent:nil
                                                image:nil
                                                title:title
                                                  url:videoUrl
                                          description:nil
                                            mediaType:SSPublishContentMediaTypeVideo];
    
    //ShareTypeWeixiSession)
    [publishContent addWeixinSessionUnitWithType:INHERIT_VALUE
                                         content:INHERIT_VALUE
                                           title:INHERIT_VALUE
                                             url:videoUrl
                                      thumbImage:INHERIT_VALUE
                                           image:INHERIT_VALUE
                                    musicFileUrl:nil
                                         extInfo:nil
                                        fileData:nil
                                    emoticonData:nil];
    //ShareTypeWeixiTimeline
    [publishContent addWeixinTimelineUnitWithType:INHERIT_VALUE
                                          content:INHERIT_VALUE
                                            title:INHERIT_VALUE
                                              url:videoUrl
                                       thumbImage:INHERIT_VALUE
                                            image:INHERIT_VALUE
                                     musicFileUrl:nil
                                          extInfo:nil
                                         fileData:nil
                                     emoticonData:nil];
    
    [self shareContent:publishContent];
}

- (void)showShareMenuWithTitle:(NSString *)title
                       content:(NSString *)content
                         image:(UIImage *)image
                       pageUrl:(NSString *)pageUrl
                      soundUrl:(NSString *)soundUrl
{
    
 // NSLog(@"1231231231    %@",content);
    id<ISSContent> publishContent = [ShareSDK content:content
                                       defaultContent:nil
                                                image:[ShareSDK jpegImageWithImage:image quality:.8f]
                                                title:title
                                                  url:pageUrl
                                          description:nil
                                            mediaType:SSPublishContentMediaTypeMusic];
    
    
    NSLog(@"%@",title);
    
    //ShareTypeWeixiSession)
    
    
    [publishContent addWeixinSessionUnitWithType:INHERIT_VALUE
                                         content:INHERIT_VALUE
                                           title:INHERIT_VALUE
                                             url:INHERIT_VALUE
                                      thumbImage:INHERIT_VALUE
                                           image:INHERIT_VALUE
                                    musicFileUrl:soundUrl
                                         extInfo:nil
                                        fileData:nil
                                    emoticonData:nil];
    //ShareTypeWeixiTimelineh/*
    [publishContent addWeixinTimelineUnitWithType:INHERIT_VALUE
                                          content:title
                                            title:content
                                              url:INHERIT_VALUE
                                       thumbImage:INHERIT_VALUE
                                            image:INHERIT_VALUE
                                     musicFileUrl:soundUrl
                                          extInfo:nil
                                         fileData:nil
                                     emoticonData:nil];
   
    [self shareContent:publishContent];
}

- (void)showShareMenuWithTitle:(NSString *)title
                       content:(NSString *)content
                      imageUrl:(NSString *)imageUrl
                       pageUrl:(NSString *)pageUrl
                      soundUrl:(NSString *)soundUrl {
    id<ISSContent> publishContent = [ShareSDK content:content
                                       defaultContent:nil
                                                image:[ShareSDK imageWithUrl:imageUrl]
                                                title:title
                                                  url:pageUrl
                                          description:nil
                                            mediaType:SSPublishContentMediaTypeMusic];
    
    //ShareTypeWeixiSession)
    [publishContent addWeixinSessionUnitWithType:INHERIT_VALUE
                                         content:INHERIT_VALUE
                                           title:INHERIT_VALUE
                                             url:INHERIT_VALUE
                                      thumbImage:INHERIT_VALUE
                                           image:INHERIT_VALUE
                                    musicFileUrl:soundUrl
                                         extInfo:nil
                                        fileData:nil
                                    emoticonData:nil];
    //ShareTypeWeixiTimeline
    [publishContent addWeixinTimelineUnitWithType:INHERIT_VALUE
                                          content:title
                                            title:content
                                              url:INHERIT_VALUE
                                       thumbImage:INHERIT_VALUE
                                            image:INHERIT_VALUE
                                     musicFileUrl:soundUrl
                                          extInfo:nil
                                         fileData:nil
                                     emoticonData:nil];
    
    [self shareContent:publishContent];
}

- (void)inviteFrom:(ShareType)type
           content:(NSString *)content
             title:(NSString *)title
             image:(UIImage *)image
           pageUrl:(NSString *)pageUrl {
    
    //创建分享内容
    id<ISSContent> publishContent = [ShareSDK content:content
                                       defaultContent:@" "
                                                image:[ShareSDK pngImageWithImage:image]
                                                title:title
                                                  url:pageUrl
                                          description:nil
                                            mediaType:SSPublishContentMediaTypeText];
    
    //创建弹出菜单容器
    //id<ISSContainer> container = [ShareSDK container];
    
    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                         allowCallback:NO
                                                                scopes:nil
                                                         powerByHidden:YES
                                                        followAccounts:nil
                                                         authViewStyle:SSAuthViewStyleModal
                                                          viewDelegate:nil
                                               authManagerViewDelegate:nil];
    
    //在授权页面中添加关注官方微博
    [authOptions setFollowAccounts:[NSDictionary dictionaryWithObjectsAndKeys:
                                    [ShareSDK userFieldWithType:SSUserFieldTypeName value:@"宝贝计画绘本美术"],
                                    SHARE_TYPE_NUMBER(ShareTypeSinaWeibo),
                                    [ShareSDK userFieldWithType:SSUserFieldTypeName value:@"宝贝计画绘本美术"],
                                    SHARE_TYPE_NUMBER(ShareTypeTencentWeibo),
                                    nil]];
    
    [delegate.window bringSubviewToFront:delegate.window.rootViewController.view];
    
    //显示分享菜单
    [ShareSDK shareContent:publishContent
                      type:type
               authOptions:authOptions
             statusBarTips:NO
                    result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                        if (state == SSResponseStateSuccess) {
                            [UI showAlert:@"分享成功"];
                        } else if (state == SSResponseStateFail) {
                            if ([error errorCode] == 20019) {
                                [UI showAlert:@"分享失败，每分钟只能邀请一次"];
                            } else {
                                [UI showAlert:@"分享失败，请稍后再试"];
                            }
                            NSLog(@"分享失败,错误码:%d,错误描述:%@", [error errorCode], [error errorDescription]);
                        } else if (state == SSResponseStateCancel) {
                            //[UI showAlert:@"取消分享"];
                        }
                    }];
}

- (void)post:(ShareType)type
     content:(NSString *)content
       title:(NSString *)title
    imageUrl:(NSString *)imageUrl
     pageUrl:(NSString *)pageUrl
    soundUrl:(NSString *)soundUrl
        done:(ShareDone)done {
    
    if (type == ShareTypeAny) {
        if (done) {
            done(YES);
        }
    }
    
    //创建分享内容
    id<ISSContent> publishContent = [ShareSDK content:content
                                       defaultContent:nil
                                                image:[ShareSDK imageWithUrl:imageUrl]
                                                title:title
                                                  url:pageUrl
                                          description:nil
                                            mediaType:SSPublishContentMediaTypeMusic];
    
    //创建弹出菜单容器
    //id<ISSContainer> container = [ShareSDK container];
    
    //ShareTypeWeixiSession)
    [publishContent addWeixinSessionUnitWithType:INHERIT_VALUE
                                         content:INHERIT_VALUE
                                           title:INHERIT_VALUE
                                             url:INHERIT_VALUE
                                      thumbImage:INHERIT_VALUE
                                           image:INHERIT_VALUE
                                    musicFileUrl:soundUrl
                                         extInfo:nil
                                        fileData:nil
                                    emoticonData:nil];
    //ShareTypeWeixiTimeline
    [publishContent addWeixinTimelineUnitWithType:INHERIT_VALUE
                                          content:title
                                            title:content
                                              url:INHERIT_VALUE
                                       thumbImage:INHERIT_VALUE
                                            image:INHERIT_VALUE
                                     musicFileUrl:soundUrl
                                          extInfo:nil
                                         fileData:nil
                                     emoticonData:nil];
    
    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                         allowCallback:NO
                                                                scopes:nil
                                                         powerByHidden:YES
                                                        followAccounts:nil
                                                         authViewStyle:SSAuthViewStyleModal
                                                          viewDelegate:nil
                                               authManagerViewDelegate:nil];
    
    //在授权页面中添加关注官方微博
    [authOptions setFollowAccounts:[NSDictionary dictionaryWithObjectsAndKeys:
                                    [ShareSDK userFieldWithType:SSUserFieldTypeName value:@"宝贝计画"],
                                    SHARE_TYPE_NUMBER(ShareTypeSinaWeibo),
                                    [ShareSDK userFieldWithType:SSUserFieldTypeName value:@"宝贝计画"],
                                    SHARE_TYPE_NUMBER(ShareTypeTencentWeibo),
                                    nil]];
    
    [delegate.window bringSubviewToFront:delegate.window.rootViewController.view];
    
    //显示分享菜单
    
    [ShareSDK shareContent:publishContent
                      type:type
               authOptions:authOptions
             statusBarTips:NO
                    result:^(ShareType type,
                             SSResponseState state,
                             id<ISSPlatformShareInfo> statusInfo,
                             id<ICMErrorInfo> error,
                             BOOL end) {
                        if (state == SSResponseStateSuccess) {
                            NSLog(@"分享成功");
                            if (done) {
                                done(YES);
                            }
                        } else if (state == SSResponseStateCancel || state == SSResponseStateFail){
                            if (done) {
                                done(NO);
                            }
                        }
                    }];
}


@end

