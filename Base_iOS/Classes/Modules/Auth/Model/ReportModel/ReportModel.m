//
//  ReportModel.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/12/29.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "ReportModel.h"

@implementation ReportModel

- (NSArray<PortModel *> *)portListArr {
    
    NSMutableArray *portList = [NSMutableArray array];
    
    NSDictionary *dict = @{
                           @"F1":   @"手机认证",
                           @"F2":   @"芝麻认证",
                           @"F3":   @"基本信息认证",
                           @"PID1": @"身份证认证",
                           @"PDW2": @"定位信息",
                           @"PTXL3":@"通讯录认证",
                           @"PYYS4":@"运营商认证",
                           @"PZM5": @"芝麻信用分",
                           @"PZM6": @"行业关注清单",
                           @"PZM7": @"欺诈认证",
                           @"PTD8": @"同盾认证",
                           
                           };
    
    NSArray *portArr = [self.report.portList componentsSeparatedByString:@","];
    
    [portArr enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (idx > 1) {
            PortModel *port = [PortModel new];
            
            port.authCode = obj;
            
            port.authName = dict[obj];
            
            [portList addObject:port];
        }
    }];
    
    return portList.copy;
}

//基本信息认证
- (NSArray<BaseInfoModel *> *)baseInfoArr {
    
    NSMutableArray *arr = [NSMutableArray array];
    //姓名
    NSString *realName = self.report.f2Model.realName;
    
    [arr addObject:[self addInfoModelWithTitle:@"姓名" content:realName]];
    //
    
    return arr.copy;
}

- (BaseInfoModel *)addInfoModelWithTitle:(NSString *)title content:(NSString *)content {
    
    BaseInfoModel *infoModel = [BaseInfoModel new];
    
    infoModel.title = title;
    infoModel.content = content;
    
    return infoModel;
    
}

@end

@implementation BaseInfoModel

@end
