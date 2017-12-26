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

@property (nonatomic, copy) NSString *PTXL3;

@property (nonatomic, copy) NSString *PZM5;

@property (nonatomic, copy) NSString *PDW2;

@property (nonatomic, copy) NSString *loanUser;

@property (nonatomic, copy) NSString *PID1;

@property (nonatomic, copy) NSString *reportCode;

@property (nonatomic, copy) NSString *PZM7;

@property (nonatomic, assign) NSInteger remainCount;

@property (nonatomic, copy) NSString *F1;

@property (nonatomic, copy) NSString *code;

@property (nonatomic, copy) NSString *PTD8;

@property (nonatomic, copy) NSString *createDatetime;

@property (nonatomic, copy) NSString *PZM6;

@property (nonatomic, copy) NSString *F2;

@property (nonatomic, copy) NSString *F3;

@property (nonatomic, copy) NSString *salesUser;

@property (nonatomic, copy) NSString *PYYS4;
//业务员
@property (nonatomic, copy) NSString *salesUserMobile;
//问卷状态
@property (nonatomic, copy) NSString *status;
//状态转义
@property (nonatomic, copy) NSString *statusStr;
//cellHeight
@property (nonatomic, assign) CGFloat cellHeight;

@end
