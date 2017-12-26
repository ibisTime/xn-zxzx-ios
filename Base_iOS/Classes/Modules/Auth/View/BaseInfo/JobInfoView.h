//
//  JobInfoView.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/12/26.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TLPickerTextField.h"
#import "AddressPickerView.h"

#import "KeyValueModel.h"

@interface JobInfoView : UIView

@property (nonatomic, strong) NSMutableArray <KeyValueModel *>*jobArr;

@property (nonatomic, strong) NSMutableArray <KeyValueModel *>*incomeArr;

@property (nonatomic, strong) TLPickerTextField *jobTF;  //职业

@property (nonatomic, strong) TLPickerTextField *incomeTF;  //月收入

@property (nonatomic, strong) TLTextField *companyNameTF;   //子女个数

@property (nonatomic, strong) TLTextField *provinceTF;  //所在省市

@property (nonatomic,strong) AddressPickerView *addressPicker;  //省市区
@property (nonatomic, strong) TLTextField *addressTF;       //详细地址

@property (nonatomic, strong) TLTextField *mobileTF;      //居住时长

@property (nonatomic, copy) NSString *selectJob;

@property (nonatomic, copy) NSString *selectIncome;

@property (nonatomic,copy) NSString *province;
@property (nonatomic,copy) NSString *city;
@property (nonatomic,copy) NSString *area;

@end
