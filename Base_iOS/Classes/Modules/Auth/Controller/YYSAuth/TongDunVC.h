//
//  TongDunVC.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/12/11.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^AuthRespBlock)(NSString *taskId);

@interface TongDunVC : BaseViewController

@property (nonatomic, copy) AuthRespBlock respBlock;

@end
