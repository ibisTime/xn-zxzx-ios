//
//  PedestrianQuestionModel.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/1/15.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BaseModel.h"

@class AnswerOption;

@interface PedestrianQuestionModel : BaseModel
//问题title
@property (nonatomic, copy) NSString *question;
//list
@property (nonatomic, strong) NSMutableArray <AnswerOption *> *optionList;
//derivativecode
@property (nonatomic, copy) NSString *derivativeCode;
//businesstype
@property (nonatomic, copy) NSString *businessType;
//questionno
@property (nonatomic, copy) NSString *questionNo;
//kbanum
@property (nonatomic, copy) NSString *kbanum;
//answerResult
@property (nonatomic, copy) NSString *answerResult;
//options
@property (nonatomic, copy) NSString *options;

@end

@interface AnswerOption : NSObject

//是否选择
@property (nonatomic, assign) BOOL select;
//回答title
@property (nonatomic, copy) NSString *option;

@end
