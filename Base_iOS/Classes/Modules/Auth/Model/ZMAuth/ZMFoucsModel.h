//
//  ZMFoucsModel.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/7/27.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "BaseModel.h"

@interface ZMFoucsModel : BaseModel

@property (nonatomic, copy) NSString *appId;

@property (nonatomic, copy) NSString *param;

@property (nonatomic, copy) NSString *signature;

@property (nonatomic, copy) NSString *bizNo;

@property (nonatomic, assign) BOOL authorized;

@property (nonatomic, assign) BOOL isMatched;

@end
