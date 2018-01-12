//
//  PedestrianManager.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/1/12.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "PedestrianManager.h"

@implementation PedestrianManager

/**
 0:未申请  1:申请中 2:申请失败

 @return 提示语
 */
- (NSString *)reportPromptStr {
    
    NSDictionary *dict = @{
                           @"0": @"您目前没有可供查看的报告，请进行认证后再进行查看。",
                           @"1": @"您的信用信息查询请求已提交，请在24小时后访问平台获取结果。为保障您的信息安全，您申请的信用信息将于7日后自动清理，请及时获取查询结果。",
                           @"2": @"很抱歉，您提交的个人信息验证未通过，如需重新查看报告，请重新进行认证。",
                           
                           };
    
    return dict[self.reportStatus];
}

- (NSString *)reportBtnTitle {
    
    NSDictionary *dict = @{
                           @"0": @"立即认证",
                           @"1": @"我知道了",
                           @"2": @"重新认证",
                           
                           };
    
    return dict[self.reportStatus];
}

- (NSString *)idVerifyPromptStr {
    
    NSDictionary *dict = @{
                           @"success": @"验证码已发送,请注意查收",
                           @"noTradeCode": @"系统异常，请重新申请信用信息产品。",
                           
                           };
    
    return dict[self.idVerifyResult];
}

@end
