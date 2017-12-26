//
//  QuestionCell.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/12/25.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "QuestionCell.h"

#import "TLUIHeader.h"
#import "AppColorMacro.h"

#import "NSString+CGSize.h"
#import "UILabel+Extension.h"

@interface QuestionCell()

@property (nonatomic, strong) UILabel *titleLbl;

@end

@implementation QuestionCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self initSubviews];
        
    }
    
    return self;
}

#pragma mark - Init
- (void)initSubviews {
    
    //arrow
    UIImageView *arrowIV = [[UIImageView alloc] initWithImage:kImage(@"更多-灰色")];
    
    [self.contentView addSubview:arrowIV];
    [arrowIV mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(@(-15));
        make.centerY.equalTo(@0);
        make.width.equalTo(@6.5);
        make.height.equalTo(@12);
        
    }];
    
    //title
    self.titleLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor font:15.0];

    self.titleLbl.numberOfLines = 0;
    
    [self.contentView addSubview:self.titleLbl];
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@15);
        make.right.equalTo(arrowIV.mas_left).offset(-10);
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

#pragma mark - Data
- (void)setQuestion:(QuestionModel *)question {
    
    _question = question;
    
    NSString *title = [NSString stringWithFormat:@"%@ 向你发起调查(%@)", question.salesUserMobile, question.statusStr];
    
    [self.titleLbl labelWithTextString:title lineSpace:5];
    
    CGFloat width = kScreenWidth - 30 - 10 - 6.5;

    CGSize contentSize = [self.titleLbl.text calculateStringSize:CGSizeMake(width, MAXFLOAT) font:Font(17.5)];
    
    question.cellHeight = contentSize.height + 20 > 50 ? contentSize.height + 20: 50;
}

@end
