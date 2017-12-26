//
//  EmergencyContactView.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/12/26.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TLPickerTextField.h"
#import "AddressPickerView.h"

#import "KeyValueModel.h"

@interface EmergencyContactView : UIView

@property (nonatomic, strong) NSMutableArray <KeyValueModel *>*familyArr;

@property (nonatomic, strong) NSMutableArray <KeyValueModel *>*societyArr;

@property (nonatomic, strong) TLPickerTextField *familyRelationTF;        //亲属关系

@property (nonatomic, strong) TLTextField *familyNameTF;                //亲属姓名

@property (nonatomic, strong) TLTextField *familyMobileTF;              //亲属联系方式

@property (nonatomic, strong) TLPickerTextField *societyRelationTF;       //社会关系

@property (nonatomic, strong) TLTextField *societyNameTF;               //社会联系人姓名
@property (nonatomic, strong) TLTextField *societyMobileTF;             //社会联系方式

@property (nonatomic, copy) NSString *selectFamily;

@property (nonatomic, copy) NSString *selectSociety;

@end
