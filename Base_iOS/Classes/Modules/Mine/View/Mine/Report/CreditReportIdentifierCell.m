//
//  CreditReportIdentifierCell.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/1/2.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "CreditReportIdentifierCell.h"

#import "TLUIHeader.h"
#import "AppColorMacro.h"

#import <UIImageView+WebCache.h>
#import "NSString+Extension.h"

@interface CreditReportIdentifierCell()

@property (nonatomic, strong) UIImageView *photoIV;

@property (nonatomic, strong) UILabel *titleLbl;

@end

@implementation CreditReportIdentifierCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self initSubviews];
        
    }
    
    return self;
}

#pragma mark - Init
- (void)initSubviews {
    
    CGFloat ivW = (kScreenWidth - 3*15)/2.0;

    self.photoIV = [[UIImageView alloc] init];
    
    self.photoIV.contentMode = UIViewContentModeScaleAspectFit;
    self.photoIV.clipsToBounds = YES;
    
    [self.contentView addSubview:self.photoIV];
    [self.photoIV mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(@0);
        make.width.equalTo(@(ivW));
        make.height.equalTo(@(kWidth(120)));
        make.top.equalTo(@15);
        
    }];
    
    //label
    self.titleLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor2 font:14.0];
    
    self.titleLbl.textAlignment = NSTextAlignmentCenter;
    
    [self.contentView addSubview:self.titleLbl];
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(@0);
        make.top.equalTo(self.photoIV.mas_bottom).offset(10);
        
    }];
}

- (void)setInfoModel:(BaseInfoModel *)infoModel {
    
    _infoModel = infoModel;
    
    [self.photoIV sd_setImageWithURL:[NSURL URLWithString:[_infoModel.content convertImageUrl]] placeholderImage:kImage(self.photo)];
    
    self.titleLbl.text = _infoModel.title;
}

@end
