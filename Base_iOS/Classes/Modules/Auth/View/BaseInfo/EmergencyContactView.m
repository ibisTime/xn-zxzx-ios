//
//  EmergencyContactView.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/12/26.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "EmergencyContactView.h"

#import "TLUIHeader.h"
#import "AppColorMacro.h"

@interface EmergencyContactView()

@end

@implementation EmergencyContactView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initSubviews];
    }
    return self;
}

#pragma mark - Init
- (void)initSubviews {
    
    BaseWeakSelf;
    
    CGFloat titleWidth = 90;
    
    CGFloat heightMargin = 45;

    //亲属关系
    self.familyRelationTF = [[TLPickerTextField alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, heightMargin) leftTitle:@"亲属关系" titleWidth:titleWidth placeholder:@"请选择亲属关系"];
    
    self.familyRelationTF.didSelectBlock = ^(NSInteger index) {
        
        KeyValueModel *model = weakSelf.familyArr[index];
        
        weakSelf.selectFamily = model.dkey;
    };
    
    [self addSubview:self.familyRelationTF];
    
    //亲属姓名
    self.familyNameTF = [[TLTextField alloc] initWithFrame:CGRectMake(0, self.familyRelationTF.yy + 1, kScreenWidth, heightMargin) leftTitle:@"姓名" titleWidth:titleWidth placeholder:@"请输入亲属姓名"];
    
    [self addSubview:self.familyNameTF];
    
    //亲属联系方式
    self.familyMobileTF = [[TLTextField alloc] initWithFrame:CGRectMake(0, self.familyNameTF.yy + 1, kScreenWidth, heightMargin) leftTitle:@"联系方式" titleWidth:titleWidth placeholder:@"请输入亲属手机号"];
    
    self.familyMobileTF.keyboardType = UIKeyboardTypeNumberPad;
    
    [self addSubview:self.familyMobileTF];

    //社会关系
    self.societyRelationTF = [[TLPickerTextField alloc] initWithFrame:CGRectMake(0, self.familyMobileTF.yy + 11, kScreenWidth, heightMargin) leftTitle:@"社会关系" titleWidth:titleWidth placeholder:@"请选择社会关系"];
    
    self.societyRelationTF.didSelectBlock = ^(NSInteger index) {
        
        KeyValueModel *model = weakSelf.societyArr[index];
        
        weakSelf.selectSociety = model.dkey;
    };
    
    [self addSubview:self.societyRelationTF];
    
    //社会联系人姓名
    self.societyNameTF = [[TLTextField alloc] initWithFrame:CGRectMake(0, self.societyRelationTF.yy + 1, kScreenWidth, heightMargin) leftTitle:@"姓名" titleWidth:titleWidth placeholder:@"请输入社会联系人姓名"];
    
    [self addSubview:self.societyNameTF];
    
    //社会联系方式
    self.societyMobileTF = [[TLTextField alloc] initWithFrame:CGRectMake(0, self.societyNameTF.yy + 1, kScreenWidth, heightMargin) leftTitle:@"联系方式" titleWidth:titleWidth placeholder:@"请输入社会联系人手机号"];
    
    self.societyMobileTF.keyboardType = UIKeyboardTypeNumberPad;
    
    [self addSubview:self.societyMobileTF];
    
}

@end
