//
//  AppDelegate.m
//  TestLogIn
//
//  Created by CC on 2017/3/22.
//  Copyright © 2017年 CC. All rights reserved.
//

#import "AppDelegate.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import "CCKeychain.h"
#import "ViewController1.h"
#import "ViewController.h"
#import "WXApi.h"
#import "CCLogin.h"

#define WXappid @"1111"

@interface AppDelegate ()<WXApiDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    // 注册微信
    [WXApi registerApp:WXappid];
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [self.window makeKeyAndVisible];
    
    // 判断微信或 QQ Token 是否过期,过期需要重新登陆
    if ([CCKeychain QQLocalData]) {
        
        ViewController1 *vc1 = [[ViewController1 alloc]init];
        self.window.rootViewController = vc1;
        NSLog(@"QQ 自动登陆");
        
    }else if ([CCKeychain WXLocalData]){
        
        ViewController1 *vc1 = [[ViewController1 alloc]init];
        self.window.rootViewController = vc1;
        NSLog(@"WX 自动登陆");
    
    }else{
        ViewController *vc1 = [[ViewController alloc]init];
        self.window.rootViewController = vc1;
        NSLog(@"重新登陆");
    }
    return YES;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    return [TencentOAuth HandleOpenURL:url] || [WXApi handleOpenURL:url delegate:self];
}

#pragma mark - WXApiDelegate
- (void)onResp:(BaseResp *)resp {
    NSLog(@"授权后回调:%@",resp);
    SendAuthResp *authResp = (SendAuthResp *)resp;
    
    // 判断是分享回调还是登陆回调
    if ([authResp respondsToSelector:NSSelectorFromString(@"state")]) {
        [self getCode:resp];
    }
}

- (void)getCode:(BaseResp *)resp {
    NSLog(@"respErrorCode:%d",resp.errCode);
    // 授权成功
    if (resp.errCode == 0) {
        self.window.rootViewController = [[ViewController1 alloc]init];
        SendAuthResp *authResp = (SendAuthResp *)resp;
        NSLog(@"wx token :%@",authResp.code);
        [CCKeychain delete:KEY_QQ_PASSWORD];
        [CCKeychain wxSave:authResp.code];
        //[CCLogin isExpire];
        
        //[self getWXInfo];
    }
}

#pragma mark 获取微信用户信息,待不全
- (void)getWXInfo {
    NSURL *url = [NSURL URLWithString:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=APPID&secret=SECRET&code=CODE&grant_type=authorization_code"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error) {
            NSLog(@"access_token:%@",data);
            NSString *str = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            NSLog(@"wx info:%@",str);
        }else{
            NSLog(@"error:%@",error);
        }
    }];
    [dataTask resume];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
