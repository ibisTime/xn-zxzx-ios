//
//  QuestionModel.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/12/25.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "QuestionModel.h"

#import <MJExtension.h>
#import "NSString+Check.h"

@implementation QuestionModel

- (NSString *)statusStr {
    
    NSDictionary *dict = @{
                           @"0": @"待填写",
                           @"1": @"填写中",
                           @"2": @"已完成",
                           @"3": @"已过期",
                           };
    
    return dict[self.status];
    
    
}

/**
 手机号认证
 */
- (void)setF1:(NSString *)F1 {
    
    _F1 = F1;
 
    self.f1Model = (F1Model *)[self convertModelFromJsonWithModel:@"F1Model" json:_F1];

}
/**
 芝麻认证
 */
- (void)setF2:(NSString *)F2 {
    
    _F2 = F2;
    
    self.f2Model = (F2Model *)[self convertModelFromJsonWithModel:@"F2Model" json:_F2];
}
/**
 基础信息认证
 */
- (void)setF3:(NSString *)F3 {
    
    _F3 = F3;
    
    self.f3Model = (F3Model *)[self convertModelFromJsonWithModel:@"F3Model" json:_F3];
}
/**
 身份证认证
 */
- (void)setPID1:(NSString *)PID1 {
    
    _PID1 = PID1;
    
    self.pID1Model = (PID1Model *)[self convertModelFromJsonWithModel:@"PID1Model" json:_PID1];
}
/**
 定位认证
 */
- (void)setPDW2:(NSString *)PDW2 {
    
    _PDW2 = PDW2;
    
    self.pDW2Model = (PDW2Model *)[self convertModelFromJsonWithModel:@"PDW2Model" json:_PDW2];
}
/**
 通讯录认证
 */
- (void)setPTXL3:(NSString *)PTXL3 {
    
    _PTXL3 = PTXL3;
    
    self.pTXL3Model = [PTXL3Model new];
    
    self.pTXL3Model.txlArray = [self convertModelArrayFromJsonWithModel:@"TXLModel" json:_PTXL3];
}
/**
 运营商认证
 */
- (void)setPYYS4:(NSString *)PYYS4 {
    
    _PYYS4 = PYYS4;
    
    if ([_PYYS4 containsString:@"travel_tr"]) {
        
        NSLog(@"YYS数据\n%@", _PYYS4);
    }
    self.pYYS4Model = (PYYS4Model *)[self convertModelFromJsonWithModel:@"PYYS4Model" json:_PYYS4];

}
/**
 芝麻信用分
 */
- (void)setPZM5:(NSString *)PZM5 {
    
    _PZM5 = PZM5;
    
    self.pZM5Model = (PZM5Model *)[self convertModelFromJsonWithModel:@"PZM5Model" json:_PZM5];
}
/**
 行业关注名单
 */
- (void)setPZM6:(NSString *)PZM6 {
    
    _PZM6 = PZM6;
    
    //1.NSString->NSData
    NSData *data = [_PZM6 dataUsingEncoding:NSUTF8StringEncoding];
    
    //2.NSData->NSDictionary
    NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    
    self.pZM6Model = [PZM6Model new];
    
    self.pZM6Model.isMatched = jsonObject[@"isMatched"];
    
    if (jsonObject[@"detail"] != nil) {
        
        self.pZM6Model.details = [ZM6Detail mj_objectArrayWithKeyValuesArray:jsonObject[@"detail"]];

    }

}
/**
 欺诈认证
 */
- (void)setPZM7:(NSString *)PZM7 {
    
    _PZM7 = PZM7;
    
    self.pZM7Model = (PZM7Model *)[self convertModelFromJsonWithModel:@"PZM7Model" json:_PZM7];
}
/**
 同盾认证
 */
- (void)setPTD8:(NSString *)PTD8 {
    
    _PTD8 = PTD8;
    
    //1.NSString->NSData
    NSData *data = [_PTD8 dataUsingEncoding:NSUTF8StringEncoding];
    
    //2.NSData->NSDictionary
    NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    
    self.pTD8Model = (PTD8Model *)[self convertModelFromJsonWithModel:@"PTD8Model" json:jsonObject[@"tdData"]];
    
}
//将json转为model
- (BaseModel *)convertModelFromJsonWithModel:(NSString *)model json:(NSString *)json {
    
    if (json == nil) {
        
        return nil;
    }
    
//    NSString *str = [json stringByReplacingOccurrencesOfString:@"1" withString:@"6"];
//    NSLog(@"%@", str);
    //1.NSString->NSData
    NSData *data = [json dataUsingEncoding:NSUTF8StringEncoding];
    
    //2.NSData->NSDictionary
    NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    
    if (jsonObject == nil) {
        
        return nil;
    }
    return [NSClassFromString(model) mj_objectWithKeyValues:jsonObject];

}

//将json转为model数组
- (NSArray *)convertModelArrayFromJsonWithModel:(NSString *)model json:(NSString *)json {
    
    if (json == nil) {
        
        return nil;
    }
    
    //1.NSString->NSData
    NSData *data = [json dataUsingEncoding:NSUTF8StringEncoding];
    
    //2.NSData->NSDictionary
    NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    
    if (jsonObject == nil) {
        
        return nil;
    }
    return [NSClassFromString(model) mj_objectArrayWithKeyValuesArray:jsonObject];
    
}

@end

@implementation F1Model

@end

@implementation F2Model

@end

@implementation F3Model

@end

@implementation PID1Model

@end

@implementation PDW2Model

@end

@implementation PTXL3Model

+ (NSDictionary *)objectClassInArray {
    
    return @{@"txlArray" : [TXLModel class]};
}

@end

@implementation TXLModel

@end

@implementation PYYS4Model

@end

@implementation UserInfo

@end

@implementation MobileInfo

@end

@implementation InfoMatch

@end

@implementation InfoCheck

@end

@implementation EmergencyContactDetail

- (NSString *)contact_relation {
    
    NSDictionary *dict = @{
                           @"FATHER"         : @"父亲",
                           @"MOTHER"         : @"母亲",
                           @"SPOUSE"         : @"配偶",
                           @"CHILD"          : @"子女",
                           @"OTHER_RELATIVE" : @"其他亲属",
                           @"FRIEND"         : @"朋友",
                           @"COWORKER"       : @"同事",
                           @"OTHERS"         : @"其他",
                           };
    
    return dict[_contact_relation];
}

- (NSString *)contact_area {
    
    return _contact_area == nil || _contact_area.length == 0 ? @"无": _contact_area;
}
@end

@implementation PZM5Model

@end

@implementation PZM6Model

+ (NSDictionary *)objectClassInArray {
    
    return @{@"details" : [ZM6Detail class]};
}

@end

@implementation ZM6Detail

+ (NSDictionary *)objectClassInArray {
    
    return @{@"extendInfo" : [ZM6ExtendInfo class]};
}

@end


@implementation ZM6ExtendInfo

+ (NSString *)mj_replacedKeyFromPropertyName121:(NSString *)propertyName {
    
    if ([propertyName isEqualToString:@"desc"]) {
        
        return @"description";
    }
    
    return propertyName;
}

- (NSString *)convertStr {
    
    NSDictionary *titleDict = @{
                                  @"event_max_amt_code":    @"历史最大逾期金额",
                                  @"event_end_time_desc":   @"违约时间",
                                  };
    
    NSDictionary * contentDict = @{
                           @"M01": @"0~500",
                           @"M02": @"500~1000",
                           @"M03": @"1000~2000",
                           @"M04": @"2000~3000",
                           @"M05": @"3000~4000",
                           @"M06": @"4000~6000",
                           @"M07": @"6000~8000",
                           @"M08": @"8000~10000",
                           };
    
    NSString *title = titleDict[self.key];
    
    NSString *content = self.value;
    
    if ([self.key isEqualToString:@"event_max_amt_code"]) {
        
        content = contentDict[self.value];
    }
    
    if ([title valid] && [content valid]) {
        
        NSString *string = [NSString stringWithFormat:@"\n%@:%@", title, content];
        
        return string;
    }
    
    return @"";
    
}

- (NSString *)specialConvertStr {
    
    NSString *content = self.value;

    if ([content valid]) {
        
        NSString *string = [NSString stringWithFormat:@"\n%@", content];
        
        return string;
    }
    
    return @"";
}

@end

@implementation PZM7Model

@end

@implementation PTD8Model

+ (NSDictionary *)objectClassInArray {
    
    return @{@"risk_items" : [RiskItems class]};
}

- (NSString *)final_decision {
    
    NSDictionary *dict = @{
                                @"Accept": @"申请用户未检出高危风险，建议通过",
                                @"Review": @"申请用户存在较大风险，建议进行人工审核",
                                @"Reject": @"申请用户检测出高危风险，建议拒绝",
                                };
    
    return dict[_final_decision];
    
}
    
@end

@implementation AddressDetect

@end


@implementation RiskItems

@end


@implementation ItemDetail

+ (NSDictionary *)objectClassInArray {
    
    return @{@"frequency_detail_list" : [FrequencyDetailList class]};
}

@end


@implementation FrequencyDetailList

@end

