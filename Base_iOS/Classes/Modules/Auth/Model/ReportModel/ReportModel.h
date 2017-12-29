//
//  ReportModel.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/12/29.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "BaseModel.h"

#import "QuestionModel.h"

@class BaseInfoModel;

@interface ReportModel : BaseModel

@property (nonatomic, strong) QuestionModel *report;

//model
@property (nonatomic, strong) NSArray <PortModel *>*portListArr;

//折叠等级
@property (nonatomic, copy) NSString *level;
//是否折叠
@property (nonatomic, assign) BOOL isFold;
//基本信息
@property (nonatomic, strong) NSArray <BaseInfoModel *> *baseInfoArr;
//身份证认证
@property (nonatomic, strong) NSArray <BaseInfoModel *> *idAuthArr;
//通讯录认证
//运营商认证
//芝麻信用分
//行业关注清单
//欺诈认证
//同盾认证

@end

@interface BaseInfoModel: NSObject

//title
@property (nonatomic, copy) NSString *title;
//content
@property (nonatomic, copy) NSString *content;
//photo
@property (nonatomic, copy) NSString *photo;

@end

