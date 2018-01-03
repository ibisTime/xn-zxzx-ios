//
//  CreditReportZM6Cell.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/1/3.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "CreditReportZM6Cell.h"

#import "TLUIHeader.h"
#import "AppColorMacro.h"

#import "NSString+CGSize.h"
#import "UILabel+Extension.h"

@interface CreditReportZM6Cell()

//title
@property (nonatomic, strong) UILabel *titleLbl;
//content
@property (nonatomic, strong) UILabel *contentLbl;

@end

@implementation CreditReportZM6Cell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self initSubviews];
        
    }
    
    return self;
}

#pragma mark - Init
- (void)initSubviews {
    
    self.backgroundColor = kWhiteColor;
    
    //title
    self.titleLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor font:15.0];
    
    self.titleLbl.numberOfLines = 0;
    
    [self.contentView addSubview:self.titleLbl];
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@15);
        make.centerY.equalTo(@0);
        make.width.greaterThanOrEqualTo(@(65));
        
    }];
    
    //content
    self.contentLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor font:15.0];
    
    [self.contentView addSubview:self.contentLbl];
    [self.contentLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.titleLbl.mas_right).offset(15);
        make.centerY.equalTo(@0);
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
    
    [self.titleLbl labelWithTextString:infoModel.title lineSpace:4];
    
    self.contentLbl.text = [infoModel.content isEqualToString:@"section"] ? @"": infoModel.content;
    
    self.backgroundColor = [infoModel.content isEqualToString:@"section"] ? kBackgroundColor: kWhiteColor;
    
//    [self layoutSubviews];
//
//    infoModel.cellHeight = self.titleLbl.yy > 30 ? self.titleLbl.yy + 15: 45;
    
}

@end
