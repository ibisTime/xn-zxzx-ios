//
//  CreditReportTableView.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/12/29.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "CreditReportTableView.h"

#import "CreditRepostCell.h"
#import "CreditReportDetailCell.h"
#import "CreditReportIdentifierCell.h"
#import "CreditReportZM6Cell.h"

#import "TLUIHeader.h"
#import "AppColorMacro.h"

@interface CreditReportTableView()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation CreditReportTableView

static NSString *identifierCell = @"CreditRepostCell";

static NSString *detailCell = @"CreditRepostDetailCell";

static NSString *idCell = @"CreditReportIdentifierCell";

static NSString *zm6Cell = @"CreditReportZM6Cell";

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    
    if (self = [super initWithFrame:frame style:style]) {
        
        self.dataSource = self;
        self.delegate = self;
        
        [self registerClass:[CreditRepostCell class] forCellReuseIdentifier:identifierCell];
        
        [self registerClass:[CreditReportDetailCell class] forCellReuseIdentifier:detailCell];

        [self registerClass:[CreditReportIdentifierCell class] forCellReuseIdentifier:idCell];
        
        [self registerClass:[CreditReportZM6Cell class] forCellReuseIdentifier:zm6Cell];
    }
    
    return self;
}

#pragma mark - UITableViewDataSource;

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.reportModel.bigArr.count;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    PortModel *portModel = self.reportModel.bigArr[section];

    if (!portModel.isFold) {
        
        return 1;
    }
    
    return portModel.dataArr.count+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //如果是level==0，就用CreditRepostCell
    
    PortModel *portModel = self.reportModel.bigArr[indexPath.section];

    if (indexPath.row == 0) {
        
        CreditRepostCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierCell forIndexPath:indexPath];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.port = portModel;
        
        return cell;
    }
    
    if (portModel.isIDAuth) {
        
        NSArray *imgArr = @[@"身份证正面照", @"身份证反面照", @"持证自拍"];
        
        CreditReportIdentifierCell *cell = [tableView dequeueReusableCellWithIdentifier:idCell forIndexPath:indexPath];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.photo = imgArr[indexPath.row - 1];
        
        cell.infoModel = portModel.dataArr[indexPath.row - 1];

        return cell;
    }
    
    if ([portModel.authCode isEqualToString:@"PZM6"]) {
        
        CreditReportZM6Cell *cell = [tableView dequeueReusableCellWithIdentifier:zm6Cell forIndexPath:indexPath];
        
        cell.infoModel = portModel.dataArr[indexPath.row - 1];

        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        return cell;
    }
    
    CreditReportDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:detailCell forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.infoModel = portModel.dataArr[indexPath.row - 1];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CreditRepostCell *cell = [tableView cellForRowAtIndexPath:indexPath];

    PortModel *port = self.reportModel.bigArr[indexPath.section];
    
    if (indexPath.row != 0) {
        
        return ;
    }
    
    if (!port.isFold) {
        //打开折叠
        port.isFold = YES;
        //右箭头旋转
        [UIView animateWithDuration:0.2 animations:^{
            
            cell.arrowIV.transform = CGAffineTransformMakeRotation(M_PI_2);
            
        }];
        
        //Datas
        port.dataArr = [self.reportModel getDataWithTitle:port.authCode];
        
        //Rows
        NSMutableArray *indexPaths = [NSMutableArray new];
        
        for (int i = 0; i < port.dataArr.count; i++) {

            NSIndexPath *insertIndexPath = [NSIndexPath indexPathForRow:(indexPath.row + 1 + i) inSection:indexPath.section];
            [indexPaths addObject:insertIndexPath];
        }
        [tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
        
    }else {
        //关闭折叠
        port.isFold = NO;
        
        //右箭头还原
        [UIView animateWithDuration:0.2 animations:^{
            
            cell.arrowIV.transform = CGAffineTransformIdentity;
            
        }];
        //Rows
        NSMutableArray *indexPaths = [NSMutableArray new];

        for (int i = 0; i < port.dataArr.count; i++) {

            NSIndexPath *insertIndexPath = [NSIndexPath indexPathForRow:(indexPath.row + 1 + i) inSection:indexPath.section];
            [indexPaths addObject:insertIndexPath];
        }
        [tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row != 0) {
        //sectionHeight
        PortModel *portModel = self.reportModel.bigArr[indexPath.section];
        
        BaseInfoModel *infoModel = portModel.dataArr[indexPath.row - 1];
        
        if ([infoModel.content isEqualToString:@"section"]) {
            
            return 35;
        }
        //身份证认证
        if (portModel.isIDAuth) {
            
            CGFloat cellHeight = 15 + kWidth(120) + 45;

            return cellHeight;
        }
        
        //行业关注清单
        if ([portModel.authCode isEqualToString:@"PZM6"]) {
            
            return infoModel.cellHeight;
        }
    }
    
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
