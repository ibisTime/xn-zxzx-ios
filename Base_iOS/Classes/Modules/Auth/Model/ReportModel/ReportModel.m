//
//  ReportModel.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/12/29.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "ReportModel.h"

#import "NSString+Check.h"
#import "AppMacro.h"

#import "FoucsModel.h"

#import <MJExtension/MJExtension.h>

NSString *const kF1     = @"F1";
NSString *const kF2     = @"F2";
NSString *const kF3     = @"F3";
NSString *const kPID1   = @"PID1";
NSString *const kPDW2   = @"PDW2";
NSString *const kPTXL3  = @"PTXL3";
NSString *const kPYYS4  = @"PYYS4";
NSString *const kPZM5   = @"PZM5";
NSString *const kPZM6   = @"PZM6";
NSString *const kPZM7   = @"PZM7";
NSString *const kPTD8   = @"PTD8";

@implementation ReportModel

- (NSMutableArray<PortModel *> *)bigArr {
    
    if (_bigArr != nil) {
        
        return _bigArr;
    }
    //大数组
    _bigArr = [NSMutableArray array];
    
    NSDictionary *dict = @{
                             kF1: @"手机认证",
                             kF2: @"芝麻认证",
                             kF3: @"基本信息认证",
                           kPID1: @"身份证认证",
                           kPDW2: @"定位信息",
                          kPTXL3: @"通讯录认证",
                          kPYYS4: @"运营商认证",
                           kPZM5: @"芝麻信用分",
                           kPZM6: @"行业关注清单",
                           kPZM7: @"欺诈认证",
                           kPTD8: @"同盾认证",
                           
                           };
    
    NSArray *portArr = [self.report.portList componentsSeparatedByString:@","];
    
    [portArr enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (idx > 1) {
            
            PortModel *model = [PortModel new];
            
            model.authCode = obj;
            model.authName = dict[obj];
            model.isFold = NO;
            model.isIDAuth = [obj isEqualToString:kPID1] ? YES: NO;
            
            [_bigArr addObject:model];
        }
    }];
    
    return _bigArr;
}

/**
 二级数据
 */
- (NSArray<BaseInfoModel *> *)getDataWithTitle:(NSString *)title {
    
    //F1+F2+F3
    if ([title isEqualToString:kF3]) {
        
        return self.baseInfoArr;
    }
    //身份证认证
    if ([title isEqualToString:kPID1]) {
        
        return self.idAuthArr;
    }
    //定位信息
    if ([title isEqualToString:kPDW2]) {
        
        return self.dwAuthArr;
    }
    //通讯录认证
    if ([title isEqualToString:kPTXL3]) {
        
        return self.txlAuthArr;
    }
    //运营商认证
    if ([title isEqualToString:kPYYS4]) {
        
        return self.yysAuthArr;
    }
    //芝麻信用分
    if ([title isEqualToString:kPZM5]) {
        
        return self.zmScoreArr;
    }
    //行业关注清单
    if ([title isEqualToString:kPZM6]) {
        
        return self.zmFoucsArr;
    }
    //欺诈认证
    if ([title isEqualToString:kPZM7]) {
        
        return self.cheatAuthArr;
    }
    
    //同盾认证
    if ([title isEqualToString:kPTD8]) {
        
        return self.tdAuthArr;
    }
    
    return self.baseInfoArr;

}

#pragma mark - 基本信息认证
- (NSArray<BaseInfoModel *> *)baseInfoArr {
    
    NSMutableArray *arr = [NSMutableArray array];
    
    F1Model *f1Model = self.report.f1Model;
    F2Model *f2Model = self.report.f2Model;
    F3Model *f3Model = self.report.f3Model;
    //用户信息
    [arr addObject:[self addInfoModelWithTitle:@"用户信息" content:@"section"]];

    //姓名
    NSString *realName = [f2Model.realName valid] ? [NSString stringWithFormat:@"%@ (已认证)", f2Model.realName]: @"暂无";
    
    [arr addObject:[self addInfoModelWithTitle:@"姓名" content:realName]];
    //身份证号
    NSString *idNo = [f2Model.idNo valid] ? [NSString stringWithFormat:@"%@ (已认证)", f2Model.idNo]: @"暂无";

    [arr addObject:[self addInfoModelWithTitle:@"身份证号" content:idNo]];
    //手机号
    NSString *mobile = [NSString stringWithFormat:@"%@ (已认证)", f1Model.mobile];

    [arr addObject:[self addInfoModelWithTitle:@"手机号" content:mobile]];
    //学历
    NSString *education = [self keyValueWithArray:self.report.edcationArr key:f3Model.education];
    
    [arr addObject:[self addInfoModelWithTitle:@"学历" content:education]];
    //婚姻
    NSString *marriage = [self keyValueWithArray:self.report.marriageArr key:f3Model.marriage];

    [arr addObject:[self addInfoModelWithTitle:@"婚姻" content:marriage]];
    //子女个数
    [arr addObject:[self addInfoModelWithTitle:@"子女个数" content:f3Model.childrenNum]];
    //居住省市
    [arr addObject:[self addInfoModelWithTitle:@"居住省市" content:f3Model.provinceCity]];
    //详细地址
    [arr addObject:[self addInfoModelWithTitle:@"详细地址" content:f3Model.address]];
    //居住时长
    NSString *liveTime = [self keyValueWithArray:self.report.timeArr key:f3Model.liveTime];

    [arr addObject:[self addInfoModelWithTitle:@"居住时长" content:liveTime]];
    //QQ
    [arr addObject:[self addInfoModelWithTitle:@"QQ" content:f3Model.qq]];
    //电子邮箱
    [arr addObject:[self addInfoModelWithTitle:@"电子邮箱" content:f3Model.email]];
    //职业信息
    [arr addObject:[self addInfoModelWithTitle:@"职业信息" content:@"section"]];
    //职业
    NSString *occupation = [self keyValueWithArray:self.report.jobArr key:f3Model.occupation];

    [arr addObject:[self addInfoModelWithTitle:@"职业" content:occupation]];
    //月收入
    NSString *income = [self keyValueWithArray:self.report.incomeArr key:f3Model.income];

    [arr addObject:[self addInfoModelWithTitle:@"月收入" content:income]];
    //单位名称
    [arr addObject:[self addInfoModelWithTitle:@"单位名称" content:f3Model.company]];
    //所在省市
    [arr addObject:[self addInfoModelWithTitle:@"单位省市" content:f3Model.companyProvinceCity]];
    //详细地址
    [arr addObject:[self addInfoModelWithTitle:@"单位地址" content:f3Model.companyAddress]];
    //单位电话
    [arr addObject:[self addInfoModelWithTitle:@"单位电话" content:f3Model.phone]];
    
    //紧急联系人信息
    [arr addObject:[self addInfoModelWithTitle:@"紧急联系人信息" content:@"section"]];
    //亲属关系
    NSString *familyRelation = [self keyValueWithArray:self.report.familyArr key:f3Model.familyRelation];

    [arr addObject:[self addInfoModelWithTitle:@"亲属关系" content:familyRelation]];
    //姓名
    [arr addObject:[self addInfoModelWithTitle:@"姓名" content:f3Model.familyName]];
    //联系方式
    [arr addObject:[self addInfoModelWithTitle:@"联系方式" content:f3Model.familyMobile]];
    //社会关系
    NSString *societyRelation = [self keyValueWithArray:self.report.societyArr key:f3Model.societyRelation];

    [arr addObject:[self addInfoModelWithTitle:@"社会关系" content:societyRelation]];
    //姓名
    [arr addObject:[self addInfoModelWithTitle:@"姓名" content:f3Model.societyName]];
    //联系方式
    [arr addObject:[self addInfoModelWithTitle:@"联系方式" content:f3Model.societyMobile]];
    
    return arr.copy;
}

#pragma mark - 身份证认证
- (NSArray<BaseInfoModel *> *)idAuthArr {
    
    NSMutableArray *arr = [NSMutableArray array];

    PID1Model *pid1Model = self.report.pID1Model;
    
    //身份证正面照
    [arr addObject:[self addInfoModelWithTitle:@"身份证正面照" content:pid1Model.identifyPic]];
    //身份证反面照
    [arr addObject:[self addInfoModelWithTitle:@"身份证反面照" content:pid1Model.identifyPicReverse]];
    //手持身份证照
    [arr addObject:[self addInfoModelWithTitle:@"身份证手持照" content:pid1Model.identifyPicHand]];

    return arr.copy;
}

#pragma mark - 定位认证
- (NSArray<BaseInfoModel *> *)dwAuthArr {
    
    NSMutableArray *arr = [NSMutableArray array];
    
    PDW2Model *pdw2Model = self.report.pDW2Model;
    
    if (pdw2Model == nil) {
        
        [arr addObject:[self addInfoModelWithTitle:@"暂无定位信息数据" content:@"无"]];

        return arr;
    }
    
    //省市区
    STRING_NIL_NULL(pdw2Model.province);
    STRING_NIL_NULL(pdw2Model.city);
    STRING_NIL_NULL(pdw2Model.area);

    NSString *provinceCity = pdw2Model == nil ? @"": [NSString stringWithFormat:@"%@ %@ %@", pdw2Model.province, pdw2Model.city, pdw2Model.area];
    [arr addObject:[self addInfoModelWithTitle:@"省市区" content:provinceCity]];
    //详细地址
    [arr addObject:[self addInfoModelWithTitle:@"详细地址" content:pdw2Model.address]];
    //经度
    [arr addObject:[self addInfoModelWithTitle:@"经度" content:pdw2Model.longitude]];
    //纬度
    [arr addObject:[self addInfoModelWithTitle:@"纬度" content:pdw2Model.latitude]];
    
    return arr;

}

#pragma mark - 通讯录认证
- (NSArray<BaseInfoModel *> *)txlAuthArr {
    
    NSMutableArray *arr = [NSMutableArray array];
    
    PTXL3Model *ptxl3Model = self.report.pTXL3Model;

    if (ptxl3Model == nil) {
        
        [arr addObject:[self addInfoModelWithTitle:@"暂无通讯录数据" content:@"无"]];
        
        return arr;
    }
    
    [ptxl3Model.txlArray enumerateObjectsUsingBlock:^(TXLModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [arr addObject:[self addInfoModelWithTitle:obj.name content:obj.mobile]];

    }];
    
    return arr;
}

#pragma mark - 运营商认证
- (NSArray<BaseInfoModel *> *)yysAuthArr {
    
    NSMutableArray *arr = [NSMutableArray array];
    
    PYYS4Model *pYYS4Model = self.report.pYYS4Model;
    //用户信息
    UserInfo *userInfo = pYYS4Model.user_info;
    //手机信息
    MobileInfo *mobileInfo = pYYS4Model.mobile_info;
    //数据匹配
    InfoMatch *infoMatch = pYYS4Model.info_match;
    //信息核对
    InfoCheck *infoCheck = pYYS4Model.info_check;
    //紧急联系人1
    EmergencyContactDetail *contact1 = pYYS4Model.emergency_contact1_detail;
    //紧急联系人2
    EmergencyContactDetail *contact2 = pYYS4Model.emergency_contact2_detail;
    //紧急联系人3
    EmergencyContactDetail *contact3 = pYYS4Model.emergency_contact3_detail;
    //紧急联系人4
    EmergencyContactDetail *contact4 = pYYS4Model.emergency_contact4_detail;
    //紧急联系人5
    EmergencyContactDetail *contact5 = pYYS4Model.emergency_contact5_detail;
    
    if (pYYS4Model == nil) {
        
        [arr addObject:[self addInfoModelWithTitle:@"暂无运营商数据" content:@"无"]];
        
        return arr;
    }
    
    //用户信息
    [arr addObject:[self addInfoModelWithTitle:@"用户信息" content:@"section"]];

    //姓名
    [arr addObject:[self addInfoModelWithTitle:@"姓名" content:userInfo.real_name]];
    //运营商登记姓名
    NSString *loginName = [NSString stringWithFormat:@"运营商登记姓名: %@", mobileInfo.real_name];
    [arr addObject:[self addInfoModelWithTitle:loginName content:@"无"]];

    //数据匹配
    [arr addObject:[self addInfoModelWithTitle:[NSString stringWithFormat:@"姓名和运营商数据%@", infoMatch.real_name_check_yys] content:@"无"]];
    //身份证
    [arr addObject:[self addInfoModelWithTitle:@"身份证" content:userInfo.identity_code]];
    //性别
    [arr addObject:[self addInfoModelWithTitle:@"性别" content:userInfo.gender]];
    //年龄
    [arr addObject:[self addInfoModelWithTitle:@"年龄" content:userInfo.age]];
    //家庭地址
    [arr addObject:[self addInfoModelWithTitle:@"家庭地址" content:userInfo.home_addr]];
    //家庭电话
    [arr addObject:[self addInfoModelWithTitle:@"家庭电话" content:userInfo.home_tel]];
    //工作单位
    [arr addObject:[self addInfoModelWithTitle:@"工作单位" content:userInfo.company_name]];
    //工作地址
    [arr addObject:[self addInfoModelWithTitle:@"工作地址" content:userInfo.work_addr]];
    //单位电话
    [arr addObject:[self addInfoModelWithTitle:@"单位电话" content:userInfo.work_tel]];
    //邮箱
    [arr addObject:[self addInfoModelWithTitle:@"电子邮箱" content:userInfo.email]];
    
    //手机信息
    [arr addObject:[self addInfoModelWithTitle:@"手机信息" content:@"section"]];
    //手机号码
    //实名认证
    NSString *isReal = [infoCheck.is_identity_code_reliable isEqualToString:@"是"] ? @"(已实名)": @"";
    NSString *mobile = [NSString stringWithFormat:@"%@ %@", mobileInfo.user_mobile, isReal];
    [arr addObject:[self addInfoModelWithTitle:@"手机号码" content:mobile]];

    //手机归属地
    [arr addObject:[self addInfoModelWithTitle:@"手机归属地" content:mobileInfo.mobile_net_addr]];

    //常用通话地址
    if ([infoCheck.is_net_addr_call_addr_1month isEqualToString:@"否"]) {
        
        NSString *callAddr = @"与常用通话地不一致";
        
        [arr addObject:[self addInfoModelWithTitle:callAddr content:@"无"]];
        
    }
    //运营商
    [arr addObject:[self addInfoModelWithTitle:@"运营商" content:mobileInfo.mobile_carrier]];
    //账号状态
    [arr addObject:[self addInfoModelWithTitle:@"账号状态" content:mobileInfo.account_status]];
    //账户余额
    CGFloat balance = [mobileInfo.account_balance doubleValue]/100.0;
    
    NSString *accountBalance = [NSString stringWithFormat:@"%.2lf", balance];
    
    [arr addObject:[self addInfoModelWithTitle:@"账户余额" content:accountBalance]];
    //入网时间
    [arr addObject:[self addInfoModelWithTitle:@"入网时间" content:mobileInfo.mobile_net_time]];

    //紧急联系人
    [arr addObject:[self addInfoModelWithTitle:@"紧急联系人信息" content:@"section"]];
    
    BaseInfoModel *contactModel = [self getContactModelWithMobile:@"联系方式" relation:@"关系" contactArea:@"归属地"];
    
    [arr addObject:contactModel];
    
    if (contact1) {
        
        BaseInfoModel *contactModel1 = [self getContactModelWithMobile:contact1.contact_number relation:contact1.contact_relation contactArea:contact1.contact_area];

        [arr addObject:contactModel1];
        
    }
    
    if (contact2) {
        
        BaseInfoModel *contactModel2 = [self getContactModelWithMobile:contact2.contact_number relation:contact2.contact_relation contactArea:contact2.contact_area];
        
        [arr addObject:contactModel2];
    }
    
    if (contact3) {
        
        BaseInfoModel *contactModel3 = [self getContactModelWithMobile:contact3.contact_number relation:contact3.contact_relation contactArea:contact3.contact_area];
        
        [arr addObject:contactModel3];
    }
    
    if (contact4) {
        
        BaseInfoModel *contactModel4 = [self getContactModelWithMobile:contact4.contact_number relation:contact4.contact_relation contactArea:contact4.contact_area];
        
        [arr addObject:contactModel4];
    }
    
    if (contact5) {
        
        BaseInfoModel *contactModel5 = [self getContactModelWithMobile:contact5.contact_number relation:contact5.contact_relation contactArea:contact5.contact_area];
        
        [arr addObject:contactModel5];
    }
    
    return arr;
}

#pragma mark - 芝麻信用分
- (NSArray<BaseInfoModel *> *)zmScoreArr {
    
    NSMutableArray *arr = [NSMutableArray array];
    
    PZM5Model *pzm5Model = self.report.pZM5Model;
    
    if (pzm5Model == nil) {
        
        [arr addObject:[self addInfoModelWithTitle:@"暂无芝麻信用分数据" content:@"无"]];
        
        return arr;
    }
    
    //芝麻分
    [arr addObject:[self addInfoModelWithTitle:@"芝麻信用分" content:pzm5Model.zmScore]];
    
    return arr;
}

#pragma mark - 行业关注清单
- (NSArray<BaseInfoModel *> *)zmFoucsArr {
    
    NSMutableArray *arr = [NSMutableArray array];
    
    PZM6Model *pzm6Model = self.report.pZM6Model;
    
    if (pzm6Model == nil) {
        
        [arr addObject:[self addInfoModelWithTitle:@"暂无行业关注数据" content:@"无"]];
        
        return arr;
    }
    
    if (![pzm6Model.isMatched boolValue]) {
        
        NSString *isMatched = @"未被行业关注";
        
        [arr addObject:[self addInfoModelWithTitle:isMatched content:@"无"]];
        
        return arr;
    }
    
    NSError *error;
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"local_focus_on" ofType:@"txt"];
    
    NSString *json = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
    
    if (error) {
        
        return arr;
    }
    
    FoucsModel *foucsModel = [FoucsModel new];
    
    foucsModel.infoArray = [ZMInfoArray mj_objectArrayWithKeyValuesArray:json];
    
    if (pzm6Model.details == nil || pzm6Model.details.count == 0) {
        
        return arr;
    }
    
    [pzm6Model.details enumerateObjectsUsingBlock:^(ZM6Detail * _Nonnull detail, NSUInteger idx, BOOL * _Nonnull stop) {
        
        //行业类型
        __block NSString *tradeType;
        //风险类型
        __block NSString *riskType;
        //风险内容
        __block NSString *riskTitle;
        __block NSString *riskContent;
        //额外信息
//        __block NSString *extendInfo;
        //匹配bizCode
        [foucsModel.infoArray enumerateObjectsUsingBlock:^(ZMInfoArray * _Nonnull infoArray, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if ([detail.bizCode isEqualToString:infoArray.bizCode]) {
                
                tradeType = infoArray.bizName;
            }
            
            ZMType *zmType = infoArray.type;
            //遍历风险类型
            [zmType.typeCodeInfo enumerateObjectsUsingBlock:^(ZMTypeCodeInfo * _Nonnull typeCodeInfo, NSUInteger idx, BOOL * _Nonnull stop) {
                
                if ([detail.type isEqualToString:typeCodeInfo.code]) {
                    
                    riskType = typeCodeInfo.value;
                }
                //遍历风险内容
                ZMCodeList *zmCodeList = typeCodeInfo.codeList;
                
                riskTitle = zmCodeList.name;

                [zmCodeList.codeList enumerateObjectsUsingBlock:^(ZMCodeInfo * _Nonnull codeInfo, NSUInteger idx, BOOL * _Nonnull stop) {
                    
                    if ([detail.code isEqualToString:codeInfo.code]) {
                        
                        riskContent = codeInfo.value;
                    }
                }];
            }];
            
        }];
    
        NSMutableString *content = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"%@(%@)\n%@: %@", tradeType, riskType, riskTitle, riskContent]];
        //遍历额外信息
        [detail.extendInfo enumerateObjectsUsingBlock:^(ZM6ExtendInfo * _Nonnull extendInfo, NSUInteger idx, BOOL * _Nonnull stop) {
            
            NSString *convertStr = [detail.bizCode isEqualToString:@"AB"] ? extendInfo.specialConvertStr: extendInfo.convertStr;
            
            [content appendString:convertStr];
        }];
        
        [arr addObject:[self addInfoModelWithTitle:content content:@"无"]];
    }];
    
    return arr;
}

#pragma mark - 欺诈认证
- (NSArray<BaseInfoModel *> *)cheatAuthArr {
    
    NSMutableArray *arr = [NSMutableArray array];
    
    PZM7Model *pzm7Model = self.report.pZM7Model;
    
    if (pzm7Model == nil) {
        
        [arr addObject:[self addInfoModelWithTitle:@"暂无欺诈数据" content:@"无"]];
        
        return arr;
    }
    
    //欺诈评分
    [arr addObject:[self addInfoModelWithTitle:@"欺诈评分" content:[NSString stringWithFormat:@"%ld", pzm7Model.score]]];
    //判断是否欺诈
    if (pzm7Model.verifyInfoList.count > 0) {
        
        [pzm7Model.verifyInfoList enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            [arr addObject:[self addInfoModelWithTitle:obj content:@"无"]];
        }];

        return arr;
    }

    return arr;
}

#pragma mark - 同盾认证
- (NSArray<BaseInfoModel *> *)tdAuthArr {
    
    NSMutableArray *arr = [NSMutableArray array];
    
    PTD8Model *ptd8Model = self.report.pTD8Model;
    
    if (ptd8Model == nil) {
        
        [arr addObject:[self addInfoModelWithTitle:@"暂无同盾数据" content:@"无"]];
        
        return arr;
    }

    //风险指数
    NSString *riskScore = [NSString stringWithFormat:@"%ld", ptd8Model.final_score];
    
    [arr addObject:[self addInfoModelWithTitle:@"风险指数" content:riskScore]];
    //检查风险
    
    [arr addObject:[self addInfoModelWithTitle:ptd8Model.final_decision content:@"无"]];
    //异常记录
    NSString *exceptReport = [NSString stringWithFormat:@"共发现%ld条异常信息, 详情请查看web端", ptd8Model.risk_items.count];
    
    [arr addObject:[self addInfoModelWithTitle:exceptReport content:@"无"]];

    [ptd8Model.risk_items enumerateObjectsUsingBlock:^(RiskItems * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        //异常记录信息
        NSString *report = [NSString stringWithFormat:@"%ld. %@", idx+1, obj.item_name];
        
        [arr addObject:[self addInfoModelWithTitle:report content:@"无"]];
    }];
    
    return arr;
}

- (BaseInfoModel *)addInfoModelWithTitle:(NSString *)title content:(NSString *)content {
    
    BaseInfoModel *infoModel = [BaseInfoModel new];
    
    infoModel.title = title;
    infoModel.content = ![content valid] ? @"暂无": [content isEqualToString:@"无"] ? @"": content;
    
    return infoModel;
    
}

- (NSString *)keyValueWithArray:(NSArray *)array key:(NSString *)key {
    
    __block NSString *value = @"";
    
    [array enumerateObjectsUsingBlock:^(KeyValueModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([obj.dkey isEqualToString:key]) {
            
            value = obj.dvalue;
        }
    }];
    
    return value;
}

//获取联系人model
- (BaseInfoModel *)getContactModelWithMobile:(NSString *)mobile relation:(NSString *)relation contactArea:(NSString *)contactArea {
    
    
    NSString *title = [NSString stringWithFormat:@"%@|%@|%@", mobile, relation, contactArea];
    
    BaseInfoModel *contactModel = [self addInfoModelWithTitle:title content:@"无"];
    
    contactModel.isEMContact = YES;
    
    return contactModel;
}

@end

@implementation PortModel

@end

@implementation BaseInfoModel

- (CGFloat)cellHeight {
    
    NSArray *contentArr = [self.title componentsSeparatedByString:@"\n"];
    
    CGFloat height = 30 + 20*contentArr.count;
    
    return height;
}

@end
