//
//  CCLogin.m
//  TestLogIn
//
//  Created by CC on 2017/3/22.
//  Copyright © 2017年 CC. All rights reserved.
//

#import "CCLogin.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import "CCKeychain.h"
#import "WXApi.h"
#import "ViewController1.h"

@interface CCLogin ()<TencentSessionDelegate>

@property (nonatomic, strong) TencentOAuth *tencent;

@end

@implementation CCLogin

static NSString *OVERTIMEKEY = @"overtime";

static NSUInteger EXPIRETIME = 604800;  // 过期时间


- (instancetype)init {
    if (self = [super init]) {
        _tencent = [[TencentOAuth alloc]initWithAppId:QQappid andDelegate:self];
    }
    return self;
}

+ (NSUserDefaults *)defaults {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return defaults;
}

#pragma mark - 存储用户名字、头像


#pragma mark - 登陆有效期
#pragma mark 当前的时间戳
+ (NSString *)currentTime {
    NSDate *date = [NSDate date];
    NSInteger timeStmap = [date timeIntervalSince1970];
    NSString *time = [NSString stringWithFormat:@"%ld",(long)timeStmap];
    return time;
}

#pragma mark 过期时间戳
+ (void)overTimeStamp {
    int time = [[self currentTime]intValue];
    time += EXPIRETIME;
    NSString *overTime = [NSString stringWithFormat:@"%d",time];
    [[self defaults]setObject:overTime forKey:OVERTIMEKEY];
}

#pragma mark 是否超过有效期,是则重新登陆
+ (BOOL)isExpire {
    int current = [self currentTime].intValue;    // 当前时间
    NSString *overTimeStr = [[self defaults]objectForKey:OVERTIMEKEY];
    int overTime = overTimeStr.intValue; // 过期时间
    if (current > overTime) {
        return YES;
    }else{
        return NO;
    }
}

#pragma mark - QQ 登陆
- (void)QQLogin {
    if ([TencentOAuth iphoneQQInstalled]) {
        NSArray *permissions = [NSArray arrayWithObjects:
                                kOPEN_PERMISSION_GET_INFO,
                                kOPEN_PERMISSION_GET_USER_INFO,
                                kOPEN_PERMISSION_GET_SIMPLE_USER_INFO,
                                kOPEN_PERMISSION_ADD_SHARE, nil];
        [_tencent authorize:permissions inSafari:NO];
    }else{
        [self alert:@"QQ did not install"];
    }
}

#pragma mark - QQ 获取个人信息
- (void)getUserInfoResponse:(APIResponse *)response {
    NSLog(@"response:%@",response.jsonResponse);
    // response.jsonResponse[@"figureurl_qq_2"]; // 100 *100 的头像
    // response.jsonResponse[@"nickname"]; // 用户名
}

#pragma mark - TencentSessionDelegate
#pragma mark 登陆成功之后的回调
- (void)tencentDidLogin {
    if (_tencent.accessToken && [_tencent.accessToken length] != 0) {
        // 调用以下方法,会自动调用 getUserInfoResponse 方法
        [_tencent getUserInfo];
        NSLog(@"token:%@",_tencent.accessToken);
        
        UIViewController *rootViewController = [[[UIApplication sharedApplication]keyWindow]rootViewController];
        ViewController1 *vc1 = [[ViewController1 alloc]init];
        [rootViewController presentViewController:vc1 animated:YES completion:nil];
        
        [CCKeychain delete:KEY_WX_PASSWORD];
        [CCKeychain qqSave:_tencent.accessToken];
        
    }else{
        
        NSLog(@"Did not receive token");
    }
}

#pragma mark 登陆失败
- (void)tencentDidNotLogin:(BOOL)cancelled {
    if (cancelled) {
        NSLog(@"Users cancel landing");
    }else{
        NSLog(@"登录失败");
    }
}

#pragma mark 没有网络连接
- (void)tencentDidNotNetWork {
    NSLog(@"No network connection");
}

#pragma mark - 微信登陆
- (void)WXLogin {
    if ([WXApi isWXAppInstalled]) {
        SendAuthReq *req = [[SendAuthReq alloc]init];
        req.scope = @"snsapi_userinfo";
        req.state = @"123";
        [WXApi sendReq:req];
    }else{
        [self alert:@"WX did not install"];
    }
}

#pragma mark - 微信、QQ 没有安装，提示框
- (void)alert:(NSString *)message {
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示"
                                                       message:message
                                                      delegate:nil
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil, nil];
    [alertView show];
}

@end
