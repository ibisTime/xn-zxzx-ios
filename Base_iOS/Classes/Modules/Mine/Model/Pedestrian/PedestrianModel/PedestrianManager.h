//
//  PedestrianManager.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/1/12.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BaseModel.h"

@interface PedestrianManager : BaseModel
//报告状态
@property (nonatomic, copy) NSString *reportStatus;
//报告状态提示语
@property (nonatomic, copy) NSString *reportPromptStr;
//报告按钮
@property (nonatomic, copy) NSString *reportBtnTitle;

//身份验证码
//发送结果
@property (nonatomic, copy) NSString *idVerifyResult;
//提示语
@property (nonatomic, copy) NSString *idVerifyPromptStr;
//编码格式
@property (nonatomic, copy) NSString *encoding;
//responseObject
@property (nonatomic) id responseObject;

@end
