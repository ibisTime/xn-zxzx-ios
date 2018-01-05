//
//  CreditReportEMContactCell.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/1/4.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "CreditReportEMContactCell.h"

#import "TLUIHeader.h"
#import "AppColorMacro.h"

#import "NSString+CGSize.h"
#import "UILabel+Extension.h"

@interface CreditReportEMContactCell()

//手机号
@property (nonatomic, strong) UILabel *mobileLbl;
//关系
@property (nonatomic, strong) UILabel *relationLbl;
//归属地
@property (nonatomic, strong) UILabel *contactAreaLbl;

@end

@implementation CreditReportEMContactCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self initSubviews];
        
    }
    
    return self;
}

#pragma mark - Init
- (void)initSubviews {
    
    CGFloat width = kScreenWidth/3.0;
    
    //手机号
    self.mobileLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor font:15.0];
    
    self.mobileLbl.textAlignment = NSTextAlignmentCenter;
    
    [self.contentView addSubview:self.mobileLbl];
    [self.mobileLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@15);
        make.centerY.equalTo(@0);
        make.width.equalTo(@(width));
        
    }];
    
    //关系
    self.relationLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor font:15.0];
    
    self.relationLbl.textAlignment = NSTextAlignmentCenter;

    [self.contentView addSubview:self.relationLbl];
    [self.relationLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.mobileLbl.mas_right).offset(0);
        make.centerY.equalTo(@0);
        make.width.equalTo(@(width));

    }];
    
    //归属地
    self.contactAreaLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor font:15.0];
    
    self.contactAreaLbl.textAlignment = NSTextAlignmentCenter;

    [self.contentView addSubview:self.contactAreaLbl];
    [self.contactAreaLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.relationLbl.mas_right).offset(0);
        make.centerY.equalTo(@0);
        make.width.equalTo(@(width));

    }];
    
    //bottomLine
    UIView *bottomLine = [[UIView alloc] init];
    
    bottomLine.backgroundColor = kLineColor;
    
    [self.contentView addSubview:bottomLine];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.bottom.equalTo(@0);
        make.height.equalTo(@0.5);
        
    }];
}

- (void)setInfoModel:(BaseInfoModel *)infoModel {
    
    _infoModel = infoModel;
    
    NSArray *textArr = [infoModel.title componentsSeparatedByString:@"|"];
    
    self.mobileLbl.text = textArr[0];
    
    self.relationLbl.text = textArr[1];
    
    self.contactAreaLbl.text = textArr[2];
    
}

@end
