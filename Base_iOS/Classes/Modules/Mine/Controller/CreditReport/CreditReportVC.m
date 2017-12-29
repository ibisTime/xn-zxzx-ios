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
    // Do any additional setup after loading the view.
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
        
        self.tableView.reportModel = self.reportModel;
        
        [self.tableView reloadData];

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
