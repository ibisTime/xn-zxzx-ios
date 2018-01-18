//
//  BaseInfoView.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/12/26.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "BaseInfoView.h"

#import "TLUIHeader.h"
#import "AppColorMacro.h"

@interface BaseInfoView()

@end

@implementation BaseInfoView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initSubviews];
    }
    return self;
}

#pragma mark - Init

- (AddressPickerView *)addressPicker {
    
    if (!_addressPicker) {
        
        _addressPicker = [[AddressPickerView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        
        __weak typeof(self) weakSelf = self;
        _addressPicker.confirm = ^(NSString *province,NSString *city,NSString *area){
            
            
            weakSelf.province = province;
            weakSelf.city = city;
            weakSelf.area = area;
            
            weakSelf.liveProvinceTF.text = [NSString stringWithFormat:@"%@ %@ %@",weakSelf.province,weakSelf.city,weakSelf.area];
        };
        
    }
    return _addressPicker;
    
}

- (void)initSubviews {
    
    BaseWeakSelf;
    
    CGFloat titleWidth = 90;
    
    CGFloat heightMargin = 45;
    
    //学历
    self.edcationTF = [[TLPickerTextField alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, heightMargin) leftTitle:@"学历" titleWidth:titleWidth placeholder:@"请选择学历"];
    
    self.edcationTF.didSelectBlock = ^(NSInteger index) {
        
        KeyValueModel *model = weakSelf.edcationArr[index];
        
        weakSelf.selectEdcation = model.dkey;
    };
    
    [self addSubview:self.edcationTF];
    
    //婚姻
    self.marriageTF = [[TLPickerTextField alloc] initWithFrame:CGRectMake(0, self.edcationTF.yy + 1, kScreenWidth, heightMargin) leftTitle:@"婚姻" titleWidth:titleWidth placeholder:@"请选择婚姻状态"];
    
    self.marriageTF.didSelectBlock = ^(NSInteger index) {
        
        KeyValueModel *model = weakSelf.marriageArr[index];
        
        weakSelf.selectMarriage = model.dkey;
    };
    
    [self addSubview:self.marriageTF];
    
    //子女个数
    self.childernNumTF = [[TLTextField alloc] initWithFrame:CGRectMake(0, self.marriageTF.yy + 1, kScreenWidth, heightMargin) leftTitle:@"子女个数" titleWidth:titleWidth placeholder:@"请输入子女数量"];
    
    self.childernNumTF.keyboardType = UIKeyboardTypeNumberPad;
    
    [self addSubview:self.childernNumTF];
    
    //居住省市
    self.liveProvinceTF = [[TLTextField alloc] initWithFrame:CGRectMake(0, self.childernNumTF.yy + 1, kScreenWidth, heightMargin) leftTitle:@"居住省市" titleWidth:titleWidth placeholder:@"请输入居住省市"];
    
    [self addSubview:self.liveProvinceTF];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:self.liveProvinceTF.bounds];
    
    [self.liveProvinceTF addSubview:btn];
    [btn addTarget:self action:@selector(chooseAddress) forControlEvents:UIControlEventTouchUpInside];
    
    //详细地址
    self.addressTF = [[TLTextField alloc] initWithFrame:CGRectMake(0, self.liveProvinceTF.yy + 1, kScreenWidth, heightMargin) leftTitle:@"详细地址" titleWidth:titleWidth placeholder:@"请输入详细地址(精确到门牌号)"];
    
    [self addSubview:self.addressTF];
    
    //居住时长
    self.liveTimeTF = [[TLPickerTextField alloc] initWithFrame:CGRectMake(0, self.addressTF.yy + 1, kScreenWidth, heightMargin) leftTitle:@"居住时长" titleWidth:titleWidth placeholder:@"请选择居住时长"];
    
    self.liveTimeTF.didSelectBlock = ^(NSInteger index) {
        
        KeyValueModel *model = weakSelf.timeArr[index];
        
        weakSelf.selectLiveTime = model.dkey;
    };
    
    [self addSubview:self.liveTimeTF];
    
    //QQ
    self.qqTF = [[TLTextField alloc] initWithFrame:CGRectMake(0, self.liveTimeTF.yy + 1, kScreenWidth, 45) leftTitle:@"QQ" titleWidth:titleWidth placeholder:@"请输入QQ号码(选填)"];
    
    self.qqTF.keyboardType = UIKeyboardTypeNumberPad;
    
    [self addSubview:self.qqTF];
    
    //电子邮箱
    self.emailTF = [[TLTextField alloc] initWithFrame:CGRectMake(0, self.qqTF.yy + 1, kScreenWidth, 45) leftTitle:@"电子邮箱" titleWidth:titleWidth placeholder:@"请输入电子邮箱(选填)"];
    
    [self addSubview:self.emailTF];
}

#pragma mark - Events

- (void)chooseAddress {
    
    [self endEditing:YES];
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.addressPicker];
}
@end
