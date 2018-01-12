//
//  PedestrianReportVC.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/1/12.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "PedestrianReportVC.h"
#import <WebKit/WebKit.h>
#import "TLProgressHUD.h"

#import "AppConfig.h"
#import "NSString+Check.h"

@interface PedestrianReportVC ()<WKNavigationDelegate>

@end

@implementation PedestrianReportVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"个人信用报告";
        
    [self initWebView];
}

#pragma mark - Init
- (void)initWebView {
    
    WKWebViewConfiguration *webConfig = [[WKWebViewConfiguration alloc] init];
    
    WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavigationBarHeight) configuration:webConfig];
    [self.view addSubview:webView];
    webView.navigationDelegate = self;
    
    NSURL *url = [[NSURL alloc] initWithString:self.reportUrl];
    NSMutableURLRequest *req = [[NSMutableURLRequest alloc] initWithURL:url];

    req.HTTPMethod = @"POST";
    //postParam
    [req setHTTPBody:[self.postParam dataUsingEncoding:NSUTF8StringEncoding]];
    
    //Accept
    [req setValue:@"text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8" forHTTPHeaderField:@"Accept"];
    //Accept-Language
    [req setValue:@"zh-CN,zh;q=0.8,zh-TW;q=0.7,zh-HK;q=0.5,en-US;q=0.3,en;q=0.2" forHTTPHeaderField:@"Accept-Language"];
    //Cache-Control
    [req setValue:@"max-age=0" forHTTPHeaderField:@"Cache-Control"];
    //Accept-Encoding
    [req setValue:@"gzip, deflate, br" forHTTPHeaderField:@"Accept-Encoding"];
    //Content-Type
    [req setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    //Referer
    [req setValue:@"https://ipcrs.pbccrc.org.cn/reportAction.do?method=queryReport" forHTTPHeaderField:@"Referer"];
    //Upgrade-Insecure-Requests
    [req setValue:@"1" forHTTPHeaderField:@"Upgrade-Insecure-Requests"];
    //Host
    [req setValue:@"ipcrs.pbccrc.org.cn" forHTTPHeaderField:@"Host"];
    //Connection
    [req setValue:@"keep-alive" forHTTPHeaderField:@"Connection"];
    //Cookie
    if ([[AppConfig getUsetDefaultCookie] valid]) {
        
        [req setValue:[AppConfig getUsetDefaultCookie] forHTTPHeaderField:@"Cookie"];
        NSLog(@"cookie = %@", [AppConfig getUsetDefaultCookie]);
    }
    
    // 实例化网络会话
    NSURLSession *session = [NSURLSession sharedSession];
    // 创建请求Task
    NSURLSessionDataTask *task = [session dataTaskWithRequest:req completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        
        NSString *textEncoding = [httpResponse textEncodingName];
        
        // 将请求到的网页数据用loadHTMLString 的方法加载
        NSString *htmlStr = [NSString convertHtmlWithEncoding:textEncoding data:data];
        
        [webView loadHTMLString:htmlStr baseURL:nil];
    }];
    
    // 开启网络任务
    [task resume];
    
}

#pragma mark - Setting
//- (void)setTitleStr:(NSString *)titleStr {
//
//    _titleStr = titleStr;
//    self.title = titleStr;
//}

#pragma mark - WebView
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation {
    
    [TLProgressHUD dismiss];
    
    [TLAlert alertWithError:@"加载失败"];
    
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    
    [TLProgressHUD show];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    
    [TLProgressHUD dismiss];

//    if (self.titleStr) {
//
//        return ;
//    }
//
    [webView evaluateJavaScript:@"document.title" completionHandler:^(id _Nullable string, NSError * _Nullable error) {
        
        self.title = string;
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
