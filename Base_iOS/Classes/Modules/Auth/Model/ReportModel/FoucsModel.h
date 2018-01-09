//
//  FoucsModel.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/1/3.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BaseModel.h"

@class ZMType,ZMTypeCodeInfo,ZMCodeList,ZMCodeInfo;

//行业类型
@interface FoucsModel : BaseModel

@property (nonatomic, copy) NSString *bizCode;

@property (nonatomic, copy) NSString *bizName;

@property (nonatomic, strong) ZMType *type;

@end

//风险类型
@interface ZMType : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, strong) NSArray<ZMTypeCodeInfo *> *typeCodeInfo;

@end
//字段名称
@interface ZMTypeCodeInfo : NSObject

@property (nonatomic, copy) NSString *value;

@property (nonatomic, strong) ZMCodeList *codeList;

@property (nonatomic, copy) NSString *code;

@end
//字段说明
@interface ZMCodeList : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, strong) NSArray<ZMCodeInfo *> *codeList;

@end

@interface ZMCodeInfo : NSObject

@property (nonatomic, copy) NSString *value;

@property (nonatomic, copy) NSString *code;

@end
