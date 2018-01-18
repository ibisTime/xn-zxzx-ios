//
//  PedestrianBaseVC.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/1/12.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "TLAccountBaseVC.h"

#import <TFHpple.h>

@interface PedestrianBaseVC : TLAccountBaseVC
//是否返回上一页
@property (nonatomic, assign) BOOL isBackPreviousPage;

//返回征信中心首页
- (void)backPedestrianHome;

@end
