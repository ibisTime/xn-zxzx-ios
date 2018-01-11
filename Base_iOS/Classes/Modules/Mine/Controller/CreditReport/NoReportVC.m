//
//  NoReportVC.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/1/10.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "NoReportVC.h"

#import "UIControl+Block.h"

@interface NoReportVC ()

@end

@implementation NoReportVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"人行报告";
    [self initSubviews];
}

#pragma mark - Init
- (void)initSubviews {
    
    CGFloat iconW = kWidth(100);
    //图标
    UIImageView *iconIV = [[UIImageView alloc] initWithImage:kImage(@"持证自拍")];
    
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
    promptLbl.text = @"您目前没有可供查看的报告, 请进行认证后再进行查看";
    
    [self.view addSubview:promptLbl];
    [promptLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(iconIV.mas_bottom).offset(30);
        make.left.equalTo(@15);
        make.right.equalTo(@(-15));
        
    }];
    //按钮
    UIButton *okBtn = [UIButton buttonWithTitle:@"我知道了" titleColor:kWhiteColor backgroundColor:kAppCustomMainColor titleFont:16.0 cornerRadius:5];
    
    [okBtn bk_addEventHandler:^(id sender) {
        
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    } forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:okBtn];
    [okBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(promptLbl.mas_bottom).offset(30);
        make.left.equalTo(@15);
        make.right.equalTo(@(-15));
        make.height.equalTo(@45);
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
