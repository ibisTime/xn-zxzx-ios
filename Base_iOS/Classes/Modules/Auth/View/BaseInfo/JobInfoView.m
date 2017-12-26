//
//  JobInfoView.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/12/26.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "JobInfoView.h"

#import "TLUIHeader.h"
#import "AppColorMacro.h"

@interface JobInfoView()

@end

@implementation JobInfoView

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
            
            weakSelf.provinceTF.text = [NSString stringWithFormat:@"%@ %@ %@",weakSelf.province,weakSelf.city,weakSelf.area];
            
        };
        
    }
    return _addressPicker;
    
}

- (void)initSubviews {
    
    BaseWeakSelf;
    
    CGFloat titleWidth = 90;
    
    CGFloat heightMargin = 45;

    //职业
    self.jobTF = [[TLPickerTextField alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, heightMargin) leftTitle:@"职业" titleWidth:titleWidth placeholder:@"请选择职业"];
    
    self.jobTF.didSelectBlock = ^(NSInteger index) {
        
        KeyValueModel *model = weakSelf.jobArr[index];
        
        weakSelf.selectJob = model.dkey;
    };
    
    [self addSubview:self.jobTF];
    
    //月收入
    self.incomeTF = [[TLPickerTextField alloc] initWithFrame:CGRectMake(0, self.jobTF.yy + 1, kScreenWidth, heightMargin) leftTitle:@"月收入" titleWidth:titleWidth placeholder:@"请选择月收入"];
    
    self.incomeTF.didSelectBlock = ^(NSInteger index) {
        
        KeyValueModel *model = weakSelf.incomeArr[index];
        
        weakSelf.selectIncome = model.dkey;
    };
    
    [self addSubview:self.incomeTF];
    
    //单位名称
    self.companyNameTF = [[TLTextField alloc] initWithFrame:CGRectMake(0, self.incomeTF.yy + 1, kScreenWidth, heightMargin) leftTitle:@"单位名称" titleWidth:titleWidth placeholder:@"请输入单位名称"];
    
    [self addSubview:self.companyNameTF];
    
    //所在省市
    self.provinceTF = [[TLTextField alloc] initWithFrame:CGRectMake(0, self.companyNameTF.yy + 1, kScreenWidth, heightMargin) leftTitle:@"所在省市" titleWidth:titleWidth placeholder:@"请选择单位所在省市"];
    
    [self addSubview:self.provinceTF];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:self.provinceTF.bounds];
    
    [self.provinceTF addSubview:btn];
    [btn addTarget:self action:@selector(chooseAddress) forControlEvents:UIControlEventTouchUpInside];
    
    //常住地址
    self.addressTF = [[TLTextField alloc] initWithFrame:CGRectMake(0, self.provinceTF.yy + 1, kScreenWidth, heightMargin) leftTitle:@"详细地址" titleWidth:titleWidth placeholder:@"请输入详细地址"];
    
    [self addSubview:self.addressTF];
    
    //单位电话
    
    self.mobileTF = [[TLTextField alloc] initWithFrame:CGRectMake(0, self.addressTF.yy + 1, kScreenWidth, heightMargin) leftTitle:@"单位电话" titleWidth:titleWidth placeholder:@"区号+号码(选填)"];
    
    [self addSubview:self.mobileTF];
    
}

#pragma mark - Events

- (void)chooseAddress {
    
    [self endEditing:YES];
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.addressPicker];
}

@end
