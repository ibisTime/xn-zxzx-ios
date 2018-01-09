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
#import "UIBarButtonItem+convience.h"

#import "AccountTf.h"
#import <TFHpple.h>
#import <ONOXMLDocument.h>
#import <iconv.h>

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
    //注册
    
    [UIBarButtonItem addRightItemWithTitle:@"注册" titleColor:kWhiteColor frame:CGRectMake(0, 0, 40, 44) vc:self action:@selector(goRegister)];
    
    CGFloat w = kScreenWidth;
    CGFloat h = ACCOUNT_HEIGHT;
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
    
    //账号
    AccountTf *nameTF = [[AccountTf alloc] initWithFrame:CGRectMake(0, 0, w, h)];
    nameTF.leftIconView.image = [UIImage imageNamed:@"用户名"];
    nameTF.placeHolder = @"请输入登录名";

    [bgView addSubview:nameTF];
    self.nameTF = nameTF;
    
    //密码
    AccountTf *pwdTF = [[AccountTf alloc] initWithFrame:CGRectMake(0, nameTF.yy+lineHeight, w, h)];
    pwdTF.secureTextEntry = YES;
    pwdTF.leftIconView.image = [UIImage imageNamed:@"密码"];
    pwdTF.placeHolder = @"请输入密码";
    [bgView addSubview:pwdTF];
    self.pwdTF = pwdTF;
    //验证码
    AccountTf *verifyTF = [[AccountTf alloc] initWithFrame:CGRectMake(0, pwdTF.yy+lineHeight, w-115, h)];
    verifyTF.leftIconView.image = [UIImage imageNamed:@"验证码"];
    verifyTF.placeHolder = @"请输入验证码";
    [bgView addSubview:verifyTF];
    self.verifyTF = verifyTF;
    
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(verifyTF.xx, pwdTF.yy+lineHeight, 100+15, h)];

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
    
    //登录
    UIButton *loginBtn = [UIButton buttonWithTitle:@"登录" titleColor:kWhiteColor backgroundColor:kAppCustomMainColor titleFont:17.0 cornerRadius:5];
    [loginBtn addTarget:self action:@selector(goLogin) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@(15));
        make.height.equalTo(@(h - 5));
        make.right.equalTo(@(-15));
        make.top.equalTo(bgView.mas_bottom).offset(28+30);
        
    }];
    
}

static NSData *ALUTF8NSData(NSData *data) {
    if (!data) return nil;
    const char *iconv_utf8_encoding = "UTF-8";
    iconv_t cd = iconv_open(iconv_utf8_encoding, iconv_utf8_encoding); // 从utf8转utf8
    int one = 1;
    iconvctl(cd, ICONV_SET_DISCARD_ILSEQ, &one); // 丢弃不正确的字符
    
    size_t inbytesleft, outbytesleft;
    inbytesleft = outbytesleft = data.length;
    char *inbuf  = (char *)data.bytes;
    char *outbuf = malloc(sizeof(char) * data.length);
    char *outptr = outbuf;
    size_t icon = iconv(cd, &inbuf, &inbytesleft, &outptr, &outbytesleft);
    
    if (icon == 0) {
        NSData *result = [NSData dataWithBytes:outbuf length:data.length - outbytesleft];
        iconv_close(cd);
        free(outbuf);
        
        return result;
    }
    return nil;
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
    
    [http GET:kAppendUrl(@"login.do") success:^(NSString *msg, id data) {
        //获取编码格式
        CFStringEncoding cfEncoding = CFStringConvertIANACharSetNameToEncoding((CFStringRef)
                                                                               msg);
        NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(cfEncoding);
        //将NSdata转成NSString
        NSString *htmlStr = [[NSString alloc] initWithData:data encoding:encoding];
        
        if (!htmlStr) {
            
            NSData *data1 = ALUTF8NSData(data);
            
            htmlStr = [[NSString alloc] initWithData:data1 encoding:NSUTF8StringEncoding];
        }
        NSLog(@"htmlStr = %@", htmlStr);
        
    } failure:^(NSError *error) {
        
    }];
    
//    [http postWithSuccess:^(id responseObject) {
//
//        [TLAlert alertWithSucces:@"登录成功"];
//
//        ONOXMLDocument *document = [ONOXMLDocument HTMLDocumentWithData:responseObject error:nil];
//        HTMLMedicine *medicine = [[HTMLMedicine alloc] init];
//        NSString *xpath = @"//body/form/div[@class='wrap']/div[@class='bodyer']/div[@class='mainly']/div[@id='outter']/ol[@id='results']/li[1]/div[@class='result']";
//        [document enumerateElementsWithXPath:xpath usingBlock:^(ONOXMLElement *element, NSUInteger idx, BOOL *stop) {
//            NSLog(@"%@: %@", element.tag, element.attributes);
//
//            for (ONOXMLElement *celement in element.children) {
//
//                //商家和发布厂家
//                if ([celement.tag isEqualToString:@"dl"] && [celement.attributes[@"class"] isEqualToString:@"p-supplier"]) {
//                    NSInteger i = 0;
//                    for (ONOXMLElement *ccelement in celement.children) {
//                        if ([ccelement.tag isEqualToString:@"dd"] && i == 0) {
//                            medicine.brand = [ccelement stringValue];
//                            i++;
//                        }
//                        else if ([ccelement.tag isEqualToString:@"dd"] && i == 1) {
//                            medicine.manufacturer = [[ccelement stringValue] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//                        }
//
//                    }
//                }
//
//                //商品条码、名称、规格型号、描述
//                if ([celement.tag isEqualToString:@"dl"] && [celement.attributes[@"class"] isEqualToString:@"p-info"]) {
//                    NSInteger i = 0;
//                    for (ONOXMLElement *ccelement in celement.children) {
//                        if ([ccelement.tag isEqualToString:@"dd"] && i == 0) {
//                            medicine.code = [ccelement stringValue];
//                            i++;
//                        }
//                        else if ([ccelement.tag isEqualToString:@"dd"] && i == 1) {
//                            medicine.name = [ccelement stringValue];
//                            i++;
//                        }
//                        else if ([ccelement.tag isEqualToString:@"dd"] && i == 2) {
//                            medicine.specificagionmodel = [ccelement stringValue];
//                            i++;
//                        }
//                        else if ([ccelement.tag isEqualToString:@"dd"] && i == 3) {
//                            medicine.descriptions = [ccelement stringValue];
//                        }
//                    }
//                }
//            }
//            NSLog(@"%@",medicine);
//        }];
//
////        TFHpple *hpple = [TFHpple hppleWithHTMLData:responseObject];
////
////        NSArray *dataArr = [hpple searchWithXPathQuery:@"//p"];
////
////        for (TFHppleElement *element in dataArr) {
////
////            if ([[element objectForKey:@"class"] isEqualToString:@"title"]) {
////                NSLog(@"%@\n",element.text);
////
////            }
////        }
////        NSString *htmlStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//
////        NSString *appConnect = [NSString stringWithContentsOfURL:[NSURL URLWithString:urlstring] encoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000) error:nil];
//
//    } failure:^(NSError *error) {
//
//    }];
    
}

- (void)goRegister {
    
    
}

- (void)changeVerify {
    
    [self requestImgVerify];
}

#pragma mark - Data
- (void)requestImgVerify {
    //时间戳
    NSString *timeStamp = [NSString getTimeStamp];
    
    ZYNetworking *http = [ZYNetworking new];
    
    http.showView = self.view;
    http.parameters[@"a"] = timeStamp;
    //Referer
    [http setHeaderWithValue:@"https://ipcrs.pbccrc.org.cn/page/login/loginreg.jsp" headerField:@"Referer"];
    
    [http GET:kAppendUrl(@"imgrc.do") success:^(NSString *msg, id data) {
        
        UIImage *image = [UIImage imageWithData:data];
        
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
