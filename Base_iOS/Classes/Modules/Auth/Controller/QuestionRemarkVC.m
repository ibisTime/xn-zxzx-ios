//
//  QuestionRemarkVC.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/12/26.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "QuestionRemarkVC.h"
#import <WebKit/WebKit.h>

#import "CoinHeader.h"

#import "APICodeMacro.h"

#import "TLProgressHUD.h"
#import <UIScrollView+TLAdd.h>
//C
#import "ZMAuthVC.h"
#import "BaseInfoAuthVC.h"

@interface QuestionRemarkVC ()<WKNavigationDelegate>

@property (nonatomic, copy) NSString *htmlStr;

@property (nonatomic, strong) WKWebView *webView;

@end

@implementation QuestionRemarkVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"调查申明";
    
    [TLProgressHUD show];
    
    [self requestContent];

}

#pragma mark - Init

- (void)initWebView {
    
    NSString *jS = [NSString stringWithFormat:@"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0'); meta.setAttribute('width', %lf); document.getElementsByTagName('head')[0].appendChild(meta);",kScreenWidth];
    
    WKUserScript *wkUserScript = [[WKUserScript alloc] initWithSource:jS injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    
    WKUserContentController *wkUCC = [WKUserContentController new];
    
    [wkUCC addUserScript:wkUserScript];
    
    WKWebViewConfiguration *wkConfig = [WKWebViewConfiguration new];
    
    wkConfig.userContentController = wkUCC;
    
    _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight - 65 - kBottomInsetHeight) configuration:wkConfig];
    
    _webView.backgroundColor = kWhiteColor;
    _webView.navigationDelegate = self;
    _webView.allowsBackForwardNavigationGestures = YES;
    [_webView.scrollView adjustsContentInsets];
    
    [self.view addSubview:_webView];
    
    [self loadWebWithString:self.htmlStr];
}

- (void)loadWebWithString:(NSString *)string {
    
    NSString *html = [NSString stringWithFormat:@"<head><style>img{width:%lfpx !important;height:auto;margin: 0px auto;} p{word-wrap:break-word;overflow:hidden;}</style></head>%@",kScreenWidth - 16, string];
    
    [_webView loadHTMLString:html baseURL:nil];
}

- (void)initBottomView {
    
    //底部视图
    UIView *bottomView = [[UIView alloc] init];
    
    bottomView.backgroundColor = kWhiteColor;
    
    [self.view addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.bottom.equalTo(@0);
        make.height.equalTo(@(65 + kBottomInsetHeight));
        
    }];
    
    //开始调查
    UIButton *investBtn = [UIButton buttonWithTitle:@"我已知晓, 开始调查" titleColor:kWhiteColor backgroundColor:kAppCustomMainColor titleFont:18 cornerRadius:5];
    
    [investBtn addTarget:self action:@selector(startInvest) forControlEvents:UIControlEventTouchUpInside];
    
    [bottomView addSubview:investBtn];
    [investBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@15);
        make.right.equalTo(@(-15));
        make.top.equalTo(@10);
        make.height.equalTo(@45);
        
    }];
}

#pragma mark - Events
- (void)startInvest {
    
//    ZMAuthVC *authVC = [ZMAuthVC new];
//
//    [self.navigationController pushViewController:authVC animated:YES];
    
    BaseInfoAuthVC *authVC = [BaseInfoAuthVC new];
    
    [self.navigationController pushViewController:authVC animated:YES];
}

#pragma mark - Data

- (void)requestContent {
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = USER_CKEY_CVALUE;
    
    http.parameters[@"ckey"] = @"searchText";
    
    [http postWithSuccess:^(id responseObject) {
        
        self.htmlStr = responseObject[@"data"][@"cvalue"];
        //申明内容
        [self initWebView];
        //调查按钮
        [self initBottomView];
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - WKWebViewDelegate

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation {
    
    [TLProgressHUD dismiss];
    
    [TLAlert alertWithError:@"加载失败"];
    
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
