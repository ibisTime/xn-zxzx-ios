//
//  FoucsModel.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/1/3.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "FoucsModel.h"

@implementation FoucsModel

+ (NSDictionary *)objectClassInArray {
    
    return @{@"infoArray" : [ZMInfoArray class]};
}
@end




@implementation ZMInfoArray

@end


@implementation ZMType

+ (NSDictionary *)objectClassInArray {
    
    return @{@"typeCodeInfo" : [ZMTypeCodeInfo class]};
}

@end


@implementation ZMTypeCodeInfo

@end


@implementation ZMCodeList

+ (NSDictionary *)objectClassInArray {
    
    return @{@"codeList" : [ZMCodeInfo class]};
}

@end


@implementation ZMCodeInfo

@end
