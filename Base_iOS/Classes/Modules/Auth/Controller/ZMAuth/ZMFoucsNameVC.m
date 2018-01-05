//
//  ZMFoucsNameVC.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/12/28.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "ZMFoucsNameVC.h"

#import "TLTextField.h"

#import "NSString+Check.h"

#import <ZMCreditSDK/ALCreditService.h>
#import "ZMFoucsModel.h"
#import "QuestionModel.h"

#import "AppMacro.h"

@interface ZMFoucsNameVC ()
//真实姓名
@property (nonatomic, strong) TLTextField *realName;
//身份证
@property (nonatomic, strong) TLTextField *idCard;
//报告单
@property (nonatomic, strong) QuestionModel *reportModel;

@end

@implementation ZMFoucsNameVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"行业关注清单";
    
    [self initSubviews];
    
}

#pragma mark - Init
- (void)initSubviews {
    
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
    
    http.isShowMsg = NO;
    http.showView = self.view;
    
    http.code = @"805259";
    http.parameters[@"isH5"] = @"0";
    http.parameters[@"searchCode"] = [TLUser user].tempSearchCode;
    
    [http postWithSuccess:^(id responseObject) {
        
        if ([responseObject[@"errorCode"] isEqual:@"0"]) {
            
            ZMFoucsModel *foucsModel = [ZMFoucsModel mj_objectWithKeyValues:responseObject[@"data"]];
            
            //是否授权
            if (foucsModel.authorized) {
                
                [TLAlert alertWithSucces:@"行业关注认证成功"];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    [self pushViewController];
                    
                });
                
            } else {
                
                NSString *appId = foucsModel.appId;
                
                NSString *sign = foucsModel.signature;
                
                NSString *params = foucsModel.param;
                
                if (appId && sign && params) {
                    
                    [[ALCreditService sharedService] queryUserAuthReq:appId sign:sign params:params extParams:nil selector:@selector(result:) target:self];
                    
                } else {
                    
                    [TLAlert alertWithInfo:@"appId或sign或param为空"];
                }
                
                return ;
                
            }
            
        } else {
            
            [TLAlert alertWithInfo:responseObject[@"errorInfo"]];
        }
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)result:(NSMutableDictionary *)dic {
    
    NSLog(@"result %@", dic);
    
    if (dic[@"authResult"]) {
        
        TLNetworking *http = [TLNetworking new];
        
        http.isShowMsg = NO;
        
        http.code = @"805259";
        http.parameters[@"isH5"] = @"0";
        http.parameters[@"searchCode"] = [TLUser user].tempSearchCode;
        
        [http postWithSuccess:^(id responseObject) {
            
            if ([responseObject[@"errorCode"] isEqual:@"0"]) {
                
                [TLAlert alertWithSucces:@"行业关注认证成功"];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    [self pushViewController];
                    
                });
            } else {
                
                [TLAlert alertWithInfo:responseObject[@"errorInfo"]];
            }
            
        } failure:^(NSError *error) {
            
        }];
        
    } else {
        
        [TLAlert alertWithError:@"授权失败"];
    }
    
}

#pragma mark - Setting

- (void)setReportModel:(QuestionModel *)reportModel {
    
    _reportModel = reportModel;
    
    F2Model *f2Model = reportModel.f2Model;
    
    STRING_NIL_NULL(f2Model.realName);
    
    self.realName.text = f2Model.realName;
    
    STRING_NIL_NULL(f2Model.idNo);
    
    self.idCard.text = f2Model.idNo;
}

#pragma mark - Data
/**
 查询报告单详情
 */
- (void)queryQuestionDetail {
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"805334";
    http.showView = self.view;
    http.parameters[@"reportCode"] = [TLUser user].tempReportCode;
    
    [http postWithSuccess:^(id responseObject) {
        
        self.reportModel = [QuestionModel mj_objectWithKeyValues:responseObject[@"data"]];
        
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
