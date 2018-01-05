//
//  CreditReportIdentifierCell.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/1/2.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ReportModel.h"

@interface CreditReportIdentifierCell : UITableViewCell

@property (nonatomic, strong) BaseInfoModel *infoModel;
//占位图
@property (nonatomic, copy) NSString *photo;

@end
