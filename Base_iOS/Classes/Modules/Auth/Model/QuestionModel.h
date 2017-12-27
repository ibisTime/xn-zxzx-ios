//
//  QuestionModel.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/12/25.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "BaseModel.h"

#import <UIKit/UIKit.h>

@interface QuestionModel : BaseModel
//手机号认证
@property (nonatomic, copy) NSString *F1;
//芝麻认证
@property (nonatomic, copy) NSString *F2;
//基本信息认证
@property (nonatomic, copy) NSString *F3;
//身份证认证
@property (nonatomic, copy) NSString *PID1;
//定位认证
@property (nonatomic, copy) NSString *PDW2;
//通讯录认证
@property (nonatomic, copy) NSString *PTXL3;
//运营商认证
@property (nonatomic, copy) NSString *PYYS4;
//芝麻信用评分认证
@property (nonatomic, copy) NSString *PZM5;
//行业关注清单认证
@property (nonatomic, copy) NSString *PZM6;
//欺诈认证
@property (nonatomic, copy) NSString *PZM7;
//同盾认证
@property (nonatomic, copy) NSString *PTD8;
//调查单code
@property (nonatomic, copy) NSString *code;
//借款员UserID
@property (nonatomic, copy) NSString *loanUser;
//资信报告code
@property (nonatomic, copy) NSString *reportCode;
//业务员
@property (nonatomic, copy) NSString *salesUserMobile;
//问卷状态
@property (nonatomic, copy) NSString *status;
//状态转义
@property (nonatomic, copy) NSString *statusStr;
//cellHeight
@property (nonatomic, assign) CGFloat cellHeight;

@property (nonatomic, assign) NSInteger remainCount;

@property (nonatomic, copy) NSString *createDatetime;

@property (nonatomic, copy) NSString *salesUser;

@end
