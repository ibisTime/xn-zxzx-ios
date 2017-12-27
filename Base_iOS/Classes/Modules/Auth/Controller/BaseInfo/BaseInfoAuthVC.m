//
//  BaseInfoAuthVC.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/12/26.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "BaseInfoAuthVC.h"
//M
#import "KeyValueModel.h"
//V
#import "BaseInfoView.h"
#import "JobInfoView.h"
#import "EmergencyContactView.h"
//C

#import "APICodeMacro.h"
#import <UIScrollView+TLAdd.h>
#import "NSString+Check.h"

#define CellHeight 46

@interface BaseInfoAuthVC ()
//基本信息
@property (nonatomic, strong) BaseInfoView *baseInfoView;
//职业信息
@property (nonatomic, strong) JobInfoView *jobInfoView;
//紧急联系人
@property (nonatomic, strong) EmergencyContactView *contactView;

//学历
@property (nonatomic, strong) NSMutableArray <KeyValueModel *>*edcationArr;
//居住年限
@property (nonatomic, strong) NSMutableArray <KeyValueModel *>*timeArr;
//婚姻状况
@property (nonatomic, strong) NSMutableArray <KeyValueModel *>*marriageArr;
//职业
@property (nonatomic, strong) NSMutableArray <KeyValueModel *>*jobArr;
//收入
@property (nonatomic, strong) NSMutableArray <KeyValueModel *>*incomeArr;
//亲属关系
@property (nonatomic, strong) NSMutableArray <KeyValueModel *>*familyArr;
//朋友关系
@property (nonatomic, strong) NSMutableArray <KeyValueModel *>*societyArr;

@end

@implementation BaseInfoAuthVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"基本信息认证";
    
    [self initSubviews];
    
    [self initData];
    
}

#pragma mark - Init

- (void)initData {
    //获取学历列表
    [self requestEducation];
    //获取居住年限列表
    [self requestLiveTime];
    //获取婚姻状况列表
    [self requestMarriage];
    //获取职业列表
    [self requestJob];
    //获取输入列表
    [self requestIncome];
    //获取亲属关系列表
    [self requestFamilyRelation];
    //获取朋友关系列表
    [self requestSocietyRelation];
}

- (void)initSubviews {
    
    //基本信息
    [self initBaseInfoView];
    //职业信息
    [self initJobInfoView];
    //紧急联系人
    [self initEmergencyContactView];
    //下一步
    [self initBottomView];
    
}

- (void)initBaseInfoView {
    
    self.baseInfoView = [[BaseInfoView alloc] initWithFrame:CGRectMake(0, 10, kScreenWidth, 8*CellHeight)];
    
    [self.bgSV addSubview:self.baseInfoView];
    
}

- (void)initJobInfoView {
    
    self.jobInfoView = [[JobInfoView alloc] initWithFrame:CGRectMake(0, self.baseInfoView.yy + 10, kScreenWidth, 6*CellHeight)];
    
    [self.bgSV addSubview:self.jobInfoView];
    
}

- (void)initEmergencyContactView {
    
    self.contactView = [[EmergencyContactView alloc] initWithFrame:CGRectMake(0, self.jobInfoView.yy + 10, kScreenWidth, 6*CellHeight + 10)];
    
    [self.bgSV addSubview:self.contactView];
    
    self.bgSV.height -= (65 + kBottomInsetHeight);
    self.bgSV.contentSize = CGSizeMake(kScreenWidth, self.contactView.yy + 10);
    [self.bgSV adjustsContentInsets];

}

- (void)initBottomView {
    
    //底部视图
    UIView *bottomView = [[UIView alloc] init];
    
    bottomView.backgroundColor = kWhiteColor;
    
    [self.view addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.bottom.equalTo(@0);
        make.height.equalTo(@(65 + kBottomInsetHeight));
        
    }];
    
    //下一步
    UIButton *investBtn = [UIButton buttonWithTitle:@"下一步" titleColor:kWhiteColor backgroundColor:kAppCustomMainColor titleFont:18 cornerRadius:5];
    
    [investBtn addTarget:self action:@selector(clickNext) forControlEvents:UIControlEventTouchUpInside];
    
    [bottomView addSubview:investBtn];
    [investBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@15);
        make.right.equalTo(@(-15));
        make.top.equalTo(@10);
        make.height.equalTo(@45);
        
    }];
}

#pragma mark - Events
- (void)clickNext {
    
    //检查用户填写是否正确
    [self checkUserInfo];
    //提交基本信息
    [self commitUserInfo];
    
}

- (void)checkUserInfo {
    
    if (![self.baseInfoView.edcationTF.text valid]) {
        
        [TLAlert alertWithInfo:@"请选择学历"];
        return;
    };
    
    if (![self.baseInfoView.marriageTF.text valid]) {
        
        [TLAlert alertWithInfo:@"请选择婚姻状态"];
        
        return;
    }
    
    if (![self.baseInfoView.childernNumTF.text valid]) {
        
        [TLAlert alertWithInfo:@"请输入子女数量"];
        
        return;
    }
    
    if (![self.baseInfoView.liveProvinceTF.text valid]) {
        
        [TLAlert alertWithInfo:@"请输入居住省市"];
        
        return;
    }
    
    if (![self.baseInfoView.addressTF.text valid]) {
        
        [TLAlert alertWithInfo:@"请输入详细地址"];
        
        return;
    }
    
    if (![self.baseInfoView.liveTimeTF.text valid]) {
        
        [TLAlert alertWithInfo:@"请输入居住时长"];
        
        return;
    }
    
    if ([self.baseInfoView.qqTF.text valid]) {
        
        if (self.baseInfoView.qqTF.text.length < 6) {
            
            [TLAlert alertWithInfo:@"请输入正确的QQ号码"];
            return ;
        }
    }
    
    if ([self.baseInfoView.emailTF.text valid]) {
        
        if (![self.baseInfoView.emailTF.text isValidateEmail]) {
            
            [TLAlert alertWithInfo:@"请输入正确的邮箱格式"];
            return;
        }
    }
    
    if (![self.jobInfoView.jobTF.text valid]) {
        
        [TLAlert alertWithInfo:@"请选择职业"];
        return;
    };
    
    if (![self.jobInfoView.incomeTF.text valid]) {
        
        [TLAlert alertWithInfo:@"请选择月收入"];
        
        return;
    }
    
    if (![self.jobInfoView.companyNameTF.text valid]) {
        
        [TLAlert alertWithInfo:@"请输入单位名称"];
        
        return;
    }
    
    if (![self.jobInfoView.provinceTF.text valid]) {
        
        [TLAlert alertWithInfo:@"请选择单位所在省市"];
        
        return;
    }
    
    if (![self.jobInfoView.addressTF.text valid]) {
        
        [TLAlert alertWithInfo:@"请输入详细地址"];
        
        return;
    }
    
    
    if (![self.contactView.familyRelationTF.text valid]) {
        
        [TLAlert alertWithInfo:@"请选择亲属关系"];
        return;
    };
    
    if (![self.contactView.familyNameTF.text valid]) {
        
        [TLAlert alertWithInfo:@"请输入亲属姓名"];
        return;
    }
    
    if (![self.contactView.familyMobileTF.text valid]) {
        
        [TLAlert alertWithInfo:@"请输入亲属联系人手机号"];
        return;
    }
    
    if (self.contactView.familyMobileTF.text.length != 11) {
        
        [TLAlert alertWithInfo:@"请输入11位手机号"];
        
        return;
    }
    
    if (![self.contactView.societyRelationTF.text valid]) {
        
        [TLAlert alertWithInfo:@"请选择社会关系"];
        return;
    }
    
    if (![self.contactView.societyNameTF.text valid]) {
        
        [TLAlert alertWithInfo:@"请输入社会联系人姓名"];
        return;
    }
    
    if (![self.contactView.societyMobileTF.text valid]) {
        
        [TLAlert alertWithInfo:@"请输入社会联系人手机号"];
        return;
    }
    
    if (self.contactView.societyMobileTF.text.length != 11) {
        
        [TLAlert alertWithInfo:@"请输入11位手机号"];
        
        return;
    }
    
}
//提交基本信息

- (void)commitUserInfo {
    
    TLNetworking *http = [TLNetworking new];
    
    http.showView = self.view;
    
    http.code = @"805253";
    http.parameters[@"userId"] = [TLUser user].userId;
    http.parameters[@"searchCode"] = [TLUser user].tempSearchCode;
    //基本信息
    http.parameters[@"address"] = self.baseInfoView.addressTF.text;
    http.parameters[@"childrenNum"] = self.baseInfoView.childernNumTF.text;
    http.parameters[@"education"] = self.baseInfoView.selectEdcation;
    http.parameters[@"email"] = self.baseInfoView.emailTF.text;
    http.parameters[@"liveTime"] = self.baseInfoView.selectLiveTime;
    http.parameters[@"marriage"] = self.baseInfoView.selectMarriage;
    http.parameters[@"provinceCity"] = self.baseInfoView.liveProvinceTF.text;
    http.parameters[@"qq"] = self.baseInfoView.qqTF.text;
    //职业信息
    http.parameters[@"companyAddress"] = self.jobInfoView.addressTF.text;
    http.parameters[@"company"] = self.jobInfoView.companyNameTF.text;
    http.parameters[@"income"] = self.jobInfoView.selectIncome;
    http.parameters[@"occupation"] = self.jobInfoView.selectJob;
    http.parameters[@"phone"] = self.jobInfoView.mobileTF.text;
    http.parameters[@"companyProvinceCity"] = self.jobInfoView.provinceTF.text;
    //紧急联系人
    http.parameters[@"familyRelation"] = self.contactView.selectFamily;
    http.parameters[@"familyName"] = self.contactView.familyNameTF.text;
    http.parameters[@"familyMobile"] = self.contactView.familyMobileTF.text;
    
    http.parameters[@"societyRelation"] = self.contactView.selectSociety;
    http.parameters[@"societyName"] = self.contactView.societyNameTF.text;
    http.parameters[@"societyMobile"] = self.contactView.societyMobileTF.text;
    
    [http postWithSuccess:^(id responseObject) {
        
        [TLAlert alertWithSucces:@"提交成功"];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self.navigationController popViewControllerAnimated:YES];
            
        });
        
    } failure:^(NSError *error) {
        
        
    }];
}

#pragma mark - Data

- (void)requestEducation {
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = USER_DICT_PARENTKEY;
    
    http.parameters[@"parentKey"] = @"education";
    http.parameters[@"type"] = @"1";
    
    [http postWithSuccess:^(id responseObject) {
        
        self.edcationArr = [NSMutableArray array];
        
        self.baseInfoView.edcationTF.tagNames = [self convertTitlesWithArr:self.edcationArr responseObject:responseObject];
        
        self.baseInfoView.edcationArr = self.edcationArr;
        
    } failure:^(NSError *error) {
        
        
    }];
}

- (void)requestLiveTime {
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = USER_DICT_PARENTKEY;
    
    http.parameters[@"parentKey"] = @"live_time";
    http.parameters[@"type"] = @"1";
    
    [http postWithSuccess:^(id responseObject) {
        
        self.timeArr = [NSMutableArray array];
        
        self.baseInfoView.liveTimeTF.tagNames = [self convertTitlesWithArr:self.timeArr responseObject:responseObject];
        
        self.baseInfoView.timeArr = self.timeArr;

    } failure:^(NSError *error) {
        
        
    }];
}

- (void)requestMarriage {
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = USER_DICT_PARENTKEY;
    
    http.parameters[@"parentKey"] = @"marriage";
    http.parameters[@"type"] = @"1";
    
    [http postWithSuccess:^(id responseObject) {
        
        self.marriageArr = [NSMutableArray array];

        self.baseInfoView.marriageTF.tagNames = [self convertTitlesWithArr:self.marriageArr responseObject:responseObject];
        
        self.baseInfoView.marriageArr = self.marriageArr;
        
    } failure:^(NSError *error) {
        
        
    }];
}

- (void)requestJob {
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = USER_DICT_PARENTKEY;
    
    http.parameters[@"parentKey"] = @"occupation";
    http.parameters[@"type"] = @"1";
    
    [http postWithSuccess:^(id responseObject) {
        
        self.jobArr = [NSMutableArray array];
        
        self.jobInfoView.jobTF.tagNames = [self convertTitlesWithArr:self.jobArr responseObject:responseObject];
        
        self.jobInfoView.jobArr = self.jobArr;
    
        
    } failure:^(NSError *error) {
        
        
    }];
}

- (void)requestIncome {
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = USER_DICT_PARENTKEY;
    
    http.parameters[@"parentKey"] = @"income";
    http.parameters[@"type"] = @"1";
    
    [http postWithSuccess:^(id responseObject) {
        
        self.incomeArr = [NSMutableArray array];
        
        self.jobInfoView.incomeTF.tagNames = [self convertTitlesWithArr:self.incomeArr responseObject:responseObject];
        
        self.jobInfoView.incomeArr = self.incomeArr;
        
    } failure:^(NSError *error) {
        
        
    }];
}

- (void)requestFamilyRelation {
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = USER_DICT_PARENTKEY;
    
    http.parameters[@"parentKey"] = @"family_relation";
    http.parameters[@"type"] = @"1";
    
    [http postWithSuccess:^(id responseObject) {
        
        self.familyArr = [NSMutableArray array];
        
        self.contactView.familyRelationTF.tagNames = [self convertTitlesWithArr:self.familyArr responseObject:responseObject];
        
        self.contactView.familyArr = self.familyArr;
        
        
    } failure:^(NSError *error) {
        
        
    }];
}

- (void)requestSocietyRelation {
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = USER_DICT_PARENTKEY;
    
    http.parameters[@"parentKey"] = @"society_relation";
    http.parameters[@"type"] = @"1";
    
    [http postWithSuccess:^(id responseObject) {
        
        self.societyArr = [NSMutableArray array];
        
        self.contactView.societyRelationTF.tagNames = [self convertTitlesWithArr:self.societyArr responseObject:responseObject];
        
        self.contactView.societyArr = self.societyArr;
        
    } failure:^(NSError *error) {
        
        
    }];
}

//将模型转成titleArr
- (NSArray *)convertTitlesWithArr:(NSMutableArray *)array responseObject:(id) responseObject {
    
    NSArray *arr = [KeyValueModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];

    NSMutableArray *titleArr = [NSMutableArray array];
    
    for (KeyValueModel *model in arr) {
        
        [array addObject:model];
        
        [titleArr addObject:model.dvalue];
        
    }
    
    return titleArr.copy;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
