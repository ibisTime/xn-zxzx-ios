//
//  PedestrianRegisterSuccessVC.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/1/11.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "PedestrianRegisterSuccessVC.h"

#import "UIControl+Block.h"
#import "PedestrianLoginVC.h"

@interface PedestrianRegisterSuccessVC ()

@end

@implementation PedestrianRegisterSuccessVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"完成注册";
    
    [self initSubviews];
}

#pragma mark - Init
- (void)initSubviews {
    
    //text
    UILabel *promptLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor font:15.0];
    
    promptLbl.numberOfLines = 0;
    promptLbl.text = @"恭喜您,您已经注册成功";
    promptLbl.textAlignment = NSTextAlignmentCenter;
    
    [self.view addSubview:promptLbl];
    [promptLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.view.mas_top).offset(30);
        make.left.equalTo(@15);
        make.right.equalTo(@(-15));
        
    }];
    //按钮
    UIButton *loginBtn = [UIButton buttonWithTitle:@"立即登录" titleColor:kWhiteColor backgroundColor:kAppCustomMainColor titleFont:16.0 cornerRadius:5];
    
    [loginBtn bk_addEventHandler:^(id sender) {
        
        PedestrianLoginVC *loginVC = [PedestrianLoginVC new];
        
        [self.navigationController pushViewController:loginVC animated:YES];
        
    } forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:loginBtn];
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
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
