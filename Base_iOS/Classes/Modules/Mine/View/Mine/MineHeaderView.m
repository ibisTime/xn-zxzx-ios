//
//  MineHeaderView.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/12/15.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "MineHeaderView.h"

#import "TLUIHeader.h"
#import "AppColorMacro.h"

@implementation MineHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self initSubviews];
    }
    return self;
}

#pragma mark - Init
- (void)initSubviews {
    
    CGFloat photoW = 60;
    
    self.userPhoto = [[UIImageView alloc] initWithFrame:CGRectMake(15, (self.height - photoW)/2.0 - 10, photoW, photoW)];
    
    self.userPhoto.image = [UIImage imageNamed:@"头像"];
    self.userPhoto.layer.cornerRadius = photoW/2.0;
    self.userPhoto.layer.masksToBounds = YES;
    self.userPhoto.contentMode = UIViewContentModeScaleAspectFill;
    
    self.userPhoto.userInteractionEnabled = YES;
    
    [self addSubview:self.userPhoto];
    
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectPhoto:)];
    
    [self.userPhoto addGestureRecognizer:tapGR];
    
    //
    self.nameLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kWhiteColor font:15.0];
    
    [self addSubview:self.nameLbl];
    [self.nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.userPhoto.mas_centerY);
        make.left.equalTo(self.userPhoto.mas_right).offset(15);

    }];
}

#pragma mark - Events
- (void)selectPhoto:(UITapGestureRecognizer *)tapGR {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedWithType:)]) {
        
        [self.delegate didSelectedWithType:MineHeaderSeletedTypeSelectPhoto];
    }
    
}


@end
