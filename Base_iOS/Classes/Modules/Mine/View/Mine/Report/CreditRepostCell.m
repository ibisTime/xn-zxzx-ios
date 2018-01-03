//
//  CreditRepostCell.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/12/29.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "CreditRepostCell.h"

#import "TLUIHeader.h"
#import "AppColorMacro.h"

#import "NSString+CGSize.h"
#import "UILabel+Extension.h"

@interface CreditRepostCell()

@property (nonatomic, strong) UILabel *titleLbl;

@end

@implementation CreditRepostCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self initSubviews];
        
    }
    
    return self;
}

#pragma mark - Init
- (void)initSubviews {
    
    self.backgroundColor = kAppCustomMainColor;
    
    //arrow
    UIImageView *arrowIV = [[UIImageView alloc] initWithImage:kImage(@"更多-白色")];
    
    [self.contentView addSubview:arrowIV];
    [arrowIV mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(@(0));
        make.centerY.equalTo(@0);
        make.width.equalTo(@40);
        make.height.equalTo(@40);
        
    }];
    
    self.arrowIV = arrowIV;
    
    //title
    self.titleLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kWhiteColor font:15.0];
    
    self.titleLbl.numberOfLines = 0;
    
    [self.contentView addSubview:self.titleLbl];
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@15);
        make.right.equalTo(arrowIV.mas_left).offset(-10);
        make.centerY.equalTo(@0);
        
    }];
    
    //bottomLine
    UIView *bottomLine = [[UIView alloc] init];
    
    bottomLine.backgroundColor = kWhiteColor;
    
    [self.contentView addSubview:bottomLine];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.bottom.equalTo(@0);
        make.height.equalTo(@0.5);
        
    }];
    
}

- (void)setPort:(PortModel *)port {
    
    _port = port;
    
    self.titleLbl.text = port.authName;
}

@end
