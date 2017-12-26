//
//  BaseInfoView.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/12/26.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TLPickerTextField.h"
#import "AddressPickerView.h"

#import "KeyValueModel.h"

@interface BaseInfoView : UIView

//学历
@property (nonatomic, strong) TLPickerTextField *edcationTF;
//婚姻
@property (nonatomic, strong) TLPickerTextField *marriageTF;
//居住时长
@property (nonatomic, strong) TLPickerTextField *liveTimeTF;
//子女个数
@property (nonatomic, strong) TLTextField *childernNumTF;
//居住省市
@property (nonatomic, strong) TLTextField *liveProvinceTF;
//省市区
@property (nonatomic,strong) AddressPickerView *addressPicker;
//详细地址
@property (nonatomic, strong) TLTextField *addressTF;
//QQ
@property (nonatomic, strong) TLTextField *qqTF;
//email
@property (nonatomic, strong) TLTextField *emailTF;
//省
@property (nonatomic,copy) NSString *province;
//市
@property (nonatomic,copy) NSString *city;
//区
@property (nonatomic,copy) NSString *area;
//选中的学历
@property (nonatomic, copy) NSString *selectEdcation;
//选中的居住年限
@property (nonatomic, copy) NSString *selectLiveTime;
//选中的婚姻状况
@property (nonatomic, copy) NSString *selectMarriage;

//数据
//学历
@property (nonatomic, strong) NSMutableArray <KeyValueModel *>*edcationArr;
//年限
@property (nonatomic, strong) NSMutableArray <KeyValueModel *>*timeArr;
//婚姻状况
@property (nonatomic, strong) NSMutableArray <KeyValueModel *>*marriageArr;

@end
