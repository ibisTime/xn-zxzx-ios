//
//  PedestrianSendVerifyVC.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/1/17.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "PedestrianSendVerifyVC.h"

#import "CoinHeader.h"
#import "CaptchaView.h"
#import "AppConfig.h"
#import "NSString+Date.h"
#import "NSString+Check.h"

#import <TFHpple.h>

#import "PedestrianVerifySuccessVC.h"

#import "PedestrianManager.h"

@interface PedestrianSendVerifyVC ()

//短信验证码
@property (nonatomic, strong) CaptchaView *captchaView;
//
@property (nonatomic, strong) PedestrianManager *manager;

@end

@implementation PedestrianSendVerifyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"验证身份";
    
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
    
    captchaView.captchaTf.leftLbl.text = @"手机验证码";
    
    captchaView.captchaTf.keyboardType = UIKeyboardTypeASCIICapable;
    captchaView.totalTime = 120;
    
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
    
    NSString *timeStamp = [NSString getTimeStamp];
    
    NSString *url = [NSString stringWithFormat:@"%@?%@", kAppendUrl(@"reportAction.do"), timeStamp];
    
    ZYNetworking *http = [ZYNetworking new];
    
    http.showView = self.view;
    http.url = url;
    http.parameters[@"method"] = @"send";
    http.parameters[@"counttime"] = @"1";

    //Referer
    [http setHeaderWithValue:@"https://ipcrs.pbccrc.org.cn/reportAction.do?method=applicationReport" headerField:@"Referer"];
    //Content-Type
    [http setHeaderWithValue:@"application/x-www-form-urlencoded; charset=UTF-8" headerField:@"Content-Type"];
    //Accept
    [http setHeaderWithValue:@"text/plain, */*; q=0.01" headerField:@"Accept"];
    //Accept-Language
    [http setHeaderWithValue:@"zh-CN,zh;q=0.8,zh-TW;q=0.7,zh-HK;q=0.5,en-US;q=0.3,en;q=0.2" headerField:@"Accept-Language"];
    //X-Requested-With
    [http setHeaderWithValue:@"XMLHttpRequest" headerField:@"X-Requested-With"];
    
    [http postWithSuccess:^(NSString *encoding, id responseObject) {
        
        [self.captchaView.captchaBtn begin];

        [self getVerifyWithEncoding:encoding responseObject:responseObject];
        
    } failure:^(NSError *error) {
        
    }];
}

/**
 解析短信动态码
 */
- (void)getVerifyWithEncoding:(NSString *)encoding responseObject:(id)responseObject {
    
    //系统错误
    [self systemErrorWithBlock:^{
        
        return ;
        
    } encoding:encoding responseObject:responseObject];
    
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
    
    //    self.captchaView.captchaTf.text = @"kte3ds";
    
    if (![self.captchaView.captchaTf.text valid]) {
        
        [TLAlert alertWithInfo:@"请输入手机动态码"];
        return;
    }
    
    [self.view endEditing:YES];
    
    ZYNetworking *http = [ZYNetworking new];
    
    http.showView = self.view;
    http.url = kAppendUrl(@"reportAction.do");
    http.parameters[@"method"] = @"submitQS";
    http.parameters[@"code"] = self.captchaView.captchaTf.text;
    http.parameters[@"ApplicationOption"] = @"21";
    
    //Referer
    [http setHeaderWithValue:@"https://ipcrs.pbccrc.org.cn/reportAction.do?method=applicationReport" headerField:@"Referer"];
    //Content-Type
    [http setHeaderWithValue:@"application/x-www-form-urlencoded; charset=UTF-8" headerField:@"Content-Type"];
    //Accept
    [http setHeaderWithValue:@"text/plain, */*; q=0.01" headerField:@"Accept"];
    //X-Requested-With
    [http setHeaderWithValue:@"XMLHttpRequest" headerField:@"X-Requested-With"];
    
    [http postWithSuccess:^(NSString *encoding, id responseObject) {
        
        [self queryReportWithEncoding:encoding responseObject:responseObject];
        
    } failure:^(NSError *error) {
        
    }];
    
}

/**
 解析查询结果
 */
- (void)queryReportWithEncoding:(NSString *)encoding responseObject:(id)responseObject {
    
    NSString *htmlStr = [NSString convertHtmlWithEncoding:encoding data:responseObject];
    
    NSLog(@"htmlStr = %@", htmlStr);
    
    //系统错误
    [self systemErrorWithBlock:^{
        
        return ;
        
    } encoding:encoding responseObject:responseObject];
    
    //result为0代表身份验证码正确,1代表错误
    NSString *result = [NSString convertHtmlWithEncoding:encoding data:responseObject];
    
    if ([result isEqualToString:@"0"]) {
        /*
         counttime:验证码倒计时
         reportformat:21(个人信息报告)
         tradeCode:身份验证码
         */
        
        PedestrianVerifySuccessVC *successVC = [PedestrianVerifySuccessVC new];
        
        [self.navigationController pushViewController:successVC animated:YES];
        
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
