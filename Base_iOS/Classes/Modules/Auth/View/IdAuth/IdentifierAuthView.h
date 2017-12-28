//
//  IdentifierAuthView.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/9/4.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, IdentifierAuthType) {
    
    IdentifierAuthTypeIDCardPositive = 0,       //身份证正面
    IdentifierAuthTypeIDCardOtherSide,          //身份证反面
    IdentifierAuthTypeIDCardHandheld,           //手持身份证
    IdentifierAuthTypeCommit,                   //提交
};

typedef void(^IdentifierAuthBlock)(IdentifierAuthType type);

@interface IdentifierAuthView : UIView

@property (nonatomic, assign) IdentifierAuthType identifierType;

@property (nonatomic, copy) IdentifierAuthBlock identifierBlock;

@end
