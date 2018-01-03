//
//  CreditReportVC.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/12/14.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "CreditReportVC.h"

//M
#import "QuestionModel.h"
//V
#import "CreditReportTableView.h"

#import "TLProgressHUD.h"
#import "UIBarButtonItem+convience.h"
#import "APICodeMacro.h"

@interface CreditReportVC ()

//报告单
@property (nonatomic, strong) QuestionModel *reportModel;
//
@property (nonatomic, strong) CreditReportTableView *tableView;

@end

@implementation CreditReportVC

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
 
    // 设置导航栏背景色
    [self.navigationController.navigationBar setBackgroundImage:[kWhiteColor convertToImage] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //
    [self initItem];
    //
    [self initTableView];
    
    if (self.type == ReportTypeLookReport) {
        
        //根据reportCode查询报关单详情
        [self queryReportDetail];
        
    } else {
        //查看最新的报关单详情
        [self queryLastReportDetail];
    }
}

#pragma mark - Init

- (void)initItem {
    
    self.navigationItem.titleView = [UILabel labelWithTitle:@"我的资信报告" frame:CGRectMake(0, 0, 200, 44) textColor:kTextColor];
    
    [UIBarButtonItem addLeftItemWithImageName:@"返回-黑色" frame:CGRectMake(-10, 0, 40, 44) vc:self action:@selector(clickBack)];

}

/**
 初始化tableview
 */
- (void)initTableView {
    
    self.tableView = [[CreditReportTableView alloc] init];
    
//    self.tableView.refreshDelegate = self;
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(UIEdgeInsetsZero);
        
    }];
    
}

- (void)requestAllKeyValues {
    
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

#pragma mark - Data

/**
 根据reportCode查询报关单详情
 */
- (void)queryReportDetail {
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"805331";
    http.parameters[@"reportCode"] = [TLUser user].tempReportCode;
    
    [http postWithSuccess:^(id responseObject) {
        
        [TLProgressHUD dismiss];
        
        self.reportModel = [QuestionModel mj_objectWithKeyValues:responseObject[@"data"]];
        
        ReportModel *reportModel = [ReportModel new];
        
        reportModel.report = self.reportModel;
        
        self.tableView.reportModel = reportModel;
        
        [self.tableView reloadData];

        //获取所有的数据字典
        [self requestAllKeyValues];
        
    } failure:^(NSError *error) {
        
        
    }];
}


/**
 查看最新的报关单详情
 */
- (void)queryLastReportDetail {
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"805333";
    http.showView = self.view;
    http.parameters[@"loanUser"] = [TLUser user].userId;
    
    [http postWithSuccess:^(id responseObject) {
        
        self.reportModel = [QuestionModel mj_objectWithKeyValues:responseObject[@"data"]];
        
        ReportModel *reportModel = [ReportModel new];
        
        reportModel.report = self.reportModel;
        
        self.tableView.reportModel = reportModel;
        
        [self.tableView reloadData];
        
        //获取所有的数据字典
        [self requestAllKeyValues];
        
    } failure:^(NSError *error) {
        
        
    }];
}

#pragma mark - 数据字典

- (void)requestEducation {
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = USER_DICT_PARENTKEY;
    
    http.parameters[@"parentKey"] = @"education";
    http.parameters[@"type"] = @"1";
    
    [http postWithSuccess:^(id responseObject) {
        
        self.reportModel.edcationArr = [KeyValueModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        
    } failure:^(NSError *error) {
        
        
    }];
}

- (void)requestLiveTime {
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = USER_DICT_PARENTKEY;
    
    http.parameters[@"parentKey"] = @"live_time";
    http.parameters[@"type"] = @"1";
    
    [http postWithSuccess:^(id responseObject) {
        
        self.reportModel.timeArr = [KeyValueModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];

        
    } failure:^(NSError *error) {
        
        
    }];
}

- (void)requestMarriage {
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = USER_DICT_PARENTKEY;
    
    http.parameters[@"parentKey"] = @"marriage";
    http.parameters[@"type"] = @"1";
    
    [http postWithSuccess:^(id responseObject) {
        
        self.reportModel.marriageArr = [KeyValueModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];

    } failure:^(NSError *error) {
        
        
    }];
}

- (void)requestJob {
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = USER_DICT_PARENTKEY;
    
    http.parameters[@"parentKey"] = @"occupation";
    http.parameters[@"type"] = @"1";
    
    [http postWithSuccess:^(id responseObject) {
        
        self.reportModel.jobArr = [KeyValueModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];

    } failure:^(NSError *error) {
        
        
    }];
}

- (void)requestIncome {
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = USER_DICT_PARENTKEY;
    
    http.parameters[@"parentKey"] = @"income";
    http.parameters[@"type"] = @"1";
    
    [http postWithSuccess:^(id responseObject) {
        
        self.reportModel.incomeArr = [KeyValueModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        
    } failure:^(NSError *error) {
        
        
    }];
}

- (void)requestFamilyRelation {
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = USER_DICT_PARENTKEY;
    
    http.parameters[@"parentKey"] = @"family_relation";
    http.parameters[@"type"] = @"1";
    
    [http postWithSuccess:^(id responseObject) {
        
        self.reportModel.familyArr = [KeyValueModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];

    } failure:^(NSError *error) {
        
        
    }];
}

- (void)requestSocietyRelation {
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = USER_DICT_PARENTKEY;
    
    http.parameters[@"parentKey"] = @"society_relation";
    http.parameters[@"type"] = @"1";
    
    [http postWithSuccess:^(id responseObject) {
        
        self.reportModel.societyArr = [KeyValueModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        
    } failure:^(NSError *error) {
        
        
    }];
}

#pragma mark - Events

- (void)clickBack {
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
