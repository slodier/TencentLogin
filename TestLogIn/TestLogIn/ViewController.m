//
//  ViewController.m
//  TestLogIn
//
//  Created by CC on 2017/3/22.
//  Copyright © 2017年 CC. All rights reserved.
//

#import "ViewController.h"
#import "CCLogin.h"
#import "CCKeychain.h"

@interface ViewController ()

@property (nonatomic, strong) CCLogin *ccLogin;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor purpleColor];
    
    _ccLogin = [[CCLogin alloc]init];
    [self layoutUI];
}

#pragma mark - 构建 UI
- (void)layoutUI {
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(100, 100, 100, 100)];
    button.backgroundColor = [UIColor redColor];
    [button setTitle:@"微信登陆" forState: UIControlStateNormal];
    [button addTarget:self action:@selector(wxLoginClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    UIButton *button1 = [[UIButton alloc]initWithFrame:CGRectMake(100, 300, 100, 100)];
    button1.backgroundColor = [UIColor cyanColor];
    [button1 setTitle:@"QQ 登陆" forState: UIControlStateNormal];
    [button1 addTarget:self action:@selector(qqLoginClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button1];
}

#pragma mark - 微信和 QQ 登陆
- (void)wxLoginClick {
    [_ccLogin WXLogin];
}

- (void)qqLoginClick {
    [_ccLogin QQLogin];
}

@end
