//
//  PedestrianQuestionCell.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/1/15.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PedestrianQuestionModel.h"

@interface PedestrianQuestionCell : UITableViewCell

@property (nonatomic, strong) AnswerOption *answerOption;

//btn
@property (nonatomic, strong) UIButton *optionBtn;

@end
