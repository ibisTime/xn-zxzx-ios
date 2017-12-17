//
//  AppDelegate.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/7/13.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "AppDelegate.h"

#import "IQKeyboardManager.h"
//#import "WXApi.h"

#import "AppConfig.h"

#import "NavigationController.h"
#import "TabbarViewController.h"

#import "TLUserLoginVC.h"

#import "UIViewController+Extension.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

#pragma mark - App Life Cycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //服务器环境
    [self configServiceAddress];
    
    //键盘
    [self configIQKeyboard];
    
    //配置地图
//    [self configMapKit];
    
    //配置极光
//    [self configJPushWithOptions:launchOptions];
    
    //配置根控制器
    [self configRootViewController];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    
}


- (void)applicationWillTerminate:(UIApplication *)application {
    
}

#pragma mark - Config
- (void)configServiceAddress {
    
    //配置环境
    [AppConfig config].runEnv = RunEnvDev;
    
}

- (void)configIQKeyboard {
    
    //
//    [IQKeyboardManager sharedManager].enable = YES;
//    [[IQKeyboardManager sharedManager].disabledToolbarClasses addObject:[ComposeVC class]];
    
}

- (void)configRootViewController {
    
    [UIApplication sharedApplication].statusBarHidden = NO;
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];

    if([[TLUser user] isLogin]){
        
        TabbarViewController *tabbarCtrl = [[TabbarViewController alloc] init];
        
        self.window.rootViewController = tabbarCtrl;
        
    } else {
        
        self.window.rootViewController = [[NavigationController alloc] initWithRootViewController:[[TLUserLoginVC alloc] init]];
    }
    
    //重新登录
    if([TLUser user].isLogin) {
        
        [[TLUser user] reLogin];
        
    };
    
    //登入
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLogin) name:kUserLoginNotification object:nil];
    //登出
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginOut) name:kUserLoginOutNotification object:nil];
}

#pragma mark - 用户登录
- (void)userLogin {
    
    TabbarViewController *tabbarVC = [[TabbarViewController alloc] init];
    
    self.window.rootViewController = tabbarVC;
    
}

#pragma mark- 退出登录
- (void)loginOut {
    
    //user 退出
    [[TLUser user] loginOut];
    
    NavigationController *nav = [[NavigationController alloc] initWithRootViewController:[[TLUserLoginVC alloc] init]];
    
    self.window.rootViewController = nav;
    
}

#pragma mark 微信支付结果
//- (void)onResp:(BaseResp *)resp {
//
//    if ([resp isKindOfClass:[PayResp class]]) {
//        //支付返回结果
//        NSNotification *notification = [NSNotification notificationWithName:ORDER_PAY_NOTIFICATION object:[NSNumber numberWithInt:resp.errCode]];
//        [[NSNotificationCenter defaultCenter] postNotification:notification];
//    }
//}

@end
