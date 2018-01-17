//
//  ZHAccountBaseVC.m
//  ZHBusiness
//
//  Created by  蔡卓越 on 2016/12/12.
//  Copyright © 2016年  caizhuoyue. All rights reserved.
//

#import "TLAccountBaseVC.h"

#import <UIScrollView+TLAdd.h>
#import "AppColorMacro.h"

@interface TLAccountBaseVC ()

//@property (nonatomic,strong) UIScrollView *bgSV;

@end

@implementation TLAccountBaseVC

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];


}

- (void)viewDidLoad {
    
    [super viewDidLoad];

    self.view.backgroundColor = kBackgroundColor;
    
    //---//--//
    self.bgSV = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    self.bgSV.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.bgSV.contentSize = CGSizeMake(kScreenWidth, kSuperViewHeight + 1);
    
    [self.bgSV adjustsContentInsets];

    [self.view addSubview:self.bgSV];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    
    [self.bgSV addGestureRecognizer:tap];
    

}

//- (UIStatusBarStyle)preferredStatusBarStyle {
//
//    return UIStatusBarStyleDefault;
//
//}

- (void)tap {

    [self.view endEditing:YES];
}

@end
