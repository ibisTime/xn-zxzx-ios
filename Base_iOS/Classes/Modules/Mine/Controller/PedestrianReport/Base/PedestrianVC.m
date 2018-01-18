//
//  PedestrianVC.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/1/12.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "PedestrianVC.h"

#import "UIControl+Block.h"
#import "UIButton+EnLargeEdge.h"
//C
#import "PedestrianRegisterVC.h"
#import "PedestrianLoginVC.h"

@interface PedestrianVC ()

@end

@implementation PedestrianVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"中国人民银行征信中心";
    
    [self initSubviews];
}

#pragma mark - Init
- (void)initSubviews {
    
    BaseWeakSelf;
    self.isBackPreviousPage = YES;

    //
    UILabel *titleLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kAppCustomMainColor font:20];
    
    titleLbl.text = @"个人征信查询";
    
    [self.view addSubview:titleLbl];
    [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(@0);
        make.top.equalTo(@20);
        
    }];
    //query
    UIButton *queryBtn = [UIButton buttonWithTitle:@"首次开通征信查询" titleColor:kWhiteColor backgroundColor:kAppCustomMainColor titleFont:18 cornerRadius:5];
    
    [queryBtn bk_addEventHandler:^(id sender) {
        
        PedestrianRegisterVC *registerVC = [PedestrianRegisterVC new];

        [weakSelf.navigationController pushViewController:registerVC animated:YES];
        
    } forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:queryBtn];
    [queryBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(titleLbl.mas_bottom).offset(20);
        make.left.equalTo(@15);
        make.right.equalTo(@(-15));
        make.height.equalTo(@45);
        
    }];
    
    //
    UIView *loginView = [[UIView alloc] init];
    
    [self.view addSubview:loginView];
    [loginView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(queryBtn.mas_bottom).offset(0);
        make.centerX.equalTo(@(10));
        
    }];
    
    //
    UILabel *textLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor2 font:16.0];
    
    textLbl.text = @"已有征信账号, 请点击";
    
    [loginView addSubview:textLbl];
    [textLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@0);
        make.centerY.equalTo(@0);
        make.edges.mas_equalTo(UIEdgeInsetsMake(20, 0, 20, 90));
    }];
    
    //loginBtn
    UIButton *loginBtn = [UIButton buttonWithTitle:@"登录" titleColor:kAppCustomMainColor backgroundColor:kWhiteColor titleFont:16.0 cornerRadius:4];
    
    loginBtn.layer.borderColor = kAppCustomMainColor.CGColor;
    loginBtn.layer.borderWidth = 0.5;
    
    [loginBtn setEnlargeEdgeWithTop:0 right:20 bottom:20 left:20];
    
    [loginBtn bk_addEventHandler:^(id sender) {
        
        PedestrianLoginVC *loginVC = [PedestrianLoginVC new];
        
        loginVC.isBackPreviousPage = YES;

        [weakSelf.navigationController pushViewController:loginVC animated:YES];
        
    } forControlEvents:UIControlEventTouchUpInside];
    
    [loginView addSubview:loginBtn];
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(textLbl.mas_right).offset(10);
        make.centerY.equalTo(@0);
        make.height.equalTo(@30);
        make.width.equalTo(@60);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
