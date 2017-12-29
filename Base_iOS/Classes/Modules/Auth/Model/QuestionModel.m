//
//  QuestionModel.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/12/25.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "QuestionModel.h"

#import <MJExtension.h>

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

- (void)setF1:(NSString *)F1 {
    
    _F1 = F1;
 
    self.f1Model = (F1Model *)[self convertModelFromJsonWithModel:@"F1Model" json:_F1];

}

- (void)setF2:(NSString *)F2 {
    
    _F2 = F2;
    
    self.f2Model = (F2Model *)[self convertModelFromJsonWithModel:@"F2Model" json:_F2];
}

//将json转为model
- (BaseModel *)convertModelFromJsonWithModel:(NSString *)model json:(NSString *)json {
    
    [json stringByReplacingOccurrencesOfString:@"\"" withString:@"\""];
    NSLog(@"", json);
    //1.NSString->NSData
    NSData *data = [json dataUsingEncoding:NSUTF8StringEncoding];
    
    //2.NSData->NSDictionary
    NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    
    return [NSClassFromString(model) mj_objectWithKeyValues:jsonObject];
}

@end

@implementation PortModel

@end

@implementation F1Model

@end

@implementation F2Model

@end
