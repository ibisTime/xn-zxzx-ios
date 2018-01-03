//
//  ReportModel.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/12/29.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "BaseModel.h"

#import "QuestionModel.h"

FOUNDATION_EXTERN NSString *const kF1;
FOUNDATION_EXTERN NSString *const kF2;
FOUNDATION_EXTERN NSString *const kF3;
FOUNDATION_EXTERN NSString *const kPID1;
FOUNDATION_EXTERN NSString *const kPDW2;
FOUNDATION_EXTERN NSString *const kPTXL3;
FOUNDATION_EXTERN NSString *const kPYYS4;
FOUNDATION_EXTERN NSString *const kPZM5;
FOUNDATION_EXTERN NSString *const kPZM6;
FOUNDATION_EXTERN NSString *const kPZM7;
FOUNDATION_EXTERN NSString *const kPTD8;


@class PortModel, BaseInfoModel;

@interface ReportModel : BaseModel

@property (nonatomic, strong) QuestionModel *report;

//一级数据
@property (nonatomic, strong) NSMutableArray <PortModel *>*bigArr;

//基本信息
@property (nonatomic, strong) NSArray <BaseInfoModel *> *baseInfoArr;
//身份证认证
@property (nonatomic, strong) NSArray <BaseInfoModel *> *idAuthArr;
//定位认证
@property (nonatomic, strong) NSArray <BaseInfoModel *> *dwAuthArr;
//通讯录认证
@property (nonatomic, strong) NSArray <BaseInfoModel *> *txlAuthArr;
//运营商认证
@property (nonatomic, strong) NSArray <BaseInfoModel *> *yysAuthArr;
//芝麻信用分
@property (nonatomic, strong) NSArray <BaseInfoModel *> *zmScoreArr;
//行业关注清单
@property (nonatomic, strong) NSArray <BaseInfoModel *> *zmFoucsArr;
//欺诈认证
@property (nonatomic, strong) NSArray <BaseInfoModel *> *cheatAuthArr;
//同盾认证
@property (nonatomic, strong) NSArray <BaseInfoModel *> *tdAuthArr;


//根据认证种类获取数据
- (NSArray<BaseInfoModel *> *)getDataWithTitle:(NSString *)title;

@end

//大模型
@interface PortModel : NSObject
//认证代号
@property (nonatomic, copy) NSString *authCode;
//认证名称
@property (nonatomic, copy) NSString *authName;
//折叠等级(0:一级, 1:二级)
@property (nonatomic, assign) NSInteger level;
//是否折叠
@property (nonatomic, assign) BOOL isFold;
//是否身份证认证
@property (nonatomic, assign) BOOL isIDAuth;
//二级数据
@property (nonatomic, strong) NSArray <BaseInfoModel *> *dataArr;

@end
//具体内容
@interface BaseInfoModel: NSObject

//title
@property (nonatomic, copy) NSString *title;
//content
@property (nonatomic, copy) NSString *content;
//photo
@property (nonatomic, copy) NSString *photo;
//cellHeight
@property (nonatomic, assign) CGFloat cellHeight;

@end

