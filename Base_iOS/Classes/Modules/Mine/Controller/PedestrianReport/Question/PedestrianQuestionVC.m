//
//  PedestrianQuestionVC.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/1/12.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "PedestrianQuestionVC.h"
#import "CoinHeader.h"
#import "AppConfig.h"
#import "NSString+Check.h"
#import "TLProgressHUD.h"
#import "UILabel+Extension.h"

#import <TFHpple.h>
//M
#import "PedestrianQuestionModel.h"
//V
#import "PedestrianQuestionTableView.h"

#define kOptionCount 5

@interface PedestrianQuestionVC ()
//questionList
@property (nonatomic, strong) NSMutableArray <PedestrianQuestionModel *> *questionList;
//tableview
@property (nonatomic, strong) PedestrianQuestionTableView *tableView;
//倒计时
@property (nonatomic, assign) NSInteger countDown;
//
@property (nonatomic, strong) UILabel *countDonwLbl;
//计时器
@property (nonatomic, strong) NSTimer *timer;
//网络请求
@property (nonatomic, strong) ZYNetworking *http;

@end

@implementation PedestrianQuestionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"获取身份验证码";
    
    self.questionList = [NSMutableArray array];
    
    _countDown = 600;
    
    //
    [self initTableView];
    //计时
    [self initCountDownView];
    
    //获取问题列表
    [self requestQuestionList];
    
}

#pragma mark - Init
- (void)initTableView {
    
    self.tableView = [[PedestrianQuestionTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(@0);
    }];
}


/**
 倒计时
 */
- (void)initCountDownView {
    
    UIView *countDownView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 100)];
    
    self.countDonwLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor font:18];
    
    self.countDonwLbl.numberOfLines = 0;
    
    [countDownView addSubview:self.countDonwLbl];
    [self.countDonwLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.center.equalTo(@0);
        make.left.equalTo(@15);
        make.right.equalTo(@(-20));
        
    }];
    
    self.tableView.tableHeaderView = countDownView;
}

/**
 提交
 */
- (void)initCommitBtn {
    
    UIView *commitView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 200)];
    
    UIButton *commitBtn = [UIButton buttonWithTitle:@"提交" titleColor:kWhiteColor backgroundColor:kAppCustomMainColor titleFont:16 cornerRadius:5];
    
    [commitBtn addTarget:self action:@selector(commitAnswer) forControlEvents:UIControlEventTouchUpInside];
    
    [commitView addSubview:commitBtn];
    [commitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.center.equalTo(@0);
        make.height.equalTo(@45);
        make.width.equalTo(@(kScreenWidth - 30));
        
    }];
    
    self.tableView.tableFooterView = commitView;
}

#pragma mark - Events

- (void)startCountDown {
    
    _timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(timeAction) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

- (void)timeAction
{
    _countDown --;
    //时间
    NSString *timeStr;
    
    if (_countDown < 60) {
        
        timeStr = [NSString stringWithFormat:@"%ld秒", _countDown];
    } else {
        
        timeStr = [NSString stringWithFormat:@"%ld分%ld秒", _countDown/60, _countDown%60];
    }
    NSString *str = [NSString stringWithFormat:@"您需要回答以下%ld个问题, 您还有%@的答题时间", self.questionList.count, timeStr];
    
    [self.countDonwLbl labelWithString:str title:timeStr font:Font(18) color:kThemeColor lineSpace:10];
    
    //如果时间到了就退出
    if (_countDown == 0) {
        
        [_timer invalidate];
        _timer = nil;
        _countDown = 0;
        
        [TLAlert alertWithTitle:@"" message:@"您回答问题的时间已超时, 系统将自动退出!" confirmMsg:@"OK" confirmAction:^{
            
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }
    
}

- (void)commitAnswer {
    
    [self.questionList enumerateObjectsUsingBlock:^(PedestrianQuestionModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (![obj.answerResult valid]) {
            
            [TLAlert alertWithInfo:@"必须对所有的题作答!"];
        }
    }];
    
    ZYNetworking *http = [ZYNetworking new];
    
    self.http = http;
    http.showView = self.view;
    http.url = kAppendUrl(@"reportAction.do");
    http.parameters[@"method"] = @"submitKBA";
    http.parameters[@"authtype"] = @"2";
    http.parameters[@"org.apache.struts.taglib.html.TOKEN"] = [TLUser user].tempToken;
    http.parameters[@"ApplicationOption"] = @"21";
    
    //循环传参
    [self.questionList enumerateObjectsUsingBlock:^(PedestrianQuestionModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        //derivativecode
        [self idx:idx key:@"derivativecode" value:obj.derivativeCode];
        //businesstype
        [self idx:idx key:@"businesstype" value:obj.businessType];
        //questionno
        [self idx:idx key:@"questionno" value:obj.questionNo];
        //kbanum
        [self idx:idx key:@"kbanum" value:obj.kbanum];
        //question
        [self idx:idx key:@"question" value:obj.question];
        //answerresult
        [self idx:idx key:@"answerresult" value:obj.answerResult];
        //options
        [self idx:idx key:@"options" value:obj.options];
        //optionList
        [obj.optionList enumerateObjectsUsingBlock:^(AnswerOption * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            [self idx:idx key:[NSString stringWithFormat:@"options%ld", idx] value:obj.option];

        }];
    }];
    
    //Referer
    [http setHeaderWithValue:@"https://ipcrs.pbccrc.org.cn/re…on.do?method=checkishasreport" headerField:@"Referer"];
    //Accept
    [http setHeaderWithValue:@"text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8" headerField:@"Accept"];
    //Upgrade-Insecure-Requests
    [http setHeaderWithValue:@"1" headerField:@"Upgrade-Insecure-Requests"];
    //Accept-Language
    [http setHeaderWithValue:@"zh-CN,zh;q=0.8,zh-TW;q=0.7,zh-HK;q=0.5,en-US;q=0.3,en;q=0.2" headerField:@"Accept-Language"];
    
    [http postWithSuccess:^(NSString *encoding, id responseObject) {

        [self getCommitResultWithEncoding:encoding responseObject:responseObject];

    } failure:^(NSError *error) {

    }];
    
}

/**
 传参
 */
- (void)idx:(NSInteger)idx key:(NSString *)key value:(NSString *)value {
    
    NSString *param = [NSString stringWithFormat:@"kbaList[%ld].%@", idx, key];
    
    self.http.parameters[param] = value;
    
}

/**
 根据结果做出处理
 @param encoding 服务器返回的编码格式
 @param responseObject 字节流数据
 */
- (void)getCommitResultWithEncoding:(NSString *)encoding responseObject:(id)responseObject {
    
    NSString *htmlStr = [NSString convertHtmlWithEncoding:encoding data:responseObject];
    
    NSLog(@"htmlStr = %@", htmlStr);
    
    TFHpple *hpple = [[TFHpple alloc] initWithHTMLData:responseObject encoding:encoding];
    
    NSArray *errorArr = [hpple searchWithXPathQuery:@"//div[@class='erro_div1']"];
    //一天只能回答问题一次
    if (errorArr.count > 0) {
        
        TFHppleElement *element = errorArr[0];
        
        [TLAlert alertWithInfo:element.content];
        
        return ;
    }
    //
    NSArray *dataArr = [hpple searchWithXPathQuery:@"//p"];
    
    for (TFHppleElement *element in dataArr) {
        
        if ([element.content containsString:@"1.您的查询申请已提交，若通过身份验证，会以短信形式将身份验证码发送到您预留手机上，请妥善保管，您可在24小时后访问平台获取结果。"]) {
            
            [TLAlert alertWithTitle:@"提示" message:@"1.您的查询申请已提交，若通过身份验证，会以短信形式将身份验证码发送到您预留手机上，请妥善保管，您可在24小时后访问平台获取结果。\n2.为保护您的信息安全，您申请的信用信息产品将在平台上保留7个自然日，过时平台会自动清理，请及时登录查看结果。" confirmMsg:@"OK" confirmAction:^{
                
                [self.navigationController popToRootViewControllerAnimated:YES];
            }];
        }
    };
    
}

#pragma mark - Data

- (void)requestQuestionList {
    
    ZYNetworking *http = [ZYNetworking new];
    
    http.showView = self.view;
    http.url = kAppendUrl(@"reportAction.do");
    http.parameters[@"method"] = @"checkishasreport";
    http.parameters[@"authtype"] = @"2";
    http.parameters[@"org.apache.struts.taglib.html.TOKEN"] = [TLUser user].tempToken;
    http.parameters[@"ApplicationOption"] = @"21";
    
    //Referer
    [http setHeaderWithValue:@"https://ipcrs.pbccrc.org.cn/reportAction.do?method=applicationReport" headerField:@"Referer"];
    //Accept
    [http setHeaderWithValue:@"text/html, application/xhtml+xml, application/xml, */*" headerField:@"Accept"];
    //Upgrade-Insecure-Requests
    [http setHeaderWithValue:@"1" headerField:@"Upgrade-Insecure-Requests"];
    //Accept-Language
    [http setHeaderWithValue:@"zh-CN,zh;q=0.8,zh-TW;q=0.7,zh-HK;q=0.5,en-US;q=0.3,en;q=0.2" headerField:@"Accept-Language"];
    
    [http postWithSuccess:^(NSString *encoding, id responseObject) {
        
        //获取Token
        [self getTokenWithEncoding:encoding responseObject:responseObject];
        //获取问题列表
        [self getQuestionWithEncoding:encoding responseObject:responseObject];
        
    } failure:^(NSError *error) {
        
    }];
}

/**
 获取Token
 @param encoding 服务器返回的编码格式
 @param responseObject 字节流数据
 */
- (void)getTokenWithEncoding:(NSString *)encoding responseObject:(id)responseObject {
    
    NSString *htmlStr = [NSString convertHtmlWithEncoding:encoding data:responseObject];
    
    NSLog(@"htmlStr = %@", htmlStr);
    
    TFHpple *hpple = [[TFHpple alloc] initWithHTMLData:responseObject encoding:encoding];
    //验证登录名是否正确
    NSArray *dataArr = [hpple searchWithXPathQuery:@"//input[@name='org.apache.struts.taglib.html.TOKEN']"];
    //获取注册流程需要用到的Token
    if (dataArr > 0) {
        
        TFHppleElement *element = dataArr[0];
        
        NSDictionary *attributes = element.attributes;
        
        [TLUser user].tempToken = attributes[@"value"];
        
    } else {
        
        [TLAlert alertWithInfo:@"系统繁忙, 请稍后再试"];
    }
}

/**
 获取问题列表
 */
- (void)getQuestionWithEncoding:(NSString *)encoding responseObject:(id)responseObject {
    
    NSString *htmlStr = [NSString convertHtmlWithEncoding:encoding data:responseObject];
    
    NSLog(@"htmlStr = %@", htmlStr);
    
    TFHpple *hpple = [[TFHpple alloc] initWithHTMLData:responseObject encoding:encoding];
    //验证登录名是否正确
    NSArray *dataArr = [hpple searchWithXPathQuery:@"//li"];
    
    for (int i = 0; i < dataArr.count - 1; i++) {
        
        PedestrianQuestionModel *model = [PedestrianQuestionModel new];
        //Question
        model.question = [self getValueForKey:[NSString stringWithFormat:@"//input[@name='kbaList[%d].question']", i] hpple:hpple];
        //derivativecode
        model.derivativeCode = [self getValueForKey:[NSString stringWithFormat:@"//input[@name='kbaList[%d].derivativecode']", i] hpple:hpple];
        //businesstype
        model.businessType = [self getValueForKey:[NSString stringWithFormat:@"//input[@name='kbaList[%d].businesstype']", i] hpple:hpple];
        //questionno
        model.questionNo = [self getValueForKey:[NSString stringWithFormat:@"//input[@name='kbaList[%d].questionno']", i] hpple:hpple];
        //kbanum
        model.kbanum = [self getValueForKey:[NSString stringWithFormat:@"//input[@name='kbaList[%d].kbanum']", i] hpple:hpple];
        
        //选项
        NSMutableArray *optionArr = [NSMutableArray array];
        
        for (int j = 0; j < kOptionCount; j++) {
            
            NSArray *options = [hpple searchWithXPathQuery:[NSString stringWithFormat:@"//input[@name='kbaList[%d].options%d']", i,j+1]];
            
            if (options.count > 0) {
                
                TFHppleElement *element = options[0];
                
                AnswerOption *answerOption = [AnswerOption new];
                
                answerOption.option = element.attributes[@"value"];
                answerOption.select = NO;
                
                [optionArr addObject:answerOption];
            }
            
        }
        
        model.optionList = optionArr;
        
        //添加model
        [self.questionList addObject:model];
    }
    
    //开始倒计时
    [self startCountDown];
    //刷新数据
    self.tableView.questionList = self.questionList;
    
    [self.tableView reloadData];
    //提交按钮
    [self initCommitBtn];
    
}

- (NSString *)getValueForKey:(NSString *)key hpple:(TFHpple *)hpple {
    
    NSArray *options = [hpple searchWithXPathQuery:key];
    
    if (options.count > 0) {
        
        TFHppleElement *element = options[0];
        
        return element.attributes[@"value"];
    }
    
    return @"";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
