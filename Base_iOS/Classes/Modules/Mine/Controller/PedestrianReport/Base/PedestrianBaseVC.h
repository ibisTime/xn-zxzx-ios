//
//  PedestrianBaseVC.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/1/12.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "TLAccountBaseVC.h"

typedef void(^SystemErrorBlock)();

@interface PedestrianBaseVC : TLAccountBaseVC

//系统错误
- (void)systemErrorWithBlock:(SystemErrorBlock)block encoding:(NSString *)encoding responseObject:(id)responseObject;

@end
