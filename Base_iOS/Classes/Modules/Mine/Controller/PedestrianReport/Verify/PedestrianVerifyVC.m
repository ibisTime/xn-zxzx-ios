//
//  PedestrianVerifyVC.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/1/12.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "PedestrianVerifyVC.h"

#import "CoinHeader.h"
#import "CaptchaView.h"
#import "AppConfig.h"
#import "NSString+Date.h"
#import "NSString+Check.h"

#import <TFHpple.h>

#import "PedestrianReportVC.h"
#import "PedestrianManager.h"

@interface PedestrianVerifyVC ()
//身份验证码
@property (nonatomic, strong) CaptchaView *captchaView;
//
@property (nonatomic, strong) PedestrianManager *manager;

@end

@implementation PedestrianVerifyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"查看报告";
    
    [self initSubviews];
}

#pragma mark - Init
- (void)initSubviews {
    
    self.manager = [PedestrianManager new];
    
    self.view.backgroundColor = kBackgroundColor;
    
    CGFloat w = kScreenWidth;
    CGFloat h = ACCOUNT_HEIGHT;

    //身份验证码
    CaptchaView *captchaView = [[CaptchaView alloc] initWithFrame:CGRectMake(0, 10, w, h)];
    
    captchaView.captchaTf.leftLbl.text = @"身份验证码";
    
    captchaView.captchaTf.keyboardType = UIKeyboardTypeASCIICapable;
    
    [captchaView.captchaBtn addTarget:self action:@selector(sendCaptcha) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:captchaView];
    
    self.captchaView = captchaView;
    
    //下一步
    UIButton *nextBtn = [UIButton buttonWithTitle:@"下一步" titleColor:kWhiteColor backgroundColor:kAppCustomMainColor titleFont:17.0 cornerRadius:5];
    [nextBtn addTarget:self action:@selector(nextSetp) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextBtn];
    [nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@(15));
        make.height.equalTo(@(h - 5));
        make.right.equalTo(@(-15));
        make.top.equalTo(captchaView.mas_bottom).offset(30);
        
    }];
}

#pragma mark - Events
/**
 发送短信动态码
 */
- (void)sendCaptcha {
    
    ZYNetworking *http = [ZYNetworking new];
    
    http.showView = self.view;
    http.url = kAppendUrl(@"reportAction.do");
    http.parameters[@"method"] = @"sendAgain";
    http.parameters[@"reportformat"] = @"21";
    
    //Referer
    [http setHeaderWithValue:@"https://ipcrs.pbccrc.org.cn/reportAction.do?method=queryReport" headerField:@"Referer"];
    //Content-Type
    [http setHeaderWithValue:@"application/x-www-form-urlencoded; charset=UTF-8" headerField:@"Content-Type"];
    //Accept
    [http setHeaderWithValue:@"text/plain, */*; q=0.01" headerField:@"Accept"];
    //X-Requested-With
    [http setHeaderWithValue:@"XMLHttpRequest" headerField:@"X-Requested-With"];
    //Cookie
    if ([[AppConfig getUsetDefaultCookie] valid]) {
        
        [http setHeaderWithValue:[AppConfig getUsetDefaultCookie] headerField:@"Cookie"];
    }
    
    [http postWithSuccess:^(NSString *encoding, id responseObject) {
        
        [self getVerifyWithEncoding:encoding responseObject:responseObject];
        
    } failure:^(NSError *error) {
        
    }];
}

/**
 解析短信动态码
 */
- (void)getVerifyWithEncoding:(NSString *)encoding responseObject:(id)responseObject {
    
    //result不为空说明动态码发送成功,否则发送失败
    NSString *result = [NSString convertHtmlWithEncoding:encoding data:responseObject];
    
    self.manager.idVerifyResult = result;
    
    if ([result isEqualToString:@"success"]) {
        
        [TLAlert alertWithSucces:self.manager.idVerifyPromptStr];
        
        [self.captchaView.captchaBtn begin];
        
    } else if([result isEqualToString:@"noTradeCode"]) {
        
        [TLAlert alertWithError:self.manager.idVerifyPromptStr];
        
    } else {
        
        [TLAlert alertWithError:@"获取验证码错误"];
    }
}

- (void)nextSetp {
    
    self.captchaView.captchaTf.text = @"kte3ds";

    if (![self.captchaView.captchaTf.text valid]) {
        
        [TLAlert alertWithInfo:@"请输入身份验证码"];
        return;
    }
    
    [self.view endEditing:YES];
    
    ZYNetworking *http = [ZYNetworking new];
    
    http.showView = self.view;
    http.url = kAppendUrl(@"reportAction.do");
    http.parameters[@"method"] = @"checkTradeCode";
    http.parameters[@"code"] = self.captchaView.captchaTf.text;
    http.parameters[@"reportformat"] = @"21";
    
    //Referer
    [http setHeaderWithValue:@"https://ipcrs.pbccrc.org.cn/reportAction.do?method=queryReport" headerField:@"Referer"];
    //Content-Type
    [http setHeaderWithValue:@"application/x-www-form-urlencoded; charset=UTF-8" headerField:@"Content-Type"];
    //Accept
    [http setHeaderWithValue:@"text/plain, */*; q=0.01" headerField:@"Accept"];
    //X-Requested-With
    [http setHeaderWithValue:@"XMLHttpRequest" headerField:@"X-Requested-With"];
    //Cookie
    if ([[AppConfig getUsetDefaultCookie] valid]) {
        
        [http setHeaderWithValue:[AppConfig getUsetDefaultCookie] headerField:@"Cookie"];
    }
    
    [http postWithSuccess:^(NSString *encoding, id responseObject) {
        
        [self queryReportWithEncoding:encoding responseObject:responseObject];
        
    } failure:^(NSError *error) {
        
    }];
    
}

/**
 解析查询结果
 */
- (void)queryReportWithEncoding:(NSString *)encoding responseObject:(id)responseObject {
    
    //result为0代表身份验证码正确,1代表错误
    NSString *result = [NSString convertHtmlWithEncoding:encoding data:responseObject];
    
    if ([result isEqualToString:@"0"]) {
        /*
         counttime:验证码倒计时
         reportformat:21(个人信息报告)
         tradeCode:身份验证码
         */

        PedestrianReportVC *reportVC = [PedestrianReportVC new];
        
        reportVC.reportUrl = @"https://ipcrs.pbccrc.org.cn/simpleReport.do?method=viewReport";
        
        reportVC.postParam = [NSString stringWithFormat:@"counttime=1&reportformat=21&tradeCode=%@", self.captchaView.captchaTf.text] ;
        
        [self.navigationController pushViewController:reportVC animated:YES];
        
    } else if ([result isEqualToString:@"1"]) {
        
        [TLAlert alertWithError:@"身份验证码不正确"];
        
    } else {
        
        [TLAlert alertWithInfo:@"由于您长时间未进行任何操作，系统已退出，如需继续使用请您重新登录"];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

