//
//  PedestrianVerifySuccessVC.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/1/17.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "PedestrianVerifySuccessVC.h"

#import "CoinHeader.h"
#import "AppConfig.h"
#import "UIControl+Block.h"
#import "NSString+Check.h"
#import "TLProgressHUD.h"

#import <TFHpple.h>

@interface PedestrianVerifySuccessVC ()

//提示语
@property (nonatomic, strong) UILabel *promptLbl;
//按钮
@property (nonatomic, strong) UIButton *okBtn;

@end

@implementation PedestrianVerifySuccessVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"完成验证";
    
    [self initSubviews];
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
    promptLbl.text = @"1.您的信用信息查询请求已提交，请在24小时后访问平台获取结果。\n2.为保障您的信息安全，您申请的信用信息将于7日后自动清理，请及时获取查询结果。";
    
    [self.view addSubview:promptLbl];
    [promptLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(iconIV.mas_bottom).offset(30);
        make.left.equalTo(@15);
        make.right.equalTo(@(-15));
        
    }];
    
    self.promptLbl = promptLbl;
    
    //按钮
    UIButton *okBtn = [UIButton buttonWithTitle:@"我知道了" titleColor:kWhiteColor backgroundColor:kAppCustomMainColor titleFont:16.0 cornerRadius:5];
    
    [okBtn bk_addEventHandler:^(id sender) {
        
        [self.navigationController popToRootViewControllerAnimated:YES];
        
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
