//
//  PedestrianFindPwdVC.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/1/15.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "PedestrianFindPwdVC.h"

#import "NSString+Date.h"
#import "NSString+Check.h"
#import "TLProgressHUD.h"
#import "UILabel+Extension.h"
#import "PedestrianResetPwdVC.h"

@interface PedestrianFindPwdVC ()
//登录名
@property (nonatomic, strong) TLTextField *loginNameTF;
//真实姓名
@property (nonatomic,strong) TLTextField *realNameTF;
////证件类型
//@property (nonatomic,strong) TLTextField *certTypeTF;
//证件号码
@property (nonatomic, strong) TLTextField *certNoTF;
//验证码
@property (nonatomic, strong) TLTextField *verifyTF;
//验证码图片
@property (nonatomic, strong) UIImageView *verifyIV;
//同意按钮
@property (nonatomic, strong) UIButton *checkBtn;
//
@property (nonatomic, assign) BOOL isFirst;

@end

@implementation PedestrianFindPwdVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"找回密码";
    
    //获取图片验证码
    [self requestImgVerify];
    //
    [self initSubviews];
    
}

#pragma mark - Init
- (void)initSubviews {
    
    self.view.backgroundColor = kBackgroundColor;
    
    CGFloat w = kScreenWidth;
    CGFloat h = ACCOUNT_HEIGHT;
    CGFloat leftW = 90;
    
    NSInteger count = 4;
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
    
    //登录名
    TLTextField *loginNameTF = [[TLTextField alloc] initWithFrame:CGRectMake(0, 0, w, h) leftTitle:@"登录名:" titleWidth:leftW placeholder:@"请输入登录名"];
    
    [bgView addSubview:loginNameTF];
    self.loginNameTF = loginNameTF;
    
    //姓名
    TLTextField *realNameTF = [[TLTextField alloc] initWithFrame:CGRectMake(0, loginNameTF.yy+lineHeight, w, h) leftTitle:@"姓名:" titleWidth:leftW placeholder:@"请输入真实姓名"];
    
    [bgView addSubview:realNameTF];
    self.realNameTF = realNameTF;
    
//    //证件类型
//    TLTextField *certTypeTF = [[TLTextField alloc] initWithFrame:CGRectMake(0, realNameTF.yy+lineHeight, w, h) leftTitle:@"证件类型:" titleWidth:leftW placeholder:@""];
//
//    certTypeTF.text = @"身份证";
//    [bgView addSubview:certTypeTF];
//    self.certTypeTF = certTypeTF;
    
    //身份证号码
    TLTextField *certNoTF = [[TLTextField alloc] initWithFrame:CGRectMake(0, realNameTF.yy+lineHeight, w, h) leftTitle:@"身份证号:" titleWidth:leftW placeholder:@"请输入身份证号码"];
    certNoTF.keyboardType = UIKeyboardTypeASCIICapable;
    
    [bgView addSubview:certNoTF];
    self.certNoTF = certNoTF;
    
    //验证码
    TLTextField *verifyTF = [[TLTextField alloc] initWithFrame:CGRectMake(0, certNoTF.yy+lineHeight, w-115, h) leftTitle:@"验证码:" titleWidth:leftW placeholder:@"请输入验证码"];
    
    verifyTF.keyboardType = UIKeyboardTypeASCIICapable;
    
    [bgView addSubview:verifyTF];
    self.verifyTF = verifyTF;
    
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(verifyTF.xx, certNoTF.yy+lineHeight, 100+15, h)];
    
    [bgView addSubview:rightView];
    
    _verifyIV = [[UIImageView alloc] init];
    
    [rightView addSubview:_verifyIV];
    
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
    
    //换一个
    UIButton *changeVerifyBtn = [UIButton buttonWithTitle:@"看不清, 换一个" titleColor:kTextColor2 backgroundColor:kClearColor titleFont:14.0];
    
    changeVerifyBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [changeVerifyBtn addTarget:self action:@selector(changeVerify) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:changeVerifyBtn];
    
    [changeVerifyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(bgView.mas_right).offset(-15);
        make.top.equalTo(bgView.mas_bottom).offset(10);
        
    }];
    
    //下一步
    UIButton *nextBtn = [UIButton buttonWithTitle:@"下一步" titleColor:kWhiteColor backgroundColor:kAppCustomMainColor titleFont:17.0 cornerRadius:5];
    [nextBtn addTarget:self action:@selector(findPwd) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextBtn];
    [nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@(15));
        make.height.equalTo(@(h - 5));
        make.right.equalTo(@(-15));
        make.top.equalTo(bgView.mas_bottom).offset(28+30);
        
    }];
    //提示
    UILabel *promptLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor2 font:14.0];
    
    promptLbl.numberOfLines = 0;
    
    [promptLbl labelWithTextString:@"如果您的安全等级过高，那么只能登录到中国人民银行征信中心进行修改。\n征信中心地址：https://ipcrs.pbccrc.org.cn/" lineSpace:5];
    [self.view addSubview:promptLbl];
    [promptLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(nextBtn.mas_bottom).offset(15);
        make.left.equalTo(@15);
        make.right.equalTo(@(-15));
        
    }];
}

#pragma mark - Events

/**
 找回登录名
 */
- (void)findPwd {
    
    if (![self.loginNameTF.text valid]) {
        
        [TLAlert alertWithInfo:@"请输入登录名"];
        return;
    }
    
    if (![self.realNameTF.text valid]) {
        
        [TLAlert alertWithInfo:@"请输入姓名"];
        return;
    }
    
    if (![self.certNoTF.text valid]) {
        
        [TLAlert alertWithInfo:@"请输入身份证号码"];
        return;
    }
    
    if (![self.verifyTF.text valid]) {
        
        [TLAlert alertWithInfo:@"请输入验证码"];
        return;
    }
    
    [self.view endEditing:YES];
    
    ZYNetworking *http = [ZYNetworking new];
    
    http.showView = self.view;
    http.url = kAppendUrl(@"resetPassword.do");
    http.parameters[@"method"] = @"checkLoginName";
//    http.parameters[@"org.apache.struts.taglib.html.TOKEN"] = [TLUser user].tempToken;
    http.parameters[@"loginname"] = self.loginNameTF.text;
    http.parameters[@"name"] = self.realNameTF.text;
    http.parameters[@"certType"] = @"0";
    http.parameters[@"certNo"] = self.certNoTF.text;
    http.parameters[@"_@IMGRC@_"] = self.verifyTF.text;
    
    //Referer
    [http setHeaderWithValue:@"https://ipcrs.pbccrc.org.cn/resetPassword.do" headerField:@"Referer"];
    //Content-Type
    [http setHeaderWithValue:@"application/x-www-form-urlencoded; charset=UTF-8" headerField:@"Content-Type"];
    //Accept
    [http setHeaderWithValue:@"text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8" headerField:@"Accept"];
    //Upgrade-Insecure-Requests
    [http setHeaderWithValue:@"1" headerField:@"Upgrade-Insecure-Requests"];
    //Accept-Language
    [http setHeaderWithValue:@"zh-CN,zh;q=0.8,zh-TW;q=0.7,zh-HK;q=0.5,en-US;q=0.3,en;q=0.2" headerField:@"Accept-Language"];
    
    [http postWithSuccess:^(NSString *encoding, id responseObject) {
        
        [self findLoginNameWithEncoding:encoding responseObject:responseObject];
        
    } failure:^(NSError *error) {
        
    }];
    
}

/**
 找回登录名
 @param encoding 服务器返回的编码格式
 @param responseObject 字节流数据
 */
- (void)findLoginNameWithEncoding:(NSString *)encoding responseObject:(id)responseObject {
    
    NSString *htmlStr = [NSString convertHtmlWithEncoding:encoding data:responseObject];
    
    NSLog(@"htmlStr = %@", htmlStr);
    
    TFHpple *hpple = [[TFHpple alloc] initWithHTMLData:responseObject encoding:encoding];
    
    //验证登录名是否正确
    NSArray *spanArr = [hpple searchWithXPathQuery:@"//span"];
    
    NSString *registerPrompt = @"";
    NSString *verifyPrompt = @"";
    
    for (TFHppleElement *element in spanArr) {
        
        if ([[element objectForKey:@"id"] isEqualToString:@"_error_field_"]) {
            //过滤">|\n|\r|\t"符号
            registerPrompt = [element.content regularExpressionWithPattern:@">|\n|\r|\t| "];
        }
        
        if ([[element objectForKey:@"id"] isEqualToString:@"_@MSG@_"]) {
            //过滤">|\n|\r|\t"符号
            verifyPrompt = [element.content regularExpressionWithPattern:@">|\n|\r|\t| "];
        }
    }
    
    //先判断验证码再判断姓名和证件号码,每次点击下一步失败就刷新验证码
    
    if ([verifyPrompt valid]) {
        
        [self errorActionWithPrompt:verifyPrompt encoding:encoding responseObject:responseObject];
        
        return ;
    }
    
    if ([registerPrompt valid]) {
        
        [self errorActionWithPrompt:registerPrompt encoding:encoding responseObject:responseObject];
        
        return ;
    }
    
    PedestrianResetPwdVC *resetPwdVC = [PedestrianResetPwdVC new];
    
    [self.navigationController pushViewController:resetPwdVC animated:YES];
    
    
}

/**
 系统报错后的操作
 */
- (void)errorActionWithPrompt:(NSString *)prompt encoding:(NSString *)encoding responseObject:(id)responseObject {
    
    [TLAlert alertWithInfo:prompt];
    //刷新验证码
    [self requestImgVerify];

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
    NSString *url = [NSString stringWithFormat:@"%@?%@", kAppendUrl(@"imgrc.do"), timeStamp];
    //Referer
    [http setHeaderWithValue:@"https://ipcrs.pbccrc.org.cn/resetPassword.do?method=init" headerField:@"Referer"];
    //Accept
    [http setHeaderWithValue:@"*/*" headerField:@"Accept"];
    //Accept-Language
    [http setHeaderWithValue:@"zh-CN,zh;q=0.8,zh-TW;q=0.7,zh-HK;q=0.5,en-US;q=0.3,en;q=0.2" headerField:@"Accept-Language"];
    
    [http GET:url success:^(NSString *encoding, id responseObject) {
        
        _isFirst = YES;
        
        UIImage *image = [UIImage imageWithData:responseObject];
        
        CGFloat y = (50 - image.size.height)/2.0;
        
        _verifyIV.image = image;
        _verifyIV.frame = CGRectMake(0, y, image.size.width, image.size.height);
        
    } failure:^(NSError *error) {
        
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
