//
//  PedestrianQuestionModel.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/1/15.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "PedestrianQuestionModel.h"
#import "NSString+CGSize.h"

#import "AppColorMacro.h"

@implementation PedestrianQuestionModel

- (void)setQuestion:(NSString *)question {
    
    _question = question;
    
    self.sectionHeight = [_question calculateStringSize:CGSizeMake(kScreenWidth - 30, MAXFLOAT) font:Font(16.0)].height+20;
    
    if (self.sectionHeight < 40) {
        
        self.sectionHeight = 40;
    }
}

@end

@implementation AnswerOption

- (void)setOption:(NSString *)option {
    
    _option = option;
    
    self.cellHeight = [_option calculateStringSize:CGSizeMake(kScreenWidth - 72, MAXFLOAT) font:Font(14.0)].height+20;
    
    if (self.cellHeight < 45) {
        
        self.cellHeight = 45;
    }
}

@end
