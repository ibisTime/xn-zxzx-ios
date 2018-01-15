//
//  PedestrianQuestionTableView.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/1/15.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "TLTableView.h"

#import "PedestrianQuestionModel.h"

@interface PedestrianQuestionTableView : TLTableView
//问题列表
@property (nonatomic, strong) NSMutableArray <PedestrianQuestionModel *> *questionList;

@end
