//
//  CreditReportVC.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/12/14.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "BaseViewController.h"

typedef NS_ENUM(NSInteger, ReportType) {
    
    ReportTypeLastReport = 0,       //最新的
    ReportTypeLookReport,           //首页查看报告

};

@interface CreditReportVC : BaseViewController

@property (nonatomic, assign) ReportType type;

@end
