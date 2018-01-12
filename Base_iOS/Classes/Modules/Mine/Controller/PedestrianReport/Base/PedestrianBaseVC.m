//
//  PedestrianBaseVC.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/1/12.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "PedestrianBaseVC.h"

#import "UIBarButtonItem+convience.h"

@interface PedestrianBaseVC ()

@end

@implementation PedestrianBaseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initBackItem];
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

#pragma mark - Events
- (void)clickBack {
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
