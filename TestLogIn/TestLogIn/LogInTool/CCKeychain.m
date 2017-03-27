//
//  CCKeychain.m
//  测试 Boundle
//
//  Created by CC on 2016/11/5.
//  Copyright © 2016年 CC. All rights reserved.
//

#import "CCKeychain.h"
#import "CCLogin.h"

@implementation CCKeychain

#pragma mark - 创建
+ (NSMutableDictionary *)getKeychainQuery:(NSString *)service {
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
            (id)kSecClassGenericPassword,(id)kSecClass,
            service, (id)kSecAttrService,
            service, (id)kSecAttrAccount,
            (id)kSecAttrAccessibleAfterFirstUnlock,(id)kSecAttrAccessible,
            nil];
}

#pragma mark - 保存或修改数据
// QQ
+ (void)qqSave:(NSString *)passWord {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:passWord forKey:QQ_PASSWORD];
    [self save:KEY_QQ_PASSWORD data:dic];
    [CCLogin overTimeStamp];
}

// 微信
+ (void)wxSave:(NSString *)passWord {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:passWord forKey:WX_PASSWORD];
    [self save:KEY_WX_PASSWORD data:dic];
    [CCLogin overTimeStamp];
}

+ (void)save:(NSString *)service data:(id)data {
    //获取搜索字典
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    //删除旧的、添加新的
    SecItemDelete((CFDictionaryRef)keychainQuery);
    //添加新的对象来搜索字典(注意数据形式)
    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:data] forKey:(id)kSecValueData];
    //添加搜索字典钥匙串
    SecItemAdd((CFDictionaryRef)keychainQuery, NULL);
}

#pragma mark - 加载数据,是否存在或过期
+ (BOOL)QQLocalData {
    NSMutableDictionary *usernamepasswordKVPairs = (NSMutableDictionary *)[CCKeychain load:KEY_QQ_PASSWORD];
    id QQTemp = [usernamepasswordKVPairs objectForKey:QQ_PASSWORD];
    NSString *QQToken = [NSString stringWithFormat:@"%@",QQTemp];
    // 判断本地 token 长度是否大于 0, 是否包含 null, 是否过期
    if (QQToken.length > 0 && ![QQToken containsString:@"null"] && ![CCLogin isExpire]) {
        return YES;
    }
    return NO;
}

+ (BOOL)WXLocalData {
    NSMutableDictionary *usernamepasswordKVPairs = (NSMutableDictionary *)[CCKeychain load:KEY_WX_PASSWORD];
    id WXTemp = [usernamepasswordKVPairs objectForKey:WX_PASSWORD];
    NSString *WXToken = [NSString stringWithFormat:@"%@",WXTemp];
    // 判断本地 token 长度是否大于 0, 是否包含 null, 是否过期
    if (WXToken.length > 0 && ![WXToken containsString:@"null"] && ![CCLogin isExpire]) {
        return YES;
    }
    return NO;
}

+ (id)load:(NSString *)service {
    id ret = nil;
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    // 配置搜索设置
    // 因为在简单情况下，我们希望只有个属性返回 (属性) 我们可以设置属性 kSecReturnData 为 kCFBooleanTrue
    [keychainQuery setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnData];
    [keychainQuery setObject:(id)kSecMatchLimitOne forKey:(id)kSecMatchLimit];
    CFDataRef keyData = NULL;
    if (SecItemCopyMatching((CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData) == noErr) {
        @try {
            ret = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge NSData *)keyData];
        } @catch (NSException *e) {
            NSLog(@"Unarchive of %@ failed: %@", service, e);
        } @finally {
        }
    }
    if (keyData)
        CFRelease(keyData);
    return ret;
}

#pragma mark - 删除数据
+ (void)delete:(NSString *)service {
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    SecItemDelete((CFDictionaryRef)keychainQuery);
}

@end
