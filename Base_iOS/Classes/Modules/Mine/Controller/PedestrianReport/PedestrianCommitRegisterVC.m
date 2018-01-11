//
//  PedestrianCommitRegisterVC.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/1/11.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "PedestrianCommitRegisterVC.h"

#import "CoinHeader.h"
#import "AppConfig.h"
#import "NSString+Date.h"
#import "NSString+Check.h"
#import "UIBarButtonItem+convience.h"
#import "TLProgressHUD.h"

#import "TLTextField.h"
#import "CaptchaView.h"
#import <TFHpple.h>

#import "NoReportVC.h"
#import "PedestrianRegisterSuccessVC.h"

@interface PedestrianCommitRegisterVC ()<UITextFieldDelegate>

//用户名
@property (nonatomic,strong) TLTextField *nameTF;
//密码
@property (nonatomic,strong) TLTextField *pwdTF;
//电子邮箱
@property (nonatomic, strong) TLTextField *emailTF;
//手机号
@property (nonatomic, strong) TLTextField *mobileTF;
//动态码
@property (nonatomic, strong) CaptchaView *captchaView;
//
@property (nonatomic, assign) BOOL isFirst;

@end

@implementation PedestrianCommitRegisterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"补充用户信息";
    //补充信息
    [self initSubviews];
}

#pragma mark - Init
- (void)initSubviews {
    
    self.view.backgroundColor = kBackgroundColor;
    
    CGFloat w = kScreenWidth;
    CGFloat h = ACCOUNT_HEIGHT;
    CGFloat leftW = 100;

    NSInteger count = 5;
    CGFloat lineHeight = 0.5;
    //背景
    UIView *bgView = [[UIView alloc] init];
    
    bgView.backgroundColor = kWhiteColor;
    
    [self.view addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(@(10));
        make.left.equalTo(@0);
        make.height.equalTo(@(count*h+(count-1)*lineHeight));
        make.width.equalTo(@(w));
        
    }];
    
    //账号
    TLTextField *nameTF = [[TLTextField alloc] initWithFrame:CGRectMake(0, 0, w, h) leftTitle:@"登录名:" titleWidth:leftW placeholder:@"请输入登录名"];
    nameTF.delegate = self;
    [bgView addSubview:nameTF];
    self.nameTF = nameTF;
    
    //密码
    TLTextField *pwdTF = [[TLTextField alloc] initWithFrame:CGRectMake(0, nameTF.yy+lineHeight, w, h) leftTitle:@"密码:" titleWidth:leftW placeholder:@"请输入登录密码"];
    
    pwdTF.secureTextEntry = YES;
    [bgView addSubview:pwdTF];
    self.pwdTF = pwdTF;
    
    //电子邮箱
    TLTextField *emailTF = [[TLTextField alloc] initWithFrame:CGRectMake(0, pwdTF.yy+lineHeight, w, h) leftTitle:@"电子邮箱:" titleWidth:leftW placeholder:@"请输入电子邮箱(选填)"];
    emailTF.keyboardType = UIKeyboardTypeEmailAddress;
    [bgView addSubview:emailTF];
    self.emailTF = emailTF;
    
    //手机号
    TLTextField *mobileTF = [[TLTextField alloc] initWithFrame:CGRectMake(0, emailTF.yy+lineHeight, w, h) leftTitle:@"手机号:" titleWidth:leftW placeholder:@"请输入手机号"];
    
    mobileTF.keyboardType = UIKeyboardTypeNumberPad;
    [bgView addSubview:mobileTF];
    self.mobileTF = mobileTF;
    
    //短信动态码
    CaptchaView *captchaView = [[CaptchaView alloc] initWithFrame:CGRectMake(0, mobileTF.yy+lineHeight, w, h)];
    
    captchaView.captchaTf.keyboardType = UIKeyboardTypeASCIICapable;
    
    [captchaView.captchaBtn addTarget:self action:@selector(sendCaptcha) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:captchaView];
    
    self.captchaView = captchaView;
    
    for (int i = 0; i < count; i++) {
        
        UIView *line = [[UIView alloc] init];
        
        line.backgroundColor = kLineColor;
        
        [bgView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(@0);
            make.right.equalTo(@0);
            make.height.equalTo(@(lineHeight));
            make.top.equalTo(@((i+1)*h+i*lineHeight));
            
        }];
    }
    
    //提交注册
    UIButton *commitBtn = [UIButton buttonWithTitle:@"提交注册" titleColor:kWhiteColor backgroundColor:kAppCustomMainColor titleFont:17.0 cornerRadius:5];
    [commitBtn addTarget:self action:@selector(commitRegister) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:commitBtn];
    [commitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@(15));
        make.height.equalTo(@(h - 5));
        make.right.equalTo(@(-15));
        make.top.equalTo(bgView.mas_bottom).offset(28+30);
        
    }];
}

#pragma mark - Events

/**
 发送短信动态码
 */
- (void)sendCaptcha {
    
    if (![self.mobileTF.text isPhoneNum]) {
        
        [TLAlert alertWithInfo:@"请输入正确的手机号"];
        return;
    }
    
    ZYNetworking *http = [ZYNetworking new];
    
    http.showView = self.view;
    http.url = kAppendUrl(@"userReg.do");
    http.parameters[@"method"] = @"getAcvitaveCode";
    http.parameters[@"mobileTel"] = self.mobileTF.text;
    
    //Referer
    [http setHeaderWithValue:@"https://ipcrs.pbccrc.org.cn/userReg.do" headerField:@"Referer"];
    //Content-Type
    [http setHeaderWithValue:@"application/x-www-form-urlencoded; charset=UTF-8" headerField:@"Content-Type"];
    //Accept
    [http setHeaderWithValue:@"text/plain, */*; q=0.01" headerField:@"Accept"];
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
    
    if ([result valid]) {
        
        [TLAlert alertWithSucces:@"动态码已发送,请注意查收"];
        
        [self.captchaView.captchaBtn begin];
        
    } else {
        
        [TLAlert alertWithError:@"动态码获取失败，请稍后重试"];
    }
}

/**
 提交注册
 */
- (void)commitRegister {
    
    if (![self.nameTF.text valid]) {
        
        [TLAlert alertWithInfo:@"请输入登录名"];
        return;
    }
    
    if (self.nameTF.text.length < 6) {
        
        [TLAlert alertWithInfo:@"登录名不能小于6个字符"];
        return ;
    }
    
    if (self.nameTF.text.length > 16) {
        
        [TLAlert alertWithInfo:@"登录名不能大于16个字符"];
        return ;
    }
    
    if (![self.pwdTF.text valid]) {
        
        [TLAlert alertWithInfo:@"请输入登录密码"];
        return;
    }
    
    if (self.pwdTF.text.length < 6) {
        
        [TLAlert alertWithInfo:@"登录密码不能小于6个字符"];
        return ;
    }
    
    if (self.pwdTF.text.length > 16) {
        
        [TLAlert alertWithInfo:@"登录密码不能大于16个字符"];
        return ;
    }
    
    if (![self.mobileTF.text isPhoneNum]) {
        
        [TLAlert alertWithInfo:@"请输入正确的手机号"];
        return;
    }
    
    if (![self.captchaView.captchaTf.text valid]) {
        
        [TLAlert alertWithInfo:@"请输入动态码"];
        return;
    }
    
    [self.view endEditing:YES];
    
    ZYNetworking *http = [ZYNetworking new];
    
    http.showView = self.view;
    http.url = kAppendUrl(@"userReg.do");
    http.parameters[@"method"] = @"saveUser";
    http.parameters[@"counttime"] = @"1";
    http.parameters[@"org.apache.struts.taglib.html.TOKEN"] = [TLUser user].tempToken;
    http.parameters[@"userInfoVO.loginName"] = self.nameTF.text;
    http.parameters[@"userInfoVO.password"] = self.pwdTF.text;
    http.parameters[@"userInfoVO.confirmpassword"] = self.pwdTF.text;
    http.parameters[@"userInfoVO.email"] = [self.emailTF.text valid] ? self.emailTF.text: @"";
    http.parameters[@"userInfoVO.mobileTel"] = self.mobileTF.text;
    http.parameters[@"userInfoVO.verifyCode"] = self.captchaView.captchaTf.text;
    http.parameters[@"userInfoVO.smsrcvtimeflag"] = @"1";
    
    //Referer
    [http setHeaderWithValue:@"https://ipcrs.pbccrc.org.cn/userReg.do" headerField:@"Referer"];
    //Content-Type
    [http setHeaderWithValue:@"application/x-www-form-urlencoded" headerField:@"Content-Type"];
    //Accept
    [http setHeaderWithValue:@"text/html, application/xhtml+xml, application/xml, */*" headerField:@"Accept"];
    //Upgrade-Insecure-Requests
    [http setHeaderWithValue:@"1" headerField:@"Upgrade-Insecure-Requests"];
    
    [http postWithSuccess:^(NSString *encoding, id responseObject) {
        
        [self registerSecondSetpWithEncoding:encoding responseObject:responseObject];
        
    } failure:^(NSError *error) {
        
    }];
    
}

/**
 注册第二步
 @param encoding 服务器返回的编码格式
 @param responseObject 字节流数据
 */
- (void)registerSecondSetpWithEncoding:(NSString *)encoding responseObject:(id)responseObject {
    
    NSString *htmlStr = [NSString convertHtmlWithEncoding:encoding data:responseObject];
    
    NSLog(@"htmlStr = %@", htmlStr);
    
    TFHpple *hpple = [[TFHpple alloc] initWithHTMLData:responseObject encoding:encoding];
    //验证登录名是否正确
    NSArray *spanArr = [hpple searchWithXPathQuery:@"//span"];
    
    NSString *registerPrompt = @"";
//    NSString *verifyPrompt = @"";
    
    for (TFHppleElement *element in spanArr) {
        
        if ([[element objectForKey:@"id"] isEqualToString:@"_error_field_"]) {
            //过滤">|\n|\r|\t"符号
            registerPrompt = [element.content regularExpressionWithPattern:@">|\n|\r|\t| "];
        }
        
//        if ([[element objectForKey:@"id"] isEqualToString:@"_@MSG@_"]) {
//            //过滤">|\n|\r|\t"符号
//            verifyPrompt = [element.content regularExpressionWithPattern:@">|\n|\r|\t| "];
//        }
    }
    
    //先判断动态码再判断姓名和证件号码,每次点击下一步失败就刷新动态码
    
//    if ([verifyPrompt valid]) {
//
//        [TLAlert alertWithInfo:verifyPrompt];
//        //刷新Token
//        [self getTokenWithEncoding:encoding responseObject:responseObject];
//
//        return ;
//    }
    
    if ([registerPrompt valid]) {
        
        [TLAlert alertWithInfo:registerPrompt];
        //刷新Token
        [self getTokenWithEncoding:encoding responseObject:responseObject];

        return ;
    }
    
    NSArray *errorArr = [hpple searchWithXPathQuery:@"//div[@class='error']"];
    
    if (errorArr.count > 0) {
        
        [TLAlert alertWithInfo:@"系统繁忙, 请稍后再试"];
        //刷新Token
        [self getTokenWithEncoding:encoding responseObject:responseObject];

        return ;
    }
    
    NSArray *titleArr = [hpple searchWithXPathQuery:@"//title"];
    NSString *title = @"";
    
    for (TFHppleElement *element in titleArr) {
        
        title = element.content;
    }
    
    if (![title valid]) {
        
        [TLAlert alertWithInfo:@"系统繁忙, 请稍后再试"];
        //刷新Token
        [self getTokenWithEncoding:encoding responseObject:responseObject];

        return ;
    }
    
    NSArray *classArr = [hpple searchWithXPathQuery:@"//p"];

    BOOL isSuccess = NO;
    
    for (TFHppleElement *element in classArr) {
        
        if ([element.text containsString:@"您在个人信用信息平台已注册成功"]) {
            
            isSuccess = YES;
        }
    }
    
    if (!isSuccess) {
        
        [TLAlert alertWithError:@"注册失败"];
    }
    
    PedestrianRegisterSuccessVC *successVC = [PedestrianRegisterSuccessVC new];
    
    [self.navigationController pushViewController:successVC animated:YES];
}

#pragma mark - Data

/**
 判断登录名是否被使用
 */
- (void)checkLoginName {
    
    //时间戳
    NSString *timeStamp = [NSString getTimeStamp];
    
    if (![self.nameTF.text valid]) {
        
        return ;
    }
    
    ZYNetworking *http = [ZYNetworking new];
    
    http.url = kAppendUrl(@"userReg.do");
    http.parameters[@"num"] = timeStamp;
    http.parameters[@"method"] = @"checkRegLoginnameHasUsed";
    http.parameters[@"loginname"] = self.nameTF.text;
    
    //Referer
    [http setHeaderWithValue:@"https://ipcrs.pbccrc.org.cn/userReg.do" headerField:@"Referer"];
    //Content-Type
    [http setHeaderWithValue:@"application/x-www-form-urlencoded; charset=UTF-8" headerField:@"Content-Type"];
    //Accept
    [http setHeaderWithValue:@"text/plain, */*; q=0.01" headerField:@"Accept"];
    //X-Requested-With
    [http setHeaderWithValue:@"XMLHttpRequest" headerField:@"X-Requested-With"];
    
    [http postWithSuccess:^(NSString *encoding, id responseObject) {
        
        [self checkLoginNameWithEncoding:encoding responseObject:responseObject];
        
    } failure:^(NSError *error) {
        
    }];
    
}

/**
 具体检查登录名
 */
- (void)checkLoginNameWithEncoding:(NSString *)encoding responseObject:(id)responseObject {
    //result(0:登录名未使用  1:登录名已使用)
    NSString *result = [NSString convertHtmlWithEncoding:encoding data:responseObject];
    
    if ([result isEqualToString:@"1"]) {
        
        [TLAlert alertWithInfo:@"登录名已存在"];
    }

}

/**
 注册初始化
 @param encoding 服务器返回的编码格式
 @param responseObject 字节流数据
 */
- (void)getTokenWithEncoding:(NSString *)encoding responseObject:(id)responseObject {
    
    TFHpple *hpple = [[TFHpple alloc] initWithHTMLData:responseObject encoding:encoding];
    //验证登录名是否正确
    NSArray *dataArr = [hpple searchWithXPathQuery:@"//input[@name='org.apache.struts.taglib.html.TOKEN']"];
    //获取注册流程需要用到的Token
    if (dataArr > 0) {
        
        TFHppleElement *element = dataArr[0];
        
        NSDictionary *attributes = element.attributes;
        
        [TLUser user].tempToken = attributes[@"value"];
        
    } else {
        
        [TLAlert alertWithInfo:@"系统繁忙, 请稍后再试"];
    }
}

#pragma mark - UITextfieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    //检查登录名是否被使用
    if (textField == self.nameTF) {
        
        [self checkLoginName];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
