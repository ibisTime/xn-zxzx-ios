//
//  QuestionTableView.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/12/22.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "TLTableView.h"

#import "QuestionModel.h"

@interface QuestionTableView : TLTableView

@property (nonatomic, strong) NSMutableArray <QuestionModel *> *questions;

@end
