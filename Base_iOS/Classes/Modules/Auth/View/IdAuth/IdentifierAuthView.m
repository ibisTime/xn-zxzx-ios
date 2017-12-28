//
//  IdentifierAuthView.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/9/4.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "IdentifierAuthView.h"

#import "TLUIHeader.h"
#import "AppColorMacro.h"

#define kIVWidth 140

@interface IdentifierAuthView ()

@property (nonatomic, strong) NSMutableArray *ivArr;

@property (nonatomic, strong) NSMutableArray *labelArr;

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIButton *commitBtn;

@end

@implementation IdentifierAuthView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = kWhiteColor;
        
        [self initScrollView];
        
        [self initSubviews];
    }
    
    return self;
}

#pragma mark - Init

- (void)initScrollView {
    
    self.labelArr = [NSMutableArray array];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    
    self.scrollView.backgroundColor = kBackgroundColor;
    
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    
    [self addSubview:self.scrollView];
}

- (void)initSubviews {
    
    NSArray *titleArr = @[@"上传身份证正面照片", @"上传身份证反面照片", @"上传手持身份证照片"];
    
    NSArray *imgArr = @[@"身份证正面照", @"身份证反面照", @"持证自拍"];
    
    //TopView
    CGFloat topHeight = 15 + kWidth(120) + 45;

    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, kScreenWidth, topHeight)];
    
    topView.backgroundColor = kWhiteColor;
    
    [self.scrollView addSubview:topView];
    
    for (int i = 0; i < 2; i++) {
        
        CGFloat ivW = (kScreenWidth - 3*15)/2.0;
        
        //imageView
        UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(15 + (ivW + 15)*i, 15, ivW, kWidth(120))];
        
        iv.contentMode = UIViewContentModeScaleAspectFit;
        
        iv.image = kImage(imgArr[i]);
        
        iv.clipsToBounds = YES;

        iv.userInteractionEnabled = YES;
        
        iv.tag = 1390 + i;

        [topView addSubview:iv];
        
        UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickIV:)];
        
        [iv addGestureRecognizer:tapGR];
        
        //label
        UILabel *label = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor2 font:14.0];
        
        label.text = titleArr[i];
        
        label.frame = CGRectMake(0, iv.yy, ivW, 45);
        
        label.centerX = iv.centerX;
        
        label.textAlignment = NSTextAlignmentCenter;
        
        [topView addSubview:label];
        
    }
    
    //BottomView
    
    CGFloat bottomHeight = 15 + kWidth(175) + 45;

    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, topView.yy + 10, kScreenWidth, bottomHeight)];
    
    bottomView.backgroundColor = kWhiteColor;
    
    [self.scrollView addSubview:bottomView];
    
    //imageView
    CGFloat handleW = kScreenWidth - 2*15;
    
    UIImageView *handheldIV = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, handleW, kWidth(175))];
    
    handheldIV.contentMode = UIViewContentModeScaleAspectFit;
    
    handheldIV.image = kImage(imgArr[2]);
    
    handheldIV.clipsToBounds = YES;
    
    handheldIV.userInteractionEnabled = YES;
    
    handheldIV.tag = 1392;
    
    [bottomView addSubview:handheldIV];
    
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickIV:)];
    
    [handheldIV addGestureRecognizer:tapGR];
    
    //label
    UILabel *label = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor2 font:14.0];
    
    label.text = titleArr[2];
    
    label.frame = CGRectMake(0, handheldIV.yy, handleW, 45);
    
    label.centerX = handheldIV.centerX;
    
    label.textAlignment = NSTextAlignmentCenter;
    
    [bottomView addSubview:label];
    //提示
    UILabel *promptLbl = [UILabel labelWithFrame:CGRectMake(0, bottomView.yy, kScreenWidth, 40) textAligment:NSTextAlignmentCenter backgroundColor:kClearColor font:Font(13.0) textColor:kAppCustomMainColor];
    
    promptLbl.text = @"您的照片仅用于审核, 我们将为您严格保密";
    
    [self.scrollView addSubview:promptLbl];
    
    CGFloat btnH = 45;
    
    CGFloat leftMargin = 15;
    
    UIButton *nextBtn = [UIButton buttonWithTitle:@"下一步" titleColor:kWhiteColor backgroundColor:kAppCustomMainColor titleFont:15.0 cornerRadius:btnH/2.0];
    
    nextBtn.frame = CGRectMake(leftMargin, promptLbl.yy, kScreenWidth - 2*leftMargin, btnH);
    
    [nextBtn addTarget:self action:@selector(clickNext) forControlEvents:UIControlEventTouchUpInside];
    
    [self.scrollView addSubview:nextBtn];
    
    self.scrollView.contentSize = CGSizeMake(kScreenWidth, nextBtn.yy + kWidth(40) + kBottomInsetHeight);
}

#pragma mark - Events

- (void)clickIV:(UITapGestureRecognizer *)sender {
    
    NSInteger index = sender.view.tag - 1390;
    
    if (_identifierBlock) {
        
        _identifierBlock(index);
    }
}

- (void)clickNext {
    
    if (_identifierBlock) {
        
        _identifierBlock(IdentifierAuthTypeCommit);
    }
}

@end
