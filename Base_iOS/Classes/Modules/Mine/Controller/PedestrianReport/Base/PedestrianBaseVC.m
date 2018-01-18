//
//  PedestrianBaseVC.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/1/12.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "PedestrianBaseVC.h"

#import "UIBarButtonItem+convience.h"
#import "PedestrianManager.h"
#import "TLAlert.h"
#import "NSString+Check.h"
#import "PedestrianVC.h"

@interface PedestrianBaseVC ()

@end

@implementation PedestrianBaseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initBackItem];
    //添加通知
    [self addNotification];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;

}

#pragma mark -  Init
- (void)initBackItem {
    
    UIButton *btn = [UIButton buttonWithImageName:@"返回-白色"];
    
    btn.frame = CGRectMake(-10, 0, 40, 44);
    
    btn.contentMode = UIViewContentModeScaleToFill;
    [btn addTarget:self action:@selector(clickBack) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *customView = [[UIView alloc] initWithFrame:btn.bounds];
    [customView addSubview:btn];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:customView];
    
    
}

#pragma mark - Notification
- (void)addNotification {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(systemError) name:kPedestrianSystemErrorNotification object:nil];
}

#pragma mark - Events
- (void)clickBack {
    
    if (_isBackPreviousPage) {
        
        [self.navigationController popViewControllerAnimated:YES];
        return ;
    }
    
    [TLAlert alertWithTitle:@"提示" msg:@"确定要返回征信首页？" confirmMsg:@"确定" cancleMsg:@"取消" cancle:^(UIAlertAction *action) {
        
    } confirm:^(UIAlertAction *action) {
        
        [self backPedestrianHome];
    }];
    
}

- (void)systemError {
    
    [self backPedestrianHome];

}

- (void)backPedestrianHome {
    
    //返回征信中心首页
    for (UIViewController *vc in self.navigationController.viewControllers) {
        
        if ([vc isKindOfClass:[PedestrianVC class]]) {
            
            [self.navigationController popToViewController:vc animated:YES];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
