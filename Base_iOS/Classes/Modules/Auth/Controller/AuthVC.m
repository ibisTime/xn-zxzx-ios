//
//  AuthVC.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/12/14.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "AuthVC.h"

#import "CoinHeader.h"
//M
#import "QuestionModel.h"
//V
#import "QuestionTableView.h"


@interface AuthVC ()<RefreshDelegate>
//
@property (nonatomic, strong) QuestionTableView *tableView;
//问卷列表
@property (nonatomic, strong) NSMutableArray <QuestionModel *> *questions;


@end

@implementation AuthVC

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    //刷新数据
    [self.tableView beginRefreshing];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"认证";
    //
    [self initTableView];
    //获取调查单列表
    [self requestQuestionList];

}

#pragma mark - Init

/**
 初始化tableview
 */
- (void)initTableView {
    
    self.tableView = [[QuestionTableView alloc] init];
    
    self.tableView.refreshDelegate = self;
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(UIEdgeInsetsZero);
        
    }];
    
}

#pragma mark - Data

/**
 获取调查列表
 */
- (void)requestQuestionList {
        
    BaseWeakSelf;
    
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    
    helper.code = @"805282";
    helper.start = 1;
    helper.limit = 20;
    helper.parameters[@"loanUser"] = [TLUser user].userId;
    helper.parameters[@"orderColumn"] = @"create_datetime";
    helper.parameters[@"orderDir"] = @"desc";
    helper.tableView = self.tableView;
    
    [helper modelClass:[QuestionModel class]];
    
    [self.tableView addRefreshAction:^{
        
        [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.questions = objs;
            
            weakSelf.tableView.questions = objs;
            
            [weakSelf.tableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
            
        }];
    }];
    
    [self.tableView addLoadMoreAction:^{
        
        [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.questions = objs;
            
            weakSelf.tableView.questions = objs;
            
            [weakSelf.tableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
            
        }];
    }];
    
    [self.tableView endRefreshingWithNoMoreData_tl];

}

#pragma mark - RefreshDelegate
- (void)refreshTableView:(TLTableView *)refreshTableview didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    QuestionModel *question = self.questions[indexPath.row];
    //调查单code
    [TLUser user].tempSearchCode = question.code;
    //报告单code
    [TLUser user].tempReportCode = question.reportCode;
    
    [self pushViewController];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
