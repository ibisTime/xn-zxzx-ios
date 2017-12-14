//
//  TabbarViewController.m
//  BS
//
//  Created by 蔡卓越 on 16/3/31.
//  Copyright © 2016年 蔡卓越. All rights reserved.
//

#import "TabbarViewController.h"

#import "NavigationController.h"

#import <SDWebImageDownloader.h>
#import <SDWebImageManager.h>
#import "TLUserLoginVC.h"
#import "CustomTabBar.h"

@interface TabbarViewController () <UITabBarControllerDelegate, TabBarDelegate>


@property (nonatomic, strong) UIButton *addButton;

@property (nonatomic, strong) UILabel *msgLabel;

@property (nonatomic, strong) NSMutableArray *tabBarItems;

@property (nonatomic, strong) CustomTabBar *customTabbar;


@end

@implementation TabbarViewController

- (NavigationController*)createNavWithTitle:(NSString*)title imgNormal:(NSString*)imgNormal imgSelected:(NSString*)imgSelected vcName:(NSString*)vcName {
    
    if (![vcName hasSuffix:@"VC"]) {
        vcName = [NSString stringWithFormat:@"%@VC", vcName];
    }
    
    UIViewController *vc = [[NSClassFromString(vcName) alloc] init];
    NavigationController *nav = [[NavigationController alloc] initWithRootViewController:vc];
    
    UITabBarItem *tabBarItem = [[UITabBarItem alloc] initWithTitle:title
                                                             image:[UIImage imageNamed:imgNormal]
                                                     selectedImage:[UIImage imageNamed:imgSelected]];
    
    tabBarItem.selectedImage = [tabBarItem.selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    tabBarItem.image= [tabBarItem.image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    // tabBarItem.imageInsets = UIEdgeInsetsMake(7, 7, 7, 7);
    
    
    vc.navigationItem.titleView = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor font:13.0];
    
    vc.tabBarItem = tabBarItem;
    
    TabBarModel *item = [TabBarModel new];
    
    item.selectedImgUrl = imgSelected;
    item.unSelectedImgUrl = imgNormal;
    item.title = title;
    
    [self.tabBarItems addObject:item];
    
    return nav;
}


- (void)createSubControllers {
    
    NSArray *titles = @[@"认证", @"我的"];
    
    NSArray *normalImages = @[@"health_manage", @"health_circle"];
    
    NSArray *selectImages = @[@"health_manage_select", @"health_circle_select"];
    
    NSArray *vcNames = @[@"HealthManage", @"HealthCircle"];
    
    self.tabBarItems = [NSMutableArray array];
    
    // 健康管理
    NavigationController *healthManageNav = [self createNavWithTitle:titles[0] imgNormal:normalImages[0] imgSelected:selectImages[0] vcName:vcNames[0]];
    
    // 健康友圈
    NavigationController *healthCircleNav = [self createNavWithTitle:titles[1] imgNormal:normalImages[1] imgSelected:selectImages[1] vcName:vcNames[1]];
    
    self.viewControllers = @[healthManageNav, healthCircleNav];
}


// 消息提示红点
- (UILabel *)msgLabel {
    if (_msgLabel == nil) {
        
        CGFloat widthButton = kScreenWidth/self.viewControllers.count;
        
        CGFloat msgX = widthButton*2.5 + 6;
        
        _msgLabel = [[UILabel alloc] initWithFrame:CGRectMake(msgX, 10, 6, 6)];
        _msgLabel.layer.cornerRadius = 3;
        _msgLabel.layer.masksToBounds = YES;
        _msgLabel.backgroundColor = [UIColor redColor];
        _msgLabel.hidden = YES;
        
        [self.tabBar addSubview:_msgLabel];
    }
    
    return _msgLabel;
}

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置tabbar样式
    [UITabBar appearance].tintColor = kAppCustomMainColor;
    
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:kAppCustomMainColor , NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
    
    [[UITabBar appearance] setBarTintColor:[UIColor whiteColor]];
    
    // 创建子控制器
    [self createSubControllers];
    
    [self initTabBar];
    
    //退出通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLogout) name:kUserLoginOutNotification object:nil];
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
}

- (void)initTabBar {
    
    //替换系统tabbar
    CustomTabBar *tabBar = [[CustomTabBar alloc] initWithFrame:self.tabBar.bounds];
    tabBar.translucent = NO;
    tabBar.delegate = self;
    tabBar.backgroundColor = [UIColor orangeColor];
    
    [self setValue:tabBar forKey:@"tabBar"];
    
    [tabBar layoutSubviews];
    
    self.customTabbar = tabBar;
    
    tabBar.tabBarItems = self.tabBarItems.copy;
    
}

#pragma mark - Events
- (void)addArticleOnClick:(UIButton*)button {
    
    
    //    UINavigationController *nav = self.viewControllers[self.selectedIndex];
    // [nav.view addSubview:addVoaygeView];
    
    //    PublishViewController *publishVC = [[PublishViewController alloc] init];
    //    NavigationController *pubNav = [[NavigationController alloc] initWithRootViewController:publishVC];
    //
    //
    //    [nav presentViewController:pubNav animated:YES completion:nil];
}

- (void)userLogout {
    
    self.tabBar.items[3].badgeValue =  nil;
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}
#pragma mark - Setter
- (void)setIsHaveMsg:(BOOL)isHaveMsg {
    
    _msgLabel.hidden = !isHaveMsg;
}

- (void)setCurrentIndex:(NSInteger)currentIndex {
    
    _currentIndex = currentIndex;
    
    self.customTabbar.selectedIdx = _currentIndex;
    
    self.selectedIndex = _currentIndex;
}

#pragma mark- tabbar-delegate
- (BOOL)didSelected:(NSInteger)idx tabBar:(UITabBar *)tabBar {
    
    if (idx == 4 && ![TLUser user].isLogin) {
        
        TLUserLoginVC *loginVC = [TLUserLoginVC new];
        NavigationController *nav = [[NavigationController alloc] initWithRootViewController:loginVC];
        [self presentViewController:nav animated:YES completion:nil];
        
        return NO;
    }
    
    //
    self.selectedIndex = idx;
    
    return YES;
    
}



@end
