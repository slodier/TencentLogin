//
//  CCLogin.h
//  TestLogIn
//
//  Created by CC on 2017/3/22.
//  Copyright © 2017年 CC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CCLogin : NSObject

#pragma mark - 过期时间
+ (void)overTimeStamp;

#pragma mark 判断登陆是否过期
+ (BOOL)isExpire;

#pragma mark - QQ 登陆
- (void)QQLogin;

#pragma mark - 微信登陆
- (void)WXLogin;

@end
