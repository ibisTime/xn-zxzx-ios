//
//  TabbarViewController.m
//  BS
//
//  Created by 蔡卓越 on 16/3/31.
//  Copyright © 2016年 蔡卓越. All rights reserved.
//

#import "TabbarViewController.h"

#import "NavigationController.h"

#import "TLUIHeader.h"
#import "AppColorMacro.h"
#import "UIImage+Tint.h"

@interface TabbarViewController () <UITabBarControllerDelegate>

@end

@implementation TabbarViewController

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置tabbar样式
    [self initTabbar];
    // 创建子控制器
    [self createSubControllers];
    
}

#pragma mark - Init
- (void)initTabbar {
    
    [UITabBar appearance].tintColor = kAppCustomMainColor;
    
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:kAppCustomMainColor , NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
    
    [[UITabBar appearance] setBarTintColor:[UIColor whiteColor]];
}

- (void)createSubControllers {
    
    NSArray *titles = @[@"认证", @"我的"];
    
    NSArray *normalImages = @[@"auth", @"mine"];
    
    NSArray *selectImages = @[@"auth_select", @"mine_select"];
    
    NSArray *vcNames = @[@"AuthVC", @"MineVC"];
    
    for (int i = 0; i < normalImages.count; i++) {
        
        [self addChildVCWithTitle:titles[i]
                       vcName:vcNames[i]
                      imgNormal:normalImages[i]
                    imgSelected:selectImages[i]];
    }
    
    self.selectedIndex = 2;

}

#pragma mark - Events
- (void)addChildVCWithTitle:(NSString *)title
                 vcName:(NSString *)vcName
                imgNormal:(NSString *)imgNormal
              imgSelected:(NSString *)imgSelected {
    
    //对选中图片进行渲染
    UIImage *selectedImg = [[UIImage imageNamed:imgSelected] tintedImageWithColor:kAppCustomMainColor];

    UITabBarItem *tabBarItem = [[UITabBarItem alloc] initWithTitle:title
                                                             image:[UIImage imageNamed:imgNormal]
                                                     selectedImage:selectedImg];
    
    tabBarItem.selectedImage = [tabBarItem.selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    tabBarItem.image= [tabBarItem.image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIViewController *vc = [[NSClassFromString(vcName) alloc] init];
    
    NavigationController *nav = [[NavigationController alloc] initWithRootViewController:vc];
    
    vc.tabBarItem = tabBarItem;
    
    [self addChildViewController:nav];

}


@end
