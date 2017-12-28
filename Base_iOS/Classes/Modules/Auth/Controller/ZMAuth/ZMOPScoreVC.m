//
//  ZMOPScoreVC.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/12/28.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "ZMOPScoreVC.h"

#import "TLTextField.h"

#import "NSString+Check.h"

#import <ZMCreditSDK/ALCreditService.h>
#import "ZMScoreModel.h"

#import "AppMacro.h"

@interface ZMOPScoreVC ()

@property (nonatomic, strong) TLTextField *realName;    //真实姓名

@property (nonatomic, strong) TLTextField *idCard;      //身份证

@end

@implementation ZMOPScoreVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"芝麻信用评分";
    
    [self initSubviews];

}

#pragma mark - Init
- (void)initSubviews {
    
    CGFloat leftMargin = 15;
    
    self.realName = [[TLTextField alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 50) leftTitle:@"姓名" titleWidth:105 placeholder:@"请输入姓名"];
    
    STRING_NIL_NULL([TLUser user].realName);
    
    self.realName.text = [TLUser user].realName;
    
    self.realName.returnKeyType = UIReturnKeyNext;
    
    [self.realName addTarget:self action:@selector(next:) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    [self.view addSubview:self.realName];
    
    self.idCard = [[TLTextField alloc] initWithFrame:CGRectMake(0, self.realName.yy, kScreenWidth, 50) leftTitle:@"身份证号码" titleWidth:105 placeholder:@"请输入身份证号码"];
    
    STRING_NIL_NULL([TLUser user].idNo);
    
    self.idCard.text = [TLUser user].idNo;
    
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
    
    http.code = @"805258";
    http.parameters[@"isH5"] = @"0";
    http.parameters[@"searchCode"] = [TLUser user].tempSearchCode;
    
    [http postWithSuccess:^(id responseObject) {
        
        if ([responseObject[@"errorCode"] isEqual:@"0"]) {
            
            ZMScoreModel *scoreModel = [ZMScoreModel mj_objectWithKeyValues:responseObject[@"data"]];
            
            //是否授权
            if (scoreModel.authorized) {
                
                [TLAlert alertWithSucces:@"芝麻信用认证成功"];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    [self pushViewController];
                    
                });
                
            } else {
                
                NSString *appId = scoreModel.appId;
                
                NSString *sign = scoreModel.signature;
                
                NSString *params = scoreModel.param;
                
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
        
        http.code = @"805258";
        http.parameters[@"isH5"] = @"0";
        http.parameters[@"searchCode"] = [TLUser user].tempSearchCode;
        
        [http postWithSuccess:^(id responseObject) {
            
            [TLAlert alertWithSucces:@"芝麻信用认证成功"];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [self pushViewController];
                
            });
        } failure:^(NSError *error) {
            
        }];
        
    } else {
        
        [TLAlert alertWithError:@"授权失败"];
    }
    
}

- (void)next:(UITextField *)sender {
    
    [self.idCard becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
