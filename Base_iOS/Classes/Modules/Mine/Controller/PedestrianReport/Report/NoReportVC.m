//
//  NoReportVC.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/1/10.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "NoReportVC.h"

#import "CoinHeader.h"
#import "AppConfig.h"
#import "UIControl+Block.h"
#import "NSString+Check.h"
#import "TLProgressHUD.h"

#import <TFHpple.h>
//M
#import "PedestrianManager.h"
//C
#import "PedestrianQuestionVC.h"
#import "PedestrianSendVerifyVC.h"

@interface NoReportVC ()
//提示语
@property (nonatomic, strong) UILabel *promptLbl;
//按钮
@property (nonatomic, strong) UIButton *okBtn;
//
@property (nonatomic, strong) PedestrianManager *manager;
//是否高等级
@property (nonatomic, assign) BOOL isHighLevel;
//first
@property (nonatomic, assign) BOOL isFirst;

@end

@implementation NoReportVC

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    //申请报告信息，通过这个请求判断是否在认证
    [self applyReportInfo];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"人行报告";
    
    self.manager = [PedestrianManager new];
}

#pragma mark - Init
- (void)initSubviews {
    
    CGFloat iconW = kWidth(100);
    //图标
    UIImageView *iconIV = [[UIImageView alloc] initWithImage:kImage(@"no_report")];
    
    iconIV.layer.cornerRadius = iconW/2.0;
    iconIV.clipsToBounds = YES;
    
    [self.view addSubview:iconIV];
    [iconIV mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(@0);
        make.top.equalTo(@40);
        make.width.height.equalTo(@(iconW));
        
    }];
    
    //text
    UILabel *promptLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor font:15.0];
    
    promptLbl.numberOfLines = 0;
    promptLbl.text = _manager.reportPromptStr;

    [self.view addSubview:promptLbl];
    [promptLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(iconIV.mas_bottom).offset(30);
        make.left.equalTo(@15);
        make.right.equalTo(@(-15));
        
    }];
    
    self.promptLbl = promptLbl;
    
    //按钮
    UIButton *okBtn = [UIButton buttonWithTitle:_manager.reportBtnTitle titleColor:kWhiteColor backgroundColor:kAppCustomMainColor titleFont:16.0 cornerRadius:5];
    
    [okBtn bk_addEventHandler:^(id sender) {

        if ([self.manager.reportStatus isEqualToString:@"1"]) {

            [self.navigationController popToRootViewControllerAnimated:YES];
            
        } else if ([self.manager.reportStatus isEqualToString:@"0"]) {

            //等级低需要回答问题才能查看报告,高等级的用户只需发送验证码
            if (_isHighLevel) {
                
                PedestrianSendVerifyVC *sendVerifyVC = [PedestrianSendVerifyVC new];
                
                [self.navigationController pushViewController:sendVerifyVC animated:YES];
                
            } else {
                
                PedestrianQuestionVC *questionVC = [PedestrianQuestionVC new];
                
                [self.navigationController pushViewController:questionVC animated:YES];
            }
            
        } else {
            
            PedestrianQuestionVC *questionVC = [PedestrianQuestionVC new];
            
            [self.navigationController pushViewController:questionVC animated:YES];
        }

    } forControlEvents:UIControlEventTouchUpInside];
    
    okBtn.frame = CGRectMake(100, 300, 100, 40);
    
    [self.view addSubview:okBtn];
    [okBtn mas_makeConstraints:^(MASConstraintMaker *make) {

        make.top.equalTo(promptLbl.mas_bottom).offset(30);
        make.left.equalTo(@15);
        make.right.equalTo(@(-15));
        make.height.equalTo(@45);

    }];
    
    self.okBtn = okBtn;
}

#pragma mark -  Data
- (void)applyReportInfo {
    
    ZYNetworking *http = [ZYNetworking new];
    
    if (!_isFirst) {
        
        http.showView = self.view;
    }
    http.parameters[@"method"] = @"applicationReport";
    //Accept
    [http setHeaderWithValue:@"text/html,application/xhtml+xml,aplication/xml;q=0.9,*/*;q=0.8" headerField:@"Accept"];
    //Accept-Language
    [http setHeaderWithValue:@"zh-CN,zh;q=0.8,zh-TW;q=0.7,zh-HK;q=0.5,en-US;q=0.3,en;q=0.2" headerField:@"Accept-Language"];
    //Referer
    [http setHeaderWithValue:@"https://ipcrs.pbccrc.org.cn/menu.do" headerField:@"Referer"];
    //Upgrade-Insecure-Requests
    [http setHeaderWithValue:@"1" headerField:@"Upgrade-Insecure-Requests"];
    
    [http GET:kAppendUrl(@"reportAction.do") success:^(NSString *encoding, id responseObject) {
        
        //获取Token
        [self getTokenWithEncoding:encoding responseObject:responseObject];
        
        if (!_isFirst) {
            
            //报告状态
            [self applyReportWithEncoding:encoding responseObject:responseObject];
        }

        _isFirst = YES;

    } failure:^(NSError *error) {
        
        
    }];
}

- (void)applyReportWithEncoding:(NSString *)encoding responseObject:(id)responseObject {
    
    [TLProgressHUD dismiss];
    
    NSString *htmlStr = [NSString convertHtmlWithEncoding:encoding data:responseObject];
    
    NSLog(@"htmlStr = %@", htmlStr);
    
    TFHpple *hpple = [[TFHpple alloc] initWithHTMLData:responseObject encoding:encoding];
    
    //系统错误
    [self systemErrorWithBlock:^{
        
        return ;
        
    } encoding:encoding responseObject:responseObject];
    
    //验证登录名是否正确
    NSArray *dataArr = [hpple searchWithXPathQuery:@"//li"];
    
    NSString *disabledStr = @"";
    NSString *resultStr = @"";
    
    for (TFHppleElement *element in dataArr) {
        
        if ([element.content containsString:@"个人信用报告"]) {
            
            for (TFHppleElement *subElement in element.children) {
                
                if ([subElement.tagName isEqualToString:@"input"]) {
                    
                    //disabled
                    NSDictionary *attributes = subElement.attributes;
                    
                    disabledStr = attributes[@"disabled"] ? attributes[@"disabled"]: @"";
                }
                
                if ([subElement.tagName isEqualToString:@"font"]) {
                    
                    //result
                    resultStr = subElement.text ? subElement.text: @"";
                }
            }
        }
    }
    
    //如果disabledStr不为空，说明用户的报告在申请中
    if ([disabledStr valid]) {
        
        _manager.reportStatus = @"1";
        
    } else {
        //若返回验证未通过代表申请失败，空代表未申请认证
        if ([resultStr containsString:@"验证未通过"]) {
            
            _manager.reportStatus = @"2";
            
        } else {
            
            _manager.reportStatus = @"0";
        }
    }
    
    //判断用户等级, 如果等级过高那就发送验证码
    NSArray *labelArr = [hpple searchWithXPathQuery:@"//label"];
    
    _isHighLevel = YES;
    
    for (TFHppleElement *element in labelArr) {
        
        if ([element.content containsString:@"问题验证"]) {
            
            _isHighLevel = NO;
        }
    }
    
    [self initSubviews];
    
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
    //验证登录名是否正确
    NSArray *dataArr = [hpple searchWithXPathQuery:@"//input[@name='org.apache.struts.taglib.html.TOKEN']"];
    //获取注册流程需要用到的Token
    if (dataArr.count > 0) {
        
        TFHppleElement *element = dataArr[0];
        
        NSDictionary *attributes = element.attributes;
        
        [TLUser user].tempToken = attributes[@"value"];
        
    } else {
        
        [TLAlert alertWithInfo:@"系统繁忙, 请稍后再试"];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
