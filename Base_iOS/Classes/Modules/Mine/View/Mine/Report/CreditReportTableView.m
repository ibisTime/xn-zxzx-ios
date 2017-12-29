//
//  CreditReportTableView.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/12/29.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "CreditReportTableView.h"

#import "CreditRepostCell.h"

#import "TLUIHeader.h"
#import "AppColorMacro.h"

@interface CreditReportTableView()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation CreditReportTableView

static NSString *identifierCell = @"CreditRepostCell";

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    
    if (self = [super initWithFrame:frame style:style]) {
        
        self.dataSource = self;
        self.delegate = self;
        
        [self registerClass:[CreditRepostCell class] forCellReuseIdentifier:identifierCell];
    }
    
    return self;
}

#pragma mark - UITableViewDataSource;

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.reportModel.portListArr.count;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CreditRepostCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierCell forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    PortModel *port = self.reportModel.portListArr[indexPath.section];
    
    cell.port = port;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    QuestionModel *didSelectFoldCellModel = self.reportModel.portListArr[indexPath.section];
//
//    [tableView beginUpdates];
//    if (didSelectFoldCellModel.belowCount == 0) {
//
//        //Data
//        NSArray *submodels = [didSelectFoldCellModel open];
//        NSIndexSet *indexes = [NSIndexSet indexSetWithIndexesInRange:((NSRange){indexPath.row + 1,submodels.count})];
//        [self.data insertObjects:submodels atIndexes:indexes];
//
//        //Rows
//        NSMutableArray *indexPaths = [NSMutableArray new];
//        for (int i = 0; i < submodels.count; i++) {
//
//            NSIndexPath *insertIndexPath = [NSIndexPath indexPathForRow:(indexPath.row + 1 + i) inSection:indexPath.section];
//            [indexPaths addObject:insertIndexPath];
//        }
//        [tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
//
//    }else {
//
//        //Data
//        NSArray *submodels = [self.data subarrayWithRange:((NSRange){indexPath.row + 1,didSelectFoldCellModel.belowCount})];
//        [didSelectFoldCellModel closeWithSubmodels:submodels];
//        [self.data removeObjectsInArray:submodels];
//
//        //Rows
//        NSMutableArray *indexPaths = [NSMutableArray new];
//
//        for (int i = 0; i < submodels.count; i++) {
//
//            NSIndexPath *insertIndexPath = [NSIndexPath indexPathForRow:(indexPath.row + 1 + i) inSection:indexPath.section];
//            [indexPaths addObject:insertIndexPath];
//        }
//        [tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
//    }
//    [tableView endUpdates];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    return [UIView new];
}

@end
