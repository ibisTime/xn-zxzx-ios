//
//  NavigationController.h
//  BS
//
//  Created by 蔡卓越 on 16/3/31.
//  Copyright © 2016年 蔡卓越. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NavigationController : UINavigationController

/** 点击了导航栏的返回按钮*/
@property (nonatomic , strong) UIButton *navButton;
//是否隐藏返回箭头
@property (nonatomic, assign) BOOL isHidden;

@end

