//
//  PedestrianQuestionCell.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/1/15.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "PedestrianQuestionCell.h"

#import "TLUIHeader.h"
#import "AppColorMacro.h"

#import "UIControl+Block.h"

@interface PedestrianQuestionCell()

//title
@property (nonatomic, strong) UILabel *optionLbl;

@end

@implementation PedestrianQuestionCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self initSubviews];
        
    }
    
    return self;
}

#pragma mark - Init
- (void)initSubviews {
    
    //optionBtn
    self.optionBtn = [UIButton buttonWithImageName:@"不打勾" selectedImageName:@"打勾"];
    
    self.optionBtn.selected = NO;
    
    [self.contentView addSubview:self.optionBtn];
    [self.optionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(@0);
        make.left.equalTo(@30);
        make.width.height.equalTo(@12);
        
    }];
    
    //title
    self.optionLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor font:14.0];
    
    self.optionLbl.numberOfLines = 0;
    
    [self.contentView addSubview:self.optionLbl];
    [self.optionLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.optionBtn.mas_right).offset(15);
        make.centerY.equalTo(self.optionBtn.mas_centerY).offset(0);
        make.right.equalTo(@(-15));
        
    }];
    
    //line
    UIView *line = [[UIView alloc] init];
    
    line.backgroundColor = kLineColor;
    
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@0);
        make.right.equalTo(@0);
        make.height.equalTo(@(0.5));
        make.bottom.equalTo(@(0));
        
    }];
}

#pragma mark - Setting
- (void)setAnswerOption:(AnswerOption *)answerOption {
    
    _answerOption = answerOption;
    
    self.optionLbl.text = answerOption.option;
    self.optionBtn.selected = answerOption.select;
    
}

@end
