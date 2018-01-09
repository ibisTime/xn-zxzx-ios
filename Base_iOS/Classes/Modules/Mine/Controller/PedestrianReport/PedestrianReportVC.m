//
//  PedestrianReportVC.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/1/8.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "PedestrianReportVC.h"

#import "CoinHeader.h"
#import "AppConfig.h"
#import "NSString+Date.h"
#import "NSString+Check.h"
#import "AccountTf.h"

@interface PedestrianReportVC ()
//用户名
@property (nonatomic,strong) AccountTf *nameTF;
//密码
@property (nonatomic,strong) AccountTf *pwdTF;
//验证码
@property (nonatomic, strong) AccountTf *verifyTF;
//
@property (nonatomic, copy) NSString *verifyCode;
//验证码
@property (nonatomic, strong) UIImageView *verifyIV;

@end

@implementation PedestrianReportVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"中国人民银行征信中心登录";
    
    [AppConfig config].cookie = nil;
    
    //获取图片验证码
    [self requestImgVerify];
    //登录、注册
    [self initSubviews];
    
}

#pragma mark - Init
- (void)initSubviews {
    
    self.view.backgroundColor = kBackgroundColor;
    
    CGFloat w = kScreenWidth;
    CGFloat h = ACCOUNT_HEIGHT;
    NSInteger count = 3;
    
    UIView *bgView = [[UIView alloc] init];
    
    bgView.backgroundColor = kWhiteColor;
    
    [self.view addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(@(10));
        make.left.equalTo(@0);
        make.height.equalTo(@(count*h+1));
        make.width.equalTo(@(w));
        
    }];
    
    //账号
    AccountTf *nameTF = [[AccountTf alloc] initWithFrame:CGRectMake(0, 0, w, h)];
    nameTF.leftIconView.image = [UIImage imageNamed:@"用户名"];
    nameTF.placeHolder = @"请输入登录名";
    nameTF.keyboardType = UIKeyboardTypeNumberPad;

    [bgView addSubview:nameTF];
    self.nameTF = nameTF;
    
    //密码
    AccountTf *pwdTF = [[AccountTf alloc] initWithFrame:CGRectMake(0, nameTF.yy + 1, w, h)];
    pwdTF.secureTextEntry = YES;
    pwdTF.leftIconView.image = [UIImage imageNamed:@"密码"];
    pwdTF.placeHolder = @"请输入密码";
    [bgView addSubview:pwdTF];
    self.pwdTF = pwdTF;
    
    //验证码
    _verifyIV = [[UIImageView alloc] init];
    
    [self.view addSubview:_verifyIV];
    [_verifyIV mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(@0);
    }];
    
    AccountTf *verifyTF = [[AccountTf alloc] initWithFrame:CGRectMake(0, nameTF.yy + 1, w, h)];
    verifyTF.leftIconView.image = [UIImage imageNamed:@"验证码"];
    verifyTF.placeHolder = @"请输入验证码";
    [bgView addSubview:verifyTF];
    self.verifyTF = verifyTF;
    
    for (int i = 0; i < count; i++) {
        
        UIView *line = [[UIView alloc] init];
        
        line.backgroundColor = kLineColor;
        
        [bgView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(@0);
            make.right.equalTo(@0);
            make.height.equalTo(@0.5);
            make.top.equalTo(@((i+1)*h));
            
        }];
    }
    //登录
    UIButton *loginBtn = [UIButton buttonWithTitle:@"登录" titleColor:kWhiteColor backgroundColor:kAppCustomMainColor titleFont:17.0 cornerRadius:5];
    [loginBtn addTarget:self action:@selector(goLogin) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@(15));
        make.height.equalTo(@(h - 5));
        make.right.equalTo(@(-15));
        make.top.equalTo(bgView.mas_bottom).offset(28);
        
    }];
    
    //换一个
    UIButton *changeVerifyBtn = [UIButton buttonWithTitle:@"看不清, 换一个" titleColor:kTextColor2 backgroundColor:kClearColor titleFont:14.0];
    
    changeVerifyBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [changeVerifyBtn addTarget:self action:@selector(changeVerify) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:changeVerifyBtn];
    
    [changeVerifyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(loginBtn.mas_right);
        make.top.equalTo(loginBtn.mas_bottom).offset(18);
        
    }];
    
}

#pragma mark - Events
- (void)goLogin {
    
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
}

- (void)changeVerify {
    
    [self requestImgVerify];
}

#pragma mark - Data
- (void)requestImgVerify {
    //时间戳
    NSString *timeStamp = [NSString getTimeStamp];
    
    ZYNetworking *http = [ZYNetworking new];
    
//    NSString *url = [NSString stringWithFormat:@"imgrc.do?a=%@", timeStamp];
    
    http.parameters[@"a"] = timeStamp;
    //Accept
    [http setHeaderWithValue:@"image/gif, image/jpeg, image/pjpeg, application/x-ms-application, application/xaml+xml, application/x-ms-xbap, */*" headerField:@"Accept"];
    //Referer
    [http setHeaderWithValue:@"https://ipcrs.pbccrc.org.cn/page/login/loginreg.jsp" headerField:@"Referer"];
    
    [http GET:kAppendUrl(@"imgrc.do") success:^(NSString *msg, id data) {
        
        UIImage *image = [UIImage imageWithData:data];
        
        _verifyIV.image = image;
        
    } failure:^(NSError *error) {
        
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
