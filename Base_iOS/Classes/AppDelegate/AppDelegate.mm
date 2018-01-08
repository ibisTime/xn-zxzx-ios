//
//  AppDelegate.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/7/13.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "AppDelegate.h"

#import "IQKeyboardManager.h"

#import "AppConfig.h"

#import <ZMCreditSDK/ALCreditService.h>

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
    
    //配置芝麻信用
    [self configZMOP];
    
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

- (void)configZMOP {
    
    [[ALCreditService sharedService] resgisterApp];
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

    //重新登录
    if([[TLUser user] isLogin]){
        
        TabbarViewController *tabbarCtrl = [[TabbarViewController alloc] init];
        
        self.window.rootViewController = tabbarCtrl;
        
        [[TLUser user] reLogin];

    } else {
        
        self.window.rootViewController = [[NavigationController alloc] initWithRootViewController:[[TLUserLoginVC alloc] init]];
    }
    
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

#pragma mark - 微信和芝麻认证回调
// iOS9 NS_AVAILABLE_IOS
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    
    if ([url.host isEqualToString:@"certi.back"]) {
        
        //查询是否认证成功
        TLNetworking *http = [TLNetworking new];
        http.showView = [UIApplication sharedApplication].keyWindow;
        http.code = @"805252";
        http.parameters[@"bizNo"] = [TLUser user].tempBizNo;
        http.parameters[@"userId"] = [TLUser user].userId;
        http.parameters[@"searchCode"] = [TLUser user].tempSearchCode;
        
        [http postWithSuccess:^(id responseObject) {
            
            NSString *str = [NSString stringWithFormat:@"%@", responseObject[@"data"]];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"RealNameAuthResult" object:str];
            
        } failure:^(NSError *error) {
            
            
        }];
        
        return YES;
    }

    return YES;
}

// iOS9 NS_DEPRECATED_IOS
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    if ([url.host isEqualToString:@"certi.back"]) {
        
        //查询是否认证成功
        TLNetworking *http = [TLNetworking new];
        http.showView = [UIApplication sharedApplication].keyWindow;
        http.code = @"805252";
        http.parameters[@"bizNo"] = [TLUser user].tempBizNo;
        http.parameters[@"userId"] = [TLUser user].userId;
        http.parameters[@"searchCode"] = [TLUser user].tempSearchCode;

        [http postWithSuccess:^(id responseObject) {
            
            NSString *str = [NSString stringWithFormat:@"%@", responseObject[@"data"]];

            [[NSNotificationCenter defaultCenter] postNotificationName:@"RealNameAuthResult" object:str];
            
        } failure:^(NSError *error) {
            
            
        }];
        
        return YES;
    }
    
    return YES;

}

@end
