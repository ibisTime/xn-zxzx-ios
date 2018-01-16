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

//进度
@property (nonatomic, strong) UIView *progressView;

@end

@implementation PedestrianRegisterSuccessVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"完成注册";
    //进度
    [self initProgressView];
    //
    [self initSubviews];
}

#pragma mark - Init

- (void)initProgressView {
    
    self.progressView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 120)];
    
    [self.bgSV addSubview:self.progressView];
    
    NSArray *textArr = @[@"填写身\n份信息", @"补充用\n户信息", @"完成\n注册"];
    
    for (int i = 0; i < 3; i++) {
        
        CGFloat numW = 35;
        CGFloat leftMargin = (i-1)*kScreenWidth/4.0;
        //数字
        UILabel *numLbl = [UILabel labelWithBackgroundColor:kAppCustomMainColor textColor:kWhiteColor font:20.0];
        
        numLbl.textAlignment = NSTextAlignmentCenter;
        
        numLbl.text = [NSString stringWithFormat:@"%d", i+1];
        numLbl.layer.cornerRadius = numW/2.0;
        numLbl.clipsToBounds = YES;
        numLbl.layer.borderWidth = 3;
        numLbl.layer.borderColor = kLineColor.CGColor;
        
        [self.progressView addSubview:numLbl];
        [numLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.width.height.equalTo(@(numW));
            make.top.equalTo(@20);
            make.centerX.equalTo(@(leftMargin));
            
        }];
        
        //步骤
        UILabel *textLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kAppCustomMainColor font:14.0];
        
        textLbl.textAlignment = NSTextAlignmentCenter;
        textLbl.numberOfLines = 0;
        textLbl.text = textArr[i];
        
        [self.progressView addSubview:textLbl];
        [textLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(numLbl.mas_bottom).offset(15);
            make.centerX.equalTo(@(leftMargin));
            
        }];
        
        if (i < 2) {
            
            //line
            UIView *line = [[UIView alloc] init];
            
            line.backgroundColor = kPlaceholderColor;
            
            [self.progressView addSubview:line];
            [line mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.left.equalTo(textLbl.mas_right).offset(10);
                make.height.equalTo(@0.5);
                make.width.equalTo(@(kWidth(35)));
                make.top.equalTo(textLbl.mas_top).offset(-5);
                
            }];
        }
    }
}

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
