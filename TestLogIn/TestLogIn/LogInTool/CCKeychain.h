//
//  CCKeychain.h
//  测试 Boundle
//
//  Created by CC on 2016/11/5.
//  Copyright © 2016年 CC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Security/Security.h>

@interface CCKeychain : NSObject

#pragma mark - QQ 保存
+ (void)qqSave:(NSString *)passWord;

+ (void)wxSave:(NSString *)passWord;

#pragma mark - 读取
// QQ
+ (BOOL)QQLocalData;
// WX
+ (BOOL)WXLocalData;

#pragma mark - 删除
+ (void)delete:(NSString *)service;

@end
