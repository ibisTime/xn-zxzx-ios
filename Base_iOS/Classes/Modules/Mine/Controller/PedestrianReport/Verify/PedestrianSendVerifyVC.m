//
//  PedestrianSendVerifyVC.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/1/17.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "PedestrianSendVerifyVC.h"

#import "CaptchaView.h"
#import "NSString+Date.h"
#import "NSString+Check.h"

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
    
    //短信验证码
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
//    http.parameters[@"counttime"] = @"1";
    http.parameters[@"verifyCode"] = @"";
    
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
        
        [self.captchaView.captchaBtn begin];

        [TLAlert alertWithSucces:self.manager.idVerifyPromptStr];
        
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
    http.parameters[@"verifyCode"] = self.captchaView.captchaTf.text;
    http.parameters[@"ApplicationOption"] = @"21";
    http.parameters[@"authtype"] = @"5";
    http.parameters[@"counttime"] = @"1";
    http.parameters[@"org.apache.struts.taglib.html.TOKEN"] = [TLUser user].tempToken;
    
    //Referer
    [http setHeaderWithValue:@"https://ipcrs.pbccrc.org.cn/reportAction.do?method=applicationReport" headerField:@"Referer"];
    //Accept
    [http setHeaderWithValue:@"text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8" headerField:@"Accept"];
    //Accept-Language
    [http setHeaderWithValue:@"zh-CN,zh;q=0.8,zh-TW;q=0.7,zh-HK;q=0.5,en-US;q=0.3,en;q=0.2" headerField:@"Accept-Language"];
    
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
    
    TFHpple *hpple = [[TFHpple alloc] initWithHTMLData:responseObject encoding:encoding];
    
    NSArray *errorArr = [hpple searchWithXPathQuery:@"//div[@class='erro_div1']"];
    //判断验证码是否正确
    if (errorArr.count > 0) {
        
        TFHppleElement *element = errorArr[0];
        
        [TLAlert alertWithInfo:[element.content regularExpressionWithPattern:@">|\n|\r|\t| "]];
        //获取Token
        [self getTokenWithEncoding:encoding responseObject:responseObject];

        return ;
    }
    //
    NSArray *dataArr = [hpple searchWithXPathQuery:@"//div"];
    
    NSString *successStr = @"您的信用信息查询请求已提交，请在24小时后访问平台获取结果。为保障您的信息安全，您申请的信用信息将于7日后自动清理，请及时获取查询结果。";
    
    BOOL isSuccess = NO;
    
    for (TFHppleElement *element in dataArr) {
        
        if ([element.content containsString:successStr]) {
            
            isSuccess = YES;
        }
    };
    
    if (isSuccess) {
        
        PedestrianVerifySuccessVC *successVC = [PedestrianVerifySuccessVC new];
        
        [self.navigationController pushViewController:successVC animated:YES];
        
    } else {
        
        [TLAlert alertWithInfo:@"系统繁忙，请稍后再试"];
    }
   }

/**
 获取Token
 @param encoding 服务器返回的编码格式
 @param responseObject 字节流数据
 */
- (void)getTokenWithEncoding:(NSString *)encoding responseObject:(id)responseObject {
    
    NSString *htmlStr = [NSString convertHtmlWithEncoding:encoding data:responseObject];
    
    NSLog(@"htmlStr = %@", htmlStr);
    
    TFHpple *hpple = [[TFHpple alloc] initWithHTMLData:responseObject encoding:encoding];
    NSArray *dataArr = [hpple searchWithXPathQuery:@"//input[@name='org.apache.struts.taglib.html.TOKEN']"];
    if (dataArr.count > 0) {
        
        TFHppleElement *element = dataArr[0];
        
        NSDictionary *attributes = element.attributes;
        
        [TLUser user].tempToken = attributes[@"value"];
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
