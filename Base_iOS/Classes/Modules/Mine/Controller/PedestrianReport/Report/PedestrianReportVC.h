//
//  PedestrianReportVC.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/1/12.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "PedestrianBaseVC.h"

@interface PedestrianReportVC : PedestrianBaseVC

//报告链接
@property (nonatomic, copy) NSString *reportUrl;
//参数
@property (nonatomic, strong) NSString *postParam;

@end
