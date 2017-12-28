//
//  QuestionModel.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/12/25.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "QuestionModel.h"

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

@end
