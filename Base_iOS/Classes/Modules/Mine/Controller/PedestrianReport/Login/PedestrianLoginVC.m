//
//  PedestrianLoginVC.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/1/8.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "PedestrianLoginVC.h"

#import "CoinHeader.h"
#import "AppConfig.h"
#import "NSString+Date.h"
#import "NSString+Check.h"
#import "NSString+CGSize.h"
#import "UILabel+Extension.h"
#import "UIControl+Block.h"
#import "TLProgressHUD.h"

#import "AccountTf.h"
#import <TFHpple.h>

#import "NoReportVC.h"
#import "PedestrianVerifyVC.h"

#import "PedestrianFindLoginNameVC.h"
#import "PedestrianFindPwdVC.h"

@interface PedestrianLoginVC ()
//用户名
@property (nonatomic,strong) AccountTf *nameTF;
//密码
@property (nonatomic,strong) AccountTf *pwdTF;
//验证码
@property (nonatomic, strong) AccountTf *verifyTF;
//验证码图片
@property (nonatomic, strong) UIImageView *verifyIV;
//
@property (nonatomic, assign) BOOL isFirst;

@end

@implementation PedestrianLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"登录";
    
    [AppConfig setUserDefaultCookie:@""];
    
    //获取图片验证码
    [self requestImgVerify];
    //登录
    [self initSubviews];
    
}

#pragma mark - Init
- (void)initSubviews {
    
    self.view.backgroundColor = kBackgroundColor;
    
    CGFloat w = kScreenWidth;
    CGFloat h = ACCOUNT_HEIGHT;
    CGFloat lineHeight = 0.5;
    
    //账号
    AccountTf *nameTF = [[AccountTf alloc] initWithFrame:CGRectMake(0, 10, w, h)];
    nameTF.leftIconView.image = [UIImage imageNamed:@"用户名"];
    nameTF.placeHolder = @"请输入登录名";
    [self.bgSV addSubview:nameTF];
    self.nameTF = nameTF;
    
    //提示:
    UILabel *namePromptLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor2 font:14.0];
    
    namePromptLbl.numberOfLines = 0;
    
    NSString *nameText = @"提示: 登录名由6-16位数字、字母组成, 不能有中文或特殊字符。";
    
    [namePromptLbl labelWithTextString:nameText lineSpace:5];
    [self.bgSV addSubview:namePromptLbl];
    [namePromptLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(@(nameTF.yy+8));
        make.left.equalTo(@15);
        make.width.equalTo(@(kScreenWidth-30));
        
    }];
    
    CGFloat pH1 = [nameText calculateStringSize:CGSizeMake(kScreenWidth - 30, MAXFLOAT) font:Font(14.0)].height + 20;
    
    //密码
    AccountTf *pwdTF = [[AccountTf alloc] initWithFrame:CGRectMake(0, nameTF.yy+lineHeight+pH1, w, h)];
    pwdTF.secureTextEntry = YES;
    pwdTF.leftIconView.image = [UIImage imageNamed:@"密码"];
    pwdTF.placeHolder = @"请输入密码";
    [self.bgSV addSubview:pwdTF];
    self.pwdTF = pwdTF;
    
    //提示:
    UILabel *pwdPromptLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor2 font:14.0];
    
    pwdPromptLbl.numberOfLines = 0;
    
    [pwdPromptLbl labelWithTextString:@"提示: 密码长度必须在6-20之间, 可以使用数字、小写字母和大写字母, 但必须同时包含数字和字母。" lineSpace:5];
    [self.bgSV addSubview:pwdPromptLbl];
    [pwdPromptLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(@(pwdTF.yy + 8));
        make.left.equalTo(@15);
        make.width.equalTo(@(kScreenWidth-30));
        
    }];
    
    CGFloat pH2 = [nameText calculateStringSize:CGSizeMake(kScreenWidth - 30, MAXFLOAT) font:Font(14.0)].height + 20;
    
    //验证码
    AccountTf *verifyTF = [[AccountTf alloc] initWithFrame:CGRectMake(0, pwdTF.yy+lineHeight+pH2, w-115, h)];
    verifyTF.leftIconView.image = [UIImage imageNamed:@"验证码"];
    verifyTF.placeHolder = @"请输入验证码";
    [self.bgSV addSubview:verifyTF];
    self.verifyTF = verifyTF;
    
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(verifyTF.xx, pwdTF.yy+lineHeight+pH2, 100+15, h)];

    rightView.backgroundColor = kWhiteColor;
    
    [self.bgSV addSubview:rightView];

    _verifyIV = [[UIImageView alloc] init];

    [rightView addSubview:_verifyIV];
    
    //换一个
    UIButton *changeVerifyBtn = [UIButton buttonWithTitle:@"看不清, 换一个" titleColor:kTextColor2 backgroundColor:kClearColor titleFont:14.0];
    
    changeVerifyBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [changeVerifyBtn addTarget:self action:@selector(changeVerify) forControlEvents:UIControlEventTouchUpInside];
    [self.bgSV addSubview:changeVerifyBtn];
    
    [changeVerifyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.top.equalTo(verifyTF.mas_bottom).offset(10);
        
    }];
    
    //登录
    UIButton *loginBtn = [UIButton buttonWithTitle:@"登录" titleColor:kWhiteColor backgroundColor:kAppCustomMainColor titleFont:17.0 cornerRadius:5];
    [loginBtn addTarget:self action:@selector(goLogin) forControlEvents:UIControlEventTouchUpInside];
    [self.bgSV addSubview:loginBtn];
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@(15));
        make.height.equalTo(@(h - 5));
        make.width.equalTo(@(kScreenWidth - 30));
        make.top.equalTo(verifyTF.mas_bottom).offset(28+30);
        
    }];
    //找回登录名
    UIButton *findNameBtn = [UIButton buttonWithTitle:@"找回登录名" titleColor:kTextColor2 backgroundColor:kClearColor titleFont:14.0];
    
    [findNameBtn bk_addEventHandler:^(id sender) {
        
        PedestrianFindLoginNameVC *findNameVC = [PedestrianFindLoginNameVC new];
        
        [self.navigationController pushViewController:findNameVC animated:YES];
        
    } forControlEvents:UIControlEventTouchUpInside];
    
    [self.bgSV addSubview:findNameBtn];
    [findNameBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(loginBtn.mas_bottom).offset(10);
        make.left.equalTo(@15);
        
    }];
    
    //找回密码
    UIButton *findPwdBtn = [UIButton buttonWithTitle:@"找回密码" titleColor:kTextColor2 backgroundColor:kClearColor titleFont:14.0];
    
    [findPwdBtn bk_addEventHandler:^(id sender) {
        
        PedestrianFindPwdVC *findPwdVC = [PedestrianFindPwdVC new];
        
        [self.navigationController pushViewController:findPwdVC animated:YES];
        
    } forControlEvents:UIControlEventTouchUpInside];
    
    [self.bgSV addSubview:findPwdBtn];
    [findPwdBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(loginBtn.mas_bottom).offset(10);
        make.right.equalTo(self.view.mas_right).offset(-15);
        
    }];
}

#pragma mark - Events
- (void)goLogin {
    //chenshan2819
//    self.nameTF.text = @"lixianjun_6666";
//    self.pwdTF.text = @"q1i1a1n1";
//
    if (![self.nameTF.text valid]) {
        
        [TLAlert alertWithInfo:@"请输入用户名"];
        
        return;
    }
    
    if (![self.pwdTF.text valid]) {
        
        [TLAlert alertWithInfo:@"请输入密码"];
        return;
    }
    
    if (![self.verifyTF.text valid]) {
        
        [TLAlert alertWithInfo:@"请输入验证码"];
        
        return;
    }
    
    [self.view endEditing:YES];

    //时间戳
    NSString *timeStamp = [NSString getTimeStamp];
    
    ZYNetworking *http = [ZYNetworking new];
    
    http.showView = self.view;
    http.url = kAppendUrl(@"login.do");
    http.parameters[@"method"] = @"login";
    http.parameters[@"date"] = timeStamp;
    http.parameters[@"loginname"] = self.nameTF.text;
    http.parameters[@"password"] = self.pwdTF.text;
    http.parameters[@"_@IMGRC@_"] = self.verifyTF.text;
    
    //Referer
    [http setHeaderWithValue:@"https://ipcrs.pbccrc.org.cn/login.do" headerField:@"Referer"];
    
    [http postWithSuccess:^(NSString *encoding, id responseObject) {

        [self loginWithEncoding:encoding responseObject:responseObject];
        
    } failure:^(NSError *error) {

    }];
    
}

- (void)loginWithEncoding:(NSString *)encoding responseObject:(id)responseObject {
    
    NSString *htmlStr = [NSString convertHtmlWithEncoding:encoding data:responseObject];
    
    NSLog(@"htmlStr = %@", htmlStr);
    
    TFHpple *hpple = [[TFHpple alloc] initWithHTMLData:responseObject encoding:encoding];
    //验证登录名是否正确
    NSArray *spanArr = [hpple searchWithXPathQuery:@"//span"];
    
    NSString *loginPrompt = @"";
    NSString *verifyPrompt = @"";
    
    for (TFHppleElement *element in spanArr) {
        
        if ([[element objectForKey:@"id"] isEqualToString:@"_error_field_"]) {
            //过滤">|\n|\r|\t"符号
            loginPrompt = [element.content regularExpressionWithPattern:@">|\n|\r|\t| "];
        }
        
        if ([[element objectForKey:@"id"] isEqualToString:@"_@MSG@_"]) {
            //过滤">|\n|\r|\t"符号
            verifyPrompt = [element.content regularExpressionWithPattern:@">|\n|\r|\t| "];
        }
    }
    NSArray *titleArr = [hpple searchWithXPathQuery:@"//title"];
    NSString *title = @"";
    
    for (TFHppleElement *element in titleArr) {
        
        title = element.content;
    }
    
    //先判断验证码再判断登录名和密码,每次点击登录失败就刷新验证码
    
    if ([verifyPrompt valid]) {
        
        [TLAlert alertWithInfo:verifyPrompt];
        //刷新验证码
        [self requestImgVerify];
        
        return ;
    }
    
    if ([loginPrompt valid]) {
        
        [TLAlert alertWithInfo:loginPrompt];
        //刷新验证码
        [self requestImgVerify];
        
        return ;
    }
    
    if (![title valid]) {
        
        [TLAlert alertWithInfo:@"系统繁忙, 请稍后再试"];
        //刷新验证码
        [self requestImgVerify];
    }
    //请求欢迎界面
    [self requestWelcomePage];
}

- (void)changeVerify {
    
    [self requestImgVerify];
}

#pragma mark - Data
- (void)requestImgVerify {
    //时间戳
    NSString *timeStamp = [NSString getTimeStamp];
    
    ZYNetworking *http = [ZYNetworking new];
    
    if (!_isFirst) {
        
        http.showView = self.view;
    }
    http.parameters[@"a"] = timeStamp;
    //Referer
    [http setHeaderWithValue:@"https://ipcrs.pbccrc.org.cn/page/login/loginreg.jsp" headerField:@"Referer"];
    
    [http GET:kAppendUrl(@"imgrc.do") success:^(NSString *encoding, id responseObject) {
        
        [self getImgWithEncoding:encoding responseObject:responseObject];
        
    } failure:^(NSError *error) {
        
        
    }];
}

- (void)getImgWithEncoding:(NSString *)encoding responseObject:(id)responseObject {
    
    if (_isFirst) {
        
        UIImage *image = [UIImage imageWithData:responseObject];
        
        CGFloat y = (50 - image.size.height)/2.0;
        
        _verifyIV.image = image;
        _verifyIV.frame = CGRectMake(0, y, image.size.width, image.size.height);
        
        return ;
    }
    
    _isFirst = YES;
    
    [self requestImgVerify];
}

//请求欢迎界面
- (void)requestWelcomePage {
    
    ZYNetworking *http = [ZYNetworking new];
    
    //Accept
    [http setHeaderWithValue:@"text/html, application/xhtml+xml, application/xml, */*" headerField:@"Accept"];
    //Cache-Control
    [http setHeaderWithValue:@"max-age=0" headerField:@"Cache-Control"];
    //Accept-Language
    [http setHeaderWithValue:@"zh-CN,zh;q=0.8,zh-TW;q=0.7,zh-HK;q=0.5,en-US;q=0.3,en;q=0.2" headerField:@"Accept-Language"];
    //Referer
    [http setHeaderWithValue:@"https://ipcrs.pbccrc.org.cn/login.do" headerField:@"Referer"];
    //Upgrade-Insecure-Requests
    [http setHeaderWithValue:@"1" headerField:@"Upgrade-Insecure-Requests"];
    
    [http GET:kAppendUrl(@"welcome.do") success:^(NSString *encoding, id responseObject) {
        
        NSString *htmlStr = [NSString convertHtmlWithEncoding:encoding data:responseObject];
        
        NSLog(@"htmlStr = %@", htmlStr);
        
        TFHpple *hpple = [[TFHpple alloc] initWithHTMLData:responseObject encoding:encoding];
        //验证登录名是否正确
        NSArray *dataArr = [hpple searchWithXPathQuery:@"//p"];
        
        NSString *str1 = @"";
        NSString *str2 = @"";
        
        for (TFHppleElement *element in dataArr) {
            
            if ([element.content containsString:@"欢迎登录个人信用信息服务平台"]) {
                
                str1 = element.content;
            }
            
            if ([element.content containsString:@"上次访问时间"]) {
                
                str2 = element.content;
            }
        }
        //如果返回的html含有欢迎登录个人信用信息服务平台或者上次访问时间，说明登录成功
        if ([str1 containsString:@"欢迎登录个人信用信息服务平台"] || [str2 containsString:@"上次访问时间"]) {
            
            [TLAlert alertWithSucces:@"登录成功"];
            //查看报告
            [self requestReport];
        }
        
    } failure:^(NSError *error) {
        
        
    }];
}
/**
 查看报告
 */
- (void)requestReport {
    
    ZYNetworking *http = [ZYNetworking new];
    
    http.showView = self.view;
    http.parameters[@"method"] = @"queryReport";
    //Accept
    [http setHeaderWithValue:@"text/html, application/xhtml+xml, application/xml, */*" headerField:@"Accept"];
    //Accept-Language
    [http setHeaderWithValue:@"zh-CN,zh;q=0.8,zh-TW;q=0.7,zh-HK;q=0.5,en-US;q=0.3,en;q=0.2" headerField:@"Accept-Language"];
    //Referer
    [http setHeaderWithValue:@"https://ipcrs.pbccrc.org.cn/menu.do" headerField:@"Referer"];
    //Upgrade-Insecure-Requests
    [http setHeaderWithValue:@"1" headerField:@"Upgrade-Insecure-Requests"];
    
    [http GET:kAppendUrl(@"reportAction.do") success:^(NSString *encoding, id responseObject) {
        
        [TLProgressHUD dismiss];
        
        NSString *htmlStr = [NSString convertHtmlWithEncoding:encoding data:responseObject];
        
        NSLog(@"htmlStr = %@", htmlStr);
        
        TFHpple *hpple = [[TFHpple alloc] initWithHTMLData:responseObject encoding:encoding];
        //验证登录名是否正确
        NSArray *dataArr = [hpple searchWithXPathQuery:@"//li"];
        
        NSString *disabledStr = @"";
        
        for (TFHppleElement *element in dataArr) {
            
            if ([element.content containsString:@"个人信用报告"]) {
                
                for (TFHppleElement *subElement in element.children) {
                    
                    if ([subElement.tagName isEqualToString:@"input"]) {
                        
                        //disabled
                        NSDictionary *attributes = subElement.attributes;
                        
                        disabledStr = attributes[@"disabled"] ? attributes[@"disabled"]: @"";
                    }
                }
            }
        }
        
        //如果disabledStr不为空，说明用户没有报告
        if ([disabledStr valid]) {
            
            NoReportVC *noReportVC = [NoReportVC new];
            
            [self.navigationController pushViewController:noReportVC animated:YES];
            
        } else {
            
            PedestrianVerifyVC *verifyVC = [PedestrianVerifyVC new];
            
            [self.navigationController pushViewController:verifyVC animated:YES];
        }
        
    } failure:^(NSError *error) {
        
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
