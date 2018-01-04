//
//  QuestionModel.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/12/25.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "BaseModel.h"

#import "KeyValueModel.h"

#import <UIKit/UIKit.h>

@class F1Model, F2Model, F3Model, PID1Model, PDW2Model, PTXL3Model, PYYS4Model, PZM5Model, PZM6Model, PZM7Model, PTD8Model, TXLModel, ZM6Detail, ZM6ExtendInfo, UserInfo, MobileInfo, InfoMatch, InfoCheck, EmergencyContactDetail, AddressDetect,RiskItems,ItemDetail,FrequencyDetailList;

@interface QuestionModel : BaseModel
//手机号认证
@property (nonatomic, copy) NSString *F1;
@property (nonatomic, strong) F1Model *f1Model;
//芝麻认证
@property (nonatomic, copy) NSString *F2;
@property (nonatomic, strong) F2Model *f2Model;
//基本信息认证
@property (nonatomic, copy) NSString *F3;
@property (nonatomic, strong) F3Model *f3Model;
//身份证认证
@property (nonatomic, copy) NSString *PID1;
@property (nonatomic, strong) PID1Model *pID1Model;
//定位认证
@property (nonatomic, copy) NSString *PDW2;
@property (nonatomic, strong) PDW2Model *pDW2Model;
//通讯录认证
@property (nonatomic, copy) NSString *PTXL3;
@property (nonatomic, strong) PTXL3Model *pTXL3Model;
//运营商认证
@property (nonatomic, copy) NSString *PYYS4;
@property (nonatomic, strong) PYYS4Model *pYYS4Model;
//芝麻信用评分认证
@property (nonatomic, copy) NSString *PZM5;
@property (nonatomic, strong) PZM5Model *pZM5Model;
//行业关注清单认证
@property (nonatomic, copy) NSString *PZM6;
@property (nonatomic, strong) PZM6Model *pZM6Model;
//欺诈认证
@property (nonatomic, copy) NSString *PZM7;
@property (nonatomic, strong) PZM7Model *pZM7Model;
//同盾认证
@property (nonatomic, copy) NSString *PTD8;
@property (nonatomic, strong) PTD8Model *pTD8Model;
//调查单code
@property (nonatomic, copy) NSString *code;
//借款员UserID
@property (nonatomic, copy) NSString *loanUser;
//资信报告code
@property (nonatomic, copy) NSString *reportCode;
//业务员
@property (nonatomic, copy) NSString *salesUserMobile;
//认证列表
@property (nonatomic, strong) NSString *portList;

//运营商认证状态
@property (nonatomic, copy) NSString *PYYS4Status;
//问卷状态
@property (nonatomic, copy) NSString *status;
//状态转义
@property (nonatomic, copy) NSString *statusStr;
//cellHeight
@property (nonatomic, assign) CGFloat cellHeight;

@property (nonatomic, assign) NSInteger remainCount;

@property (nonatomic, copy) NSString *createDatetime;

@property (nonatomic, copy) NSString *salesUser;

//学历
@property (nonatomic, strong) NSArray <KeyValueModel *>*edcationArr;
//居住年限
@property (nonatomic, strong) NSMutableArray <KeyValueModel *>*timeArr;
//婚姻状况
@property (nonatomic, strong) NSMutableArray <KeyValueModel *>*marriageArr;
//职业
@property (nonatomic, strong) NSMutableArray <KeyValueModel *>*jobArr;
//收入
@property (nonatomic, strong) NSMutableArray <KeyValueModel *>*incomeArr;
//亲属关系
@property (nonatomic, strong) NSMutableArray <KeyValueModel *>*familyArr;
//朋友关系
@property (nonatomic, strong) NSMutableArray <KeyValueModel *>*societyArr;

@end

@interface F1Model : NSObject
//手机号
@property (nonatomic, copy) NSString *mobile;

@end

@interface F2Model : NSObject
//姓名
@property (nonatomic, copy) NSString *realName;
//身份证号码
@property (nonatomic, copy) NSString *idNo;

@end

@interface F3Model : NSObject
//基本信息
//学历
@property (nonatomic, copy) NSString *education;
//婚姻
@property (nonatomic, copy) NSString *marriage;
//子女个数
@property (nonatomic, copy) NSString *childrenNum;
//居住省市
@property (nonatomic, copy) NSString *provinceCity;
//详细地址
@property (nonatomic, copy) NSString *address;
//居住时长
@property (nonatomic, copy) NSString *liveTime;
//QQ
@property (nonatomic, copy) NSString *qq;
//电子邮箱
@property (nonatomic, copy) NSString *email;

//职业信息
//职业
@property (nonatomic, copy) NSString *occupation;
//月收入
@property (nonatomic, copy) NSString *income;
//公司名称
@property (nonatomic, copy) NSString *company;
//公司所在省市
@property (nonatomic, copy) NSString *companyProvinceCity;
//公司详细地址
@property (nonatomic, copy) NSString *companyAddress;
//公司电话
@property (nonatomic, copy) NSString *phone;

//紧急联系人1
//亲属姓名
@property (nonatomic, copy) NSString *familyName;
//亲属手机号
@property (nonatomic, copy) NSString *familyMobile;
//亲属关系
@property (nonatomic, copy) NSString *familyRelation;
//紧急联系人2
//社会关系
@property (nonatomic, copy) NSString *societyRelation;
//社会联系人手机号
@property (nonatomic, copy) NSString *societyMobile;
//社会联系人姓名
@property (nonatomic, copy) NSString *societyName;

@end

@interface PID1Model : NSObject
//身份证正面照
@property (nonatomic, copy) NSString *identifyPic;
//身份证反面照
@property (nonatomic, copy) NSString *identifyPicReverse;
//手持身份证照
@property (nonatomic, copy) NSString *identifyPicHand;

@end

@interface PDW2Model : NSObject
//经度
@property (nonatomic, copy) NSString *longitude;
//纬度
@property (nonatomic, copy) NSString *latitude;
//省
@property (nonatomic, copy) NSString *province;
//市
@property (nonatomic, copy) NSString *city;
//区
@property (nonatomic, copy) NSString *area;
//详细地址
@property (nonatomic, copy) NSString *address;

@end

@interface PTXL3Model : NSObject

@property (nonatomic, strong) NSArray <TXLModel *> *txlArray;

@end

@interface TXLModel : NSObject
//名称
@property (nonatomic, copy) NSString *name;
//手机号
@property (nonatomic, copy) NSString *mobile;

@end

@interface PYYS4Model : NSObject
//用户信息
@property (nonatomic, strong) UserInfo *user_info;
//手机信息
@property (nonatomic, strong) MobileInfo *mobile_info;
//信息匹配
@property (nonatomic, strong) InfoMatch *info_match;
//信息核对
@property (nonatomic, strong) InfoCheck *info_check;
//紧急联系人1
@property (nonatomic, strong) EmergencyContactDetail *emergency_contact1_detail;
//紧急联系人2
@property (nonatomic, strong) EmergencyContactDetail *emergency_contact2_detail;
//紧急联系人3
@property (nonatomic, strong) EmergencyContactDetail *emergency_contact3_detail;
//紧急联系人4
@property (nonatomic, strong) EmergencyContactDetail *emergency_contact4_detail;
//紧急联系人5
@property (nonatomic, strong) EmergencyContactDetail *emergency_contact5_detail;

@end

@interface UserInfo : NSObject

//真实姓名
@property (nonatomic, copy) NSString *real_name;
//年龄
@property (nonatomic, copy) NSString *age;
//工作地址
@property (nonatomic, copy) NSString *work_addr;
//公司名称
@property (nonatomic, copy) NSString *company_name;
//家里地址
@property (nonatomic, copy) NSString *home_addr;
//身份证号码
@property (nonatomic, copy) NSString *identity_code;
//家乡
@property (nonatomic, copy) NSString *hometown;
//星座
@property (nonatomic, copy) NSString *constellation;
//工作电话
@property (nonatomic, copy) NSString *work_tel;
//邮箱
@property (nonatomic, copy) NSString *email;
//性别
@property (nonatomic, copy) NSString *gender;
//家里电话
@property (nonatomic, copy) NSString *home_tel;

@end

@interface MobileInfo : NSObject

@property (nonatomic, copy) NSString *mobile_net_time;
//运营商登记姓名
@property (nonatomic, copy) NSString *real_name;

@property (nonatomic, copy) NSString *mobile_net_addr;

@property (nonatomic, copy) NSString *account_balance;

@property (nonatomic, copy) NSString *account_status;
//手机号码
@property (nonatomic, copy) NSString *user_mobile;

@property (nonatomic, copy) NSString *package_type;

@property (nonatomic, copy) NSString *mobile_carrier;

@property (nonatomic, copy) NSString *identity_code;

@property (nonatomic, copy) NSString *contact_addr;

@property (nonatomic, copy) NSString *mobile_net_age;

@property (nonatomic, copy) NSString *email;

@end

@interface InfoMatch : NSObject
//身份证匹配
@property (nonatomic, copy) NSString *identity_code_check_yys;
//家庭地址匹配
@property (nonatomic, copy) NSString *home_addr_check_yys;
//姓名匹配
@property (nonatomic, copy) NSString *real_name_check_yys;
//邮件匹配
@property (nonatomic, copy) NSString *email_check_yys;

@end

@interface InfoCheck : NSObject

//是否实名(是/否)
@property (nonatomic, copy) NSString *is_identity_code_reliable;
//近一个月常用通话地是否与归属地一致
@property (nonatomic, copy) NSString *is_net_addr_call_addr_1month;
@end

@interface EmergencyContactDetail : NSObject

//联系人手机号
@property (nonatomic, copy) NSString *contact_number;
//与用户的关系
@property (nonatomic, copy) NSString *contact_relation;
//归属地
@property (nonatomic, copy) NSString *contact_area;

@end

@interface PZM5Model : NSObject
//芝麻信用分
@property (nonatomic, copy) NSString *zmScore;

@end

@interface PZM6Model : NSObject
//是否被关注
@property (nonatomic, strong) NSNumber *isMatched;
//违纪记录
@property (nonatomic, strong) NSArray<ZM6Detail *> *details;

@end

@interface ZM6Detail : NSObject

@property (nonatomic, assign) BOOL settlement;

@property (nonatomic, strong) NSArray<ZM6ExtendInfo *> *extendInfo;

@property (nonatomic, copy) NSString *code;

@property (nonatomic, copy) NSString *bizCode;

@property (nonatomic, assign) NSInteger level;

@property (nonatomic, copy) NSString *refreshTime;

@property (nonatomic, copy) NSString *type;

@end

@interface ZM6ExtendInfo : NSObject

@property (nonatomic, copy) NSString *key;

@property (nonatomic, copy) NSString *value;

@property (nonatomic, copy) NSString *desc;
//转义
@property (nonatomic, copy) NSString *convertStr;
//特殊转义
@property (nonatomic, copy) NSString *specialConvertStr;

@end

@interface PZM7Model : NSObject

@property (nonatomic, assign) NSInteger score;

@property (nonatomic, strong) NSArray<NSString *> *verifyInfoList;

@property (nonatomic, copy) NSString *hit;

@end

@interface PTD8Model : NSObject

@property (nonatomic, copy) NSString *report_id;

@property (nonatomic, copy) NSString *application_id;

@property (nonatomic, assign) NSInteger final_score;

@property (nonatomic, strong) NSArray<RiskItems *> *risk_items;

@property (nonatomic, strong) AddressDetect *address_detect;

@property (nonatomic, assign) long long report_time;

@property (nonatomic, assign) BOOL success;

@property (nonatomic, copy) NSString *final_decision;

@property (nonatomic, assign) long long apply_time;

@end

@interface AddressDetect : NSObject

@property (nonatomic, copy) NSString *id_card_address;

@property (nonatomic, copy) NSString *mobile_address;

@end

@interface RiskItems : NSObject

@property (nonatomic, strong) ItemDetail *item_detail;

@property (nonatomic, copy) NSString *group;

@property (nonatomic, copy) NSString *item_name;

@property (nonatomic, copy) NSString *risk_level;

@property (nonatomic, assign) NSInteger item_id;

@end

@interface ItemDetail : NSObject

@property (nonatomic, copy) NSString *type;

@property (nonatomic, strong) NSArray<FrequencyDetailList *> *frequency_detail_list;

@end

@interface FrequencyDetailList : NSObject

@property (nonatomic, copy) NSString *detail;

@end
