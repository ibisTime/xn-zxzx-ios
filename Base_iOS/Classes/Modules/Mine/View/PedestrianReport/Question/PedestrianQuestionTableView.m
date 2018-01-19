//
//  PedestrianQuestionTableView.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/1/15.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "PedestrianQuestionTableView.h"

#import "PedestrianQuestionCell.h"

@interface PedestrianQuestionTableView()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation PedestrianQuestionTableView

static NSString *identifierCell = @"PedestrianQuestionCell";

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    
    if (self = [super initWithFrame:frame style:style]) {
        
        self.dataSource = self;
        self.delegate = self;
        
        [self registerClass:[PedestrianQuestionCell class] forCellReuseIdentifier:identifierCell];
    }
    
    return self;
}

#pragma mark - UITableViewDataSource;

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.questionList.count;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    PedestrianQuestionModel *model = self.questionList[section];
    
    return model.optionList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PedestrianQuestionCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierCell forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    PedestrianQuestionModel *model = self.questionList[indexPath.section];

    cell.answerOption = model.optionList[indexPath.row];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    PedestrianQuestionCell *cell = [tableView cellForRowAtIndexPath:indexPath];

    PedestrianQuestionModel *model = self.questionList[indexPath.section];
    
    model.answerResult = [NSString stringWithFormat:@"%ld", indexPath.row+1];
    
    model.options = [NSString stringWithFormat:@"%ld", indexPath.row+1];
    
    [model.optionList enumerateObjectsUsingBlock:^(AnswerOption * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {

        obj.select = idx == indexPath.row ? YES: NO;
        
    }];
    
    [tableView reloadData];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PedestrianQuestionModel *model = self.questionList[indexPath.section];
    
    return model.optionList[indexPath.row].cellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    PedestrianQuestionModel *model = self.questionList[section];

    return model.sectionHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    PedestrianQuestionModel *model = self.questionList[section];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, model.sectionHeight)];
    
    headerView.backgroundColor = kWhiteColor;
    //question
    UILabel *questionLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor font:16];
    questionLbl.numberOfLines = 0;
    
//    questionLbl.text = [NSString stringWithFormat:@"%ld: %@", section+1, model.question];
    questionLbl.text = model.question;

    [headerView addSubview:questionLbl];
    [questionLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(@0);
        make.left.equalTo(@15);
        make.right.equalTo(@(-15));
        
    }];
    
    //line
    UIView *line = [[UIView alloc] init];
    
    line.backgroundColor = kLineColor;
    
    [headerView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@0);
        make.right.equalTo(@0);
        make.height.equalTo(@(0.5));
        make.bottom.equalTo(@(0));
        
    }];
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    return [UIView new];
}

@end
