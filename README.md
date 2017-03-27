# TencentLogin - QQ 和微信登陆
### 功能

1. 登陆 `QQ` 、微信,并使用 `KeyChain` 存储到本地,用于自动登陆
2. 添加过期时间,默认七天之后需要重新登陆
3. 获取用户信息, `QQ` 已实现,微信较麻烦,待补全...[微信文档](https://open.weixin.qq.com/cgi-bin/showdocument?action=dir_list&t=resource/res_list&verify=1&id=open1419317853&token=&lang=zh_CN)

### 准备工作

1. 和分享一样,需要添加 `URL Types`, 分别是` QQ` 和微信, `QQ` 的 `URL Schemes` 需要加上 `tencent` 前缀</br>
2. 添加相关库</br>
   `CoreGraphics.framework`</br>
   `Security.framework`</br>
   `SystemConfiguration.framework`</br>
   `libz.tbd`</br>
   `libc++.tbd`</br>
   `libsqlite3.dylib`</br>
   `CFNetwork.framework`</br>
   `CoreTelephony.framework`</br>
   `libiconv.tbd`</br>

3. `Build Setting` - `Other Linker Flags` 添加 `-Objc-all_load`
4. 申请两个 `AppID`(微信好像需要 200 块钱, QQ 忘记了)
5. 由于 `SDK` 较大,下载需要一段时间

### How to use?

```Objective-C

static NSUInteger EXPIRETIME = 604800;  // 过期时间

// 微信登陆
[_ccLogin WXLogin];

// QQ 登陆
[_ccLogin QQLogin];
```