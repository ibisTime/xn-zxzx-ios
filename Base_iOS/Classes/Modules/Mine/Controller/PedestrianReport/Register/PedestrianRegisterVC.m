//
//  PedestrianRegisterVC.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/1/10.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "PedestrianRegisterVC.h"
#import "CoinHeader.h"
#import "AppConfig.h"
#import "NSString+Date.h"
#import "NSString+Check.h"
#import "UIBarButtonItem+convience.h"
#import "UIButton+EnLargeEdge.h"
#import "TLProgressHUD.h"

#import "AccountTf.h"
#import <TFHpple.h>

#import "WebVC.h"
#import "PedestrianCommitRegisterVC.h"

@interface PedestrianRegisterVC ()

//用户名
@property (nonatomic,strong) TLTextField *nameTF;
//证件类型
@property (nonatomic,strong) TLTextField *certTypeTF;
//证件号码
@property (nonatomic, strong) TLTextField *certNoTF;
//验证码
@property (nonatomic, strong) TLTextField *verifyTF;
//
@property (nonatomic, copy) NSString *verifyCode;
//验证码图片
@property (nonatomic, strong) UIImageView *verifyIV;
//同意按钮
@property (nonatomic, strong) UIButton *checkBtn;
//
@property (nonatomic, assign) BOOL isFirst;


@end

@implementation PedestrianRegisterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"填写身份信息";
    //注册初始化
    [self getToken];
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
    
    //姓名
    TLTextField *nameTF = [[TLTextField alloc] initWithFrame:CGRectMake(0, 0, w, h) leftTitle:@"姓名:" titleWidth:leftW placeholder:@"请输入登录名"];
    
    [bgView addSubview:nameTF];
    self.nameTF = nameTF;
    
    //证件类型
    TLTextField *certTypeTF = [[TLTextField alloc] initWithFrame:CGRectMake(0, nameTF.yy+lineHeight, w, h) leftTitle:@"证件类型:" titleWidth:leftW placeholder:@""];
    
    certTypeTF.text = @"身份证";
    [bgView addSubview:certTypeTF];
    self.certTypeTF = certTypeTF;
    
    //证件号码
    TLTextField *certNoTF = [[TLTextField alloc] initWithFrame:CGRectMake(0, certTypeTF.yy+lineHeight, w, h) leftTitle:@"证件号码:" titleWidth:leftW placeholder:@"请输入证件号码"];
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
    
    //选择按钮
    UIButton *checkBtn = [UIButton buttonWithImageName:@"不打勾" selectedImageName:@"打勾"];
    
    checkBtn.selected = YES;
    
    [checkBtn addTarget:self action:@selector(clickSelect:) forControlEvents:UIControlEventTouchUpInside];
    
    [checkBtn setEnlargeEdgeWithTop:0 right:100 bottom:0 left:10];
    
    [self.view addSubview:checkBtn];
    [checkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(bgView.mas_left).offset(15);
        make.top.equalTo(bgView.mas_bottom).offset(10);
    }];
    
    self.checkBtn = checkBtn;
    
    NSString *text = @"我已阅读并同意";
    
    //text
    UILabel *textLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor font:12];
    
    textLbl.text = text;
    
    textLbl.userInteractionEnabled = YES;
    
    [self.view addSubview:textLbl];
    [textLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(checkBtn.mas_right).offset(5);
        make.centerY.equalTo(checkBtn.mas_centerY);
        
    }];
    
    UIButton *protocolBtn = [UIButton buttonWithTitle:@"《服务协议》" titleColor:kAppCustomMainColor backgroundColor:kClearColor titleFont:12.0];
    
    [protocolBtn addTarget:self action:@selector(readProtocal) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:protocolBtn];
    [protocolBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(textLbl.mas_right);
        make.centerY.equalTo(checkBtn.mas_centerY);
        
    }];
    
    //下一步
    UIButton *nextBtn = [UIButton buttonWithTitle:@"下一步" titleColor:kWhiteColor backgroundColor:kAppCustomMainColor titleFont:17.0 cornerRadius:5];
    [nextBtn addTarget:self action:@selector(nextSetp) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextBtn];
    [nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@(15));
        make.height.equalTo(@(h - 5));
        make.right.equalTo(@(-15));
        make.top.equalTo(bgView.mas_bottom).offset(28+30);
        
    }];
    
}

#pragma mark - Events
- (void)nextSetp {
    
    if (![self.nameTF.text valid]) {
        
        [TLAlert alertWithInfo:@"请输入姓名"];
        
        return;
    }
    
    if (![self.certNoTF.text valid]) {
        
        [TLAlert alertWithInfo:@"请输入证件号码"];
        return;
    }
    
    if (![self.verifyTF.text valid]) {
        
        [TLAlert alertWithInfo:@"请输入验证码"];
        
        return;
    }
    
    if (!self.checkBtn.selected) {
        
        [TLAlert alertWithInfo:@"请同意《服务协议》"];
        return ;
    }
    
    [self.view endEditing:YES];
    
    ZYNetworking *http = [ZYNetworking new];
    
    http.showView = self.view;
    http.url = kAppendUrl(@"userReg.do");
    http.parameters[@"method"] = @"checkIdentity";
    http.parameters[@"1"] = @"on";
    http.parameters[@"org.apache.struts.taglib.html.TOKEN"] = [TLUser user].tempToken;
    http.parameters[@"userInfoVO.name"] = self.nameTF.text;
    http.parameters[@"userInfoVO.certType"] = @"0";
    http.parameters[@"userInfoVO.certNo"] = self.certNoTF.text;
    http.parameters[@"_@IMGRC@_"] = self.verifyTF.text;
    
    //Referer
    [http setHeaderWithValue:@"https://ipcrs.pbccrc.org.cn/userReg.do?method=initReg" headerField:@"Referer"];
    //Content-Type
    [http setHeaderWithValue:@"application/x-www-form-urlencoded; charset=UTF-8" headerField:@"Content-Type"];
    //Accept
    [http setHeaderWithValue:@"text/html, application/xhtml+xml, application/xml, */*" headerField:@"Accept"];
    //Upgrade-Insecure-Requests
    [http setHeaderWithValue:@"1" headerField:@"Upgrade-Insecure-Requests"];
    
    [http postWithSuccess:^(NSString *encoding, id responseObject) {
        
        [self registerFirstSetpWithEncoding:encoding responseObject:responseObject];
        
    } failure:^(NSError *error) {
        
    }];
    
}

/**
 注册第一步
 @param encoding 服务器返回的编码格式
 @param responseObject 字节流数据
 */
- (void)registerFirstSetpWithEncoding:(NSString *)encoding responseObject:(id)responseObject {
    
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
        
        [TLAlert alertWithInfo:verifyPrompt];
        //刷新验证码
        [self requestImgVerify];
        //刷新Token
        [self getTokenWithEncoding:encoding responseObject:responseObject];
        
        return ;
    }
    
    if ([registerPrompt valid]) {
        
        [TLAlert alertWithInfo:registerPrompt];
        //刷新验证码
        [self requestImgVerify];
        //刷新Token
        [self getTokenWithEncoding:encoding responseObject:responseObject];

        return ;
    }
    
    NSArray *errorArr = [hpple searchWithXPathQuery:@"//div[@class='error']"];
    
    if (errorArr.count > 0) {
        
        [TLAlert alertWithInfo:@"系统繁忙, 请稍后再试"];
        //刷新验证码
        [self requestImgVerify];
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
        //刷新验证码
        [self requestImgVerify];
        //刷新Token
        [self getTokenWithEncoding:encoding responseObject:responseObject];

        return ;
    }
    
    [TLAlert alertWithSucces:@"身份信息填写成功"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //获取Token给第二步用
        [self getTokenWithEncoding:encoding responseObject:responseObject];

        PedestrianCommitRegisterVC *commitVC = [PedestrianCommitRegisterVC new];
        
        [self.navigationController pushViewController:commitVC animated:YES];
    });
    
}

- (void)changeVerify {
    
    [self requestImgVerify];
}

- (void)clickSelect:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    
}

- (void)readProtocal {
    
    
    WebVC *webVC = [WebVC new];
    
    webVC.url = @"https://ipcrs.pbccrc.org.cn/html/servearticle.html";
    webVC.titleStr = @"服务协议";
    
    [self.navigationController pushViewController:webVC animated:YES];
}

#pragma mark - Data
- (void)getToken {
    
    ZYNetworking *http = [ZYNetworking new];
    
    http.parameters[@"method"] = @"initReg";
    
    //Referer
    [http setHeaderWithValue:@"https://ipcrs.pbccrc.org.cn/top1.do" headerField:@"Referer"];
    //Accept
    [http setHeaderWithValue:@"text/html, application/xhtml+xml, application/xml, */*" headerField:@"Accept"];
    //Upgrade-Insecure-Requests
    [http setHeaderWithValue:@"1" headerField:@"Upgrade-Insecure-Requests"];
    
    [http GET:kAppendUrl(@"userReg.do") success:^(NSString *encoding, id responseObject) {
        
        [self getTokenWithEncoding:encoding responseObject:responseObject];
        
    } failure:^(NSError *error) {
        
        
    }];
}

/**
 注册初始化
 @param encoding 服务器返回的编码格式
 @param responseObject 字节流数据
 */
- (void)getTokenWithEncoding:(NSString *)encoding responseObject:(id)responseObject {
    
    NSString *htmlStr = [NSString convertHtmlWithEncoding:encoding data:responseObject];
    
    NSLog(@"htmlStr = %@", htmlStr);
    
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

- (void)requestImgVerify {
    //时间戳
    NSString *timeStamp = [NSString getTimeStamp];
    
    ZYNetworking *http = [ZYNetworking new];
    
    if (!_isFirst) {
        
        http.showView = self.view;
    }
    NSString *url = [NSString stringWithFormat:@"%@?%@", kAppendUrl(@"imgrc.do"), timeStamp];
    //Referer
    [http setHeaderWithValue:@"https://ipcrs.pbccrc.org.cn/userReg.do?method=initReg" headerField:@"Referer"];
    //Accept
    [http setHeaderWithValue:@"*/*" headerField:@"Accept"];
    
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
