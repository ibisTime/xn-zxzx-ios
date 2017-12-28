//
//  TongDunVC.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/12/11.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "TongDunVC.h"

#import <WebKit/WebKit.h>

#import "TLProgressHUD.h"
#import "UIBarButtonItem+convience.h"

@interface TongDunVC ()<WKNavigationDelegate>

@property (nonatomic, strong) WKWebView *webView;
//是否有申请单
@property (nonatomic, copy) NSString *isApply;

@end

@implementation TongDunVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"运营商认证";
    
    [self initWebView];
    
    [self initBackItem];

}

#pragma mark - Init
- (void)initBackItem {
    
    [UIBarButtonItem addLeftItemWithImageName:@"返回" frame:CGRectMake(-10, 0, 40, 44) vc:self action:@selector(back)];
}

- (void)initWebView {
    
    WKWebViewConfiguration *wkConfig = [WKWebViewConfiguration new];
    
    _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight) configuration:wkConfig];
    
    _webView.backgroundColor = kWhiteColor;
    
    _webView.navigationDelegate = self;
    
    _webView.allowsBackForwardNavigationGestures = YES;
    
    [self.view addSubview:_webView];
    
    NSString *token = @"5613A6F334DC4E12944AF748EE11FDEA";
    
    NSString *cb = @"http://www.baidu.com";
    
    NSString *htmlStr = [NSString stringWithFormat:@"https://open.shujumohe.com/box/yys?box_token=%@&real_name=%@&identity_code=%@&user_mobile=%@&cb=%@", token, [TLUser user].realName,[TLUser user].idNo, [TLUser user].mobile, cb];
    
    [self loadWebWithUrl:[htmlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
}

- (void)loadWebWithUrl:(NSString *)url {
    
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];

    [_webView loadRequest:urlRequest];
}

#pragma mark - Events
- (void)back {
    
    //获取认证回调
    if (self.respBlock) {
        
        self.respBlock(nil);
    }
}

#pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    
    [TLProgressHUD show];
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation{
    
    [TLProgressHUD showWithStatus:@"加载失败"];
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {

    NSURL *url = navigationAction.request.URL;
    NSString *scheme = [url scheme]; //webView尝试访问链接时，会被此处拦截处理
    if ([scheme isEqualToString:@"http"]) {
        NSString *host = [url host];
        //判断host
        if ([host isEqualToString:@"www.baidu.com"]) {
            
            NSArray *arr = [url.absoluteString componentsSeparatedByString:@"task_id"];
            
            NSString *taskId = @"";
            
            if (arr.count > 1) {
                
                taskId = arr[1];
            }
            
            //返回NO,阻止页面继续跳转到不存在的url地址
            decisionHandler(WKNavigationActionPolicyCancel);
            
            [self.navigationController popViewControllerAnimated:YES];
            
            //获取认证回调
            if (self.respBlock) {
                
                self.respBlock(taskId);
            }
        
            return ;
        }
    }

    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    
    [TLProgressHUD dismiss];
    
    [webView evaluateJavaScript:@"document.body.scrollHeight" completionHandler:^(id _Nullable string, NSError * _Nullable error) {
        
        [self changeWebViewHeight:string];
    }];
    
}

- (void)changeWebViewHeight:(NSString *)heightStr {
    
    CGFloat height = [heightStr integerValue];
    
    // 改变webView和scrollView的高度
    
    _webView.scrollView.contentSize = CGSizeMake(kScreenWidth, height);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
