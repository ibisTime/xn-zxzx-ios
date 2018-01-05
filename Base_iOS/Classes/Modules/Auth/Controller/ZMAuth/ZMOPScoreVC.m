//
//  ZMOPScoreVC.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/12/28.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "ZMOPScoreVC.h"

#import "TLTextField.h"
#import "NavigationController.h"

#import "NSString+Check.h"
#import "UIColor+Extension.h"

#import <ZMCreditSDK/ALCreditService.h>
#import "ZMScoreModel.h"
#import "QuestionModel.h"

#import "AppMacro.h"

@interface ZMOPScoreVC ()
//真实姓名
@property (nonatomic, strong) TLTextField *realName;
//身份证
@property (nonatomic, strong) TLTextField *idCard;
//报告单
@property (nonatomic, strong) QuestionModel *reportModel;
//是否授权
@property (nonatomic, assign) BOOL isAuth;

@end

@implementation ZMOPScoreVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"芝麻信用评分";
    
    [self initSubviews];
    //查看报告单
    [self queryReportDetail];

}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    NavigationController *navi = (NavigationController *)self.navigationController;
    
    navi.isHidden = NO;
    
    self.navigationController.navigationBar.translucent = NO;
    
    [self.navigationController.navigationBar setBackgroundImage:[kAppCustomMainColor convertToImage] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    
}

- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
    
    self.navigationController.navigationBar.translucent = YES;
    
    if (!_isAuth) {
        
        [self.navigationController.navigationBar setBackgroundImage:[kBlackColor convertToImage] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    }
}

#pragma mark - Init
- (void)initSubviews {
    
    _isAuth = YES;

    CGFloat leftMargin = 15;
    
    self.realName = [[TLTextField alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 50) leftTitle:@"姓名" titleWidth:105 placeholder:@"请输入姓名"];
    
    self.realName.returnKeyType = UIReturnKeyNext;
    
    [self.realName addTarget:self action:@selector(next:) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    [self.view addSubview:self.realName];
    
    self.idCard = [[TLTextField alloc] initWithFrame:CGRectMake(0, self.realName.yy, kScreenWidth, 50) leftTitle:@"身份证号码" titleWidth:105 placeholder:@"请输入身份证号码"];
    
    [self.view addSubview:self.idCard];
    
    UIButton *confirmBtn = [UIButton buttonWithTitle:@"确认" titleColor:kWhiteColor backgroundColor:kAppCustomMainColor titleFont:15.0 cornerRadius:5];
    
    confirmBtn.frame = CGRectMake(leftMargin, self.idCard.yy + 40, kScreenWidth - 2*leftMargin, 45);
    
    [confirmBtn addTarget:self action:@selector(confirmIDCard:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:confirmBtn];
    
    
}

#pragma mark - Events
- (void)confirmIDCard:(UIButton *)sender {
    
    if (![self.realName.text valid]) {
        
        [TLAlert alertWithInfo:@"请输入姓名"];
        return;
    }
    
    if (![self.idCard.text valid]) {
        
        [TLAlert alertWithInfo:@"请输入身份证号码"];
        return;
    }
    
    if (self.idCard.text.length != 18) {
        
        [TLAlert alertWithInfo:@"请输入18位身份证号码"];
        return;
    }
    
    [self.view endEditing:YES];
    
    TLNetworking *http = [TLNetworking new];
    
    http.showView = self.view;
    
    http.code = @"805258";
    http.parameters[@"isH5"] = @"0";
    http.parameters[@"searchCode"] = [TLUser user].tempSearchCode;
    
    [http postWithSuccess:^(id responseObject) {
        
        ZMScoreModel *scoreModel = [ZMScoreModel mj_objectWithKeyValues:responseObject[@"data"]];
        
        //是否授权
        if (scoreModel.authorized) {
            
            _isAuth = YES;
            
            [TLAlert alertWithSucces:@"芝麻信用认证成功"];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [self pushViewController];
                
            });
            
        } else {
            
            _isAuth = NO;
            
            NSString *appId = scoreModel.appId;
            
            NSString *sign = scoreModel.signature;
            
            NSString *params = scoreModel.param;
            
            if (appId && sign && params) {
                
                NavigationController *navi = (NavigationController *)self.navigationController;
                
                navi.isHidden = YES;
                
                [[ALCreditService sharedService] queryUserAuthReq:appId sign:sign params:params extParams:nil selector:@selector(result:) target:self];
                
            } else {
                
                [TLAlert alertWithInfo:@"appId或sign或param为空"];
            }
            
            return ;
            
        }
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)result:(NSMutableDictionary *)dic {
    
    NSLog(@"result %@", dic);
    
    if ([dic[@"authResult"] valid]) {
        
        TLNetworking *http = [TLNetworking new];
        
        http.code = @"805258";
        http.parameters[@"isH5"] = @"0";
        http.parameters[@"searchCode"] = [TLUser user].tempSearchCode;
        
        [http postWithSuccess:^(id responseObject) {
            
            _isAuth = YES;

            [TLAlert alertWithSucces:@"芝麻信用认证成功"];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [self pushViewController];
                
            });
        } failure:^(NSError *error) {
            
        }];
        
    }
}

#pragma mark - Data
/**
 查询报告单详情
 */
- (void)queryReportDetail {
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"805334";
    http.showView = self.view;
    http.parameters[@"reportCode"] = [TLUser user].tempReportCode;
    
    [http postWithSuccess:^(id responseObject) {
        
        self.reportModel = [QuestionModel mj_objectWithKeyValues:responseObject[@"data"]];
        
        F2Model *f2Model = self.reportModel.f2Model;
        
        STRING_NIL_NULL(f2Model.realName);
        
        self.realName.text = f2Model.realName;
        
        STRING_NIL_NULL(f2Model.idNo);
        
        self.idCard.text = f2Model.idNo;
        
    } failure:^(NSError *error) {
        
        
    }];
}

- (void)next:(UITextField *)sender {
    
    [self.idCard becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
