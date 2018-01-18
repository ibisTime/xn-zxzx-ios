//
//  PedestrianResetPwdVC.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/1/16.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "PedestrianResetPwdVC.h"

#import "NSString+Check.h"
#import "TLProgressHUD.h"

#import "TLTextField.h"
#import "CaptchaView.h"

//C
#import "PedestrianFindPwdQuestionVC.h"

@interface PedestrianResetPwdVC ()

//新密码
@property (nonatomic,strong) TLTextField *pwdTF;
//确认新密码
@property (nonatomic, strong) TLTextField *confirmPwdTF;
//动态码
@property (nonatomic, strong) CaptchaView *captchaView;
//
@property (nonatomic, assign) BOOL isFirst;

@end

@implementation PedestrianResetPwdVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"设置新密码";
    //设置新密码
    [self initSubviews];
}

#pragma mark - Init
- (void)initSubviews {
    
    self.view.backgroundColor = kBackgroundColor;
    
    CGFloat w = kScreenWidth;
    CGFloat h = ACCOUNT_HEIGHT;
    CGFloat leftW = 105;
    
    NSInteger count = 3;
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
    
    //新密码
    TLTextField *pwdTF = [[TLTextField alloc] initWithFrame:CGRectMake(0, 10, w, h) leftTitle:@"新密码:" titleWidth:leftW placeholder:@"请输入新密码"];
    
    pwdTF.secureTextEntry = YES;
    [bgView addSubview:pwdTF];
    self.pwdTF = pwdTF;
    
    //确认新密码
    TLTextField *confirmPwdTF = [[TLTextField alloc] initWithFrame:CGRectMake(0, pwdTF.yy+lineHeight, w, h) leftTitle:@"确认新密码:" titleWidth:leftW placeholder:@"请确认新密码"];
    
    confirmPwdTF.secureTextEntry = YES;
    [bgView addSubview:confirmPwdTF];
    self.confirmPwdTF = confirmPwdTF;
    
    //短信动态码
    CaptchaView *captchaView = [[CaptchaView alloc] initWithFrame:CGRectMake(0, confirmPwdTF.yy+lineHeight, w, h)];
    
    captchaView.captchaTf.leftLbl.text = @"短信动态码";
    [captchaView.captchaBtn setTitle:@"获取动态码" forState:UIControlStateNormal];
    captchaView.captchaTf.keyboardType = UIKeyboardTypeASCIICapable;
    captchaView.totalTime = 120;
    
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
            make.top.equalTo(@((i+1)*h+i*lineHeight+10));
            
        }];
    }
    
    //下一步
    UIButton *nextBtn = [UIButton buttonWithTitle:@"下一步" titleColor:kWhiteColor backgroundColor:kAppCustomMainColor titleFont:17.0 cornerRadius:5];
    [nextBtn addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextBtn];
    [nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
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
    
    ZYNetworking *http = [ZYNetworking new];
    
    http.showView = self.view;
    http.url = kAppendUrl(@"resetPassword.do");
    http.parameters[@"method"] = @"getAcvitaveCode";
    http.parameters[@"counttime"] = @"119";
    //Referer
    [http setHeaderWithValue:@"https://ipcrs.pbccrc.org.cn/resetPassword.do" headerField:@"Referer"];
    //Content-Type
    [http setHeaderWithValue:@"application/x-www-form-urlencoded; charset=UTF-8" headerField:@"Content-Type"];
    //Accept
    [http setHeaderWithValue:@"text/plain, */*; q=0.01" headerField:@"Accept"];
    //X-Requested-With
    [http setHeaderWithValue:@"XMLHttpRequest" headerField:@"X-Requested-With"];
    //Accept-Language
    [http setHeaderWithValue:@"zh-CN,zh;q=0.8,zh-TW;q=0.7,zh-HK;q=0.5,en-US;q=0.3,en;q=0.2" headerField:@"Accept-Language"];
    
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
    
    //result不为空说明动态码发送成功,否则发送失败
    NSString *result = [NSString convertHtmlWithEncoding:encoding data:responseObject];
    
    if ([result isEqualToString:@"success"]) {
        
        [TLAlert alertWithSucces:@"动态码已发送,请注意查收"];
        
        [self.captchaView.captchaBtn begin];
        
        return ;
        
    } else {
        
        [TLAlert alertWithError:@"动态码获取失败，请稍后重试"];
        return ;
    }

}

/**
 下一步
 */
- (void)next {
    
    if (![self.pwdTF.text valid]) {
        
        [TLAlert alertWithInfo:@"请输入新密码"];
        return ;
    }
    
    if (self.pwdTF.text.length < 6) {
        
        [TLAlert alertWithInfo:@"新密码不能小于6个字符"];
        return ;
    }
    
    if (self.pwdTF.text.length > 20) {
        
        [TLAlert alertWithInfo:@"新密码不能大于20个字符"];
        return ;
    }
    
    if (![self.confirmPwdTF.text valid]) {
        
        [TLAlert alertWithInfo:@"请确认新密码"];
        return ;
    }
    
    if (![self.pwdTF.text isEqualToString:self.confirmPwdTF.text]) {
        
        [TLAlert alertWithInfo:@"两次输入的密码不一致"];
        return ;
    }
    
    if (![self.captchaView.captchaTf.text valid]) {
        
        [TLAlert alertWithInfo:@"请输入动态码"];
        return;
    }
    
    [self.view endEditing:YES];
    
    ZYNetworking *http = [ZYNetworking new];
    
    http.showView = self.view;
    http.url = kAppendUrl(@"resetPassword.do");
    http.parameters[@"method"] = @"resetPassword";
    http.parameters[@"verifyCode"] = self.captchaView.captchaTf.text;
    http.parameters[@"counttime"] = @"1";
    http.parameters[@"password"] = self.pwdTF.text;
    http.parameters[@"confirmpassword"] = self.confirmPwdTF.text;
    
    //Referer
    [http setHeaderWithValue:@"https://ipcrs.pbccrc.org.cn/resetPassword.do" headerField:@"Referer"];
    //Content-Type
    [http setHeaderWithValue:@"application/x-www-form-urlencoded" headerField:@"Content-Type"];
    //Accept
    [http setHeaderWithValue:@"text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8" headerField:@"Accept"];
    //Accept-Language
    [http setHeaderWithValue:@"zh-CN,zh;q=0.8,zh-TW;q=0.7,zh-HK;q=0.5,en-US;q=0.3,en;q=0.2" headerField:@"Accept-Language"];
    //Upgrade-Insecure-Requests
    [http setHeaderWithValue:@"1" headerField:@"Upgrade-Insecure-Requests"];
    
    [http postWithSuccess:^(NSString *encoding, id responseObject) {
        //这里的Token是不变的，不需要刷新
        [self getTokenWithEncoding:encoding responseObject:responseObject];

        [self findPwdSecondSetpWithEncoding:encoding responseObject:responseObject];
        
    } failure:^(NSError *error) {
        
    }];
    
}

/**
 找回第二步
 @param encoding 服务器返回的编码格式
 @param responseObject 字节流数据
 */
- (void)findPwdSecondSetpWithEncoding:(NSString *)encoding responseObject:(id)responseObject {
    
    NSString *htmlStr = [NSString convertHtmlWithEncoding:encoding data:responseObject];

    NSLog(@"htmlStr = %@", htmlStr);

    TFHpple *hpple = [[TFHpple alloc] initWithHTMLData:responseObject encoding:encoding];
    
    //验证密码和验证码是否正确
    NSArray *spanArr = [hpple searchWithXPathQuery:@"//span"];

    NSString *registerPrompt = @"";

    for (TFHppleElement *element in spanArr) {

        if ([[element objectForKey:@"id"] isEqualToString:@"_error_field_"]) {
            //过滤">|\n|\r|\t"符号
            registerPrompt = [element.content regularExpressionWithPattern:@">|\n|\r|\t| "];
        }
    }

    if ([registerPrompt valid]) {

        [TLAlert alertWithInfo:registerPrompt];
        return ;
    }

    //判断用户等级, 如果等级过高那就提示用户去征信中心操作
    NSArray *labelArr = [hpple searchWithXPathQuery:@"//label"];
    
    BOOL isHighLevel = YES;
    
    for (TFHppleElement *element in labelArr) {
        
        if ([element.content containsString:@"问题验证"]) {
            
            isHighLevel = NO;
        }
    }
    
    if (isHighLevel) {
        
        [TLAlert alertWithTitle:@"提示" message:@"您安全等级过高，无法使用此功能。请自行前往官网修改。\n官网地址：https://ipcrs.pbccrc.org.cn/" confirmMsg:@"OK" confirmAction:^{
            
            [self.navigationController popToRootViewControllerAnimated:YES];
        }];
        
        return ;
    }
    
    PedestrianFindPwdQuestionVC *questionVC = [PedestrianFindPwdQuestionVC new];
    
    [self.navigationController pushViewController:questionVC animated:YES];
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
    //获取找回密码流程需要用的Token
    if (dataArr.count > 0) {
        
        TFHppleElement *element = dataArr[0];
        
        NSDictionary *attributes = element.attributes;
        
        [TLUser user].tempToken = attributes[@"value"];
        
        return ;
        
    } else {
        
        [TLAlert alertWithInfo:@"系统繁忙, 请稍后再试"];
        return ;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
