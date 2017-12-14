//
//  MineVC.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/12/14.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "MineVC.h"

#import "CoinHeader.h"
#import "APICodeMacro.h"
//M
#import "MineGroup.h"
//V
#import "MineTableView.h"
//C
#import "CreditReportVC.h"
#import "SettingVC.h"
#import "HTMLStrVC.h"

#import "TLImagePicker.h"
#import "TLUploadManager.h"

@interface MineVC ()

//
@property (nonatomic, strong) MineGroup *group;
//
@property (nonatomic, strong) MineTableView *tableView;

@property (nonatomic, strong) TLImagePicker *imagePicker;

@end

@implementation MineVC

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //模型
    [self initGroup];
    //
    [self initTableView];
    //通知
    [self addNotification];
}

- (void)initGroup {
    
    BaseWeakSelf;
    
    //我的资信报告
    MineModel *creditReport = [MineModel new];
    
    creditReport.text = @"我的资信报告";
    creditReport.imgName = @"我的资信报告";
    creditReport.action = ^{
        
        CreditReportVC *creditReportVC = [CreditReportVC new];
        
        [weakSelf.navigationController pushViewController:creditReportVC  animated:YES];
        
    };

    //个人设置
    MineModel *setting = [MineModel new];
    
    setting.text = @"个人设置";
    setting.imgName = @"个人设置";
    setting.action = ^{
        
        SettingVC *settingVC = [SettingVC new];

        [weakSelf.navigationController pushViewController:settingVC animated:YES];
    };
    
    //关于我们
    MineModel *abountUs = [MineModel new];
    abountUs.text = @"关于我们";
    abountUs.imgName = @"关于我们";
    abountUs.action = ^{
        
        HTMLStrVC *htmlVC = [HTMLStrVC new];

        htmlVC.type = HTMLTypeAboutUs;

        [weakSelf.navigationController pushViewController:htmlVC animated:YES];
    };
    
    self.group = [MineGroup new];
    
    self.group.sections = @[@[creditReport, setting, abountUs]];
    
}

- (void)initTableView {
    
    self.tableView = [[MineTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kTabBarHeight) style:UITableViewStyleGrouped];
    
    self.tableView.mineGroup = self.group;
    
//    self.tableView.tableHeaderView = self.headerView;
    
    if (@available(iOS 11.0, *)) {
        
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    [self.view addSubview:self.tableView];
}

- (TLImagePicker *)imagePicker {
    
    if (!_imagePicker) {
        
        BaseWeakSelf;
        
        _imagePicker = [[TLImagePicker alloc] initWithVC:self];
        
        _imagePicker.allowsEditing = YES;
        _imagePicker.pickFinish = ^(NSDictionary *info){
            
            UIImage *image = info[@"UIImagePickerControllerOriginalImage"];
            NSData *imgData = UIImageJPEGRepresentation(image, 0.1);
            
            //进行上传
            TLUploadManager *manager = [TLUploadManager manager];
            
            manager.imgData = imgData;
            manager.image = image;
            
            [manager getTokenShowView:weakSelf.view succes:^(NSString *key) {
                
                [weakSelf changeHeadIconWithKey:key imgData:imgData];
                
            } failure:^(NSError *error) {
                
            }];
        };
    }
    
    return _imagePicker;
}

#pragma mark - Notification
- (void)addNotification {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeInfo) name:kUserLoginNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeInfo) name:kUserInfoChange object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginOut) name:kUserLoginOutNotification object:nil];
    
    
}

#pragma mark - Events
- (void)changeInfo {
    //
//    if ([TLUser user].photo) {
//
//        [self.headerView.photoBtn setTitle:@"" forState:UIControlStateNormal];
//
//        [self.headerView.photoBtn sd_setImageWithURL:[NSURL URLWithString:[[TLUser user].photo convertImageUrl]] forState:UIControlStateNormal];
//
//    } else {
//
//        NSString *nickName = [TLUser user].nickname;
//
//        NSString *title = [nickName substringToIndex:1];
//
//        [self.headerView.photoBtn setTitle:title forState:UIControlStateNormal];
//
//        [self.headerView.photoBtn setImage:nil forState:UIControlStateNormal];
//
//    }
//
//    self.headerView.nameLbl.text = [TLUser user].nickname;
    
}

- (void)changeHeadIconWithKey:(NSString *)key imgData:(NSData *)imgData {
    
    TLNetworking *http = [TLNetworking new];
    
    http.showView = self.view;
    http.code = USER_CHANGE_USER_PHOTO;
    http.parameters[@"userId"] = [TLUser user].userId;
    http.parameters[@"photo"] = key;
    http.parameters[@"token"] = [TLUser user].token;
    [http postWithSuccess:^(id responseObject) {
        
        [TLAlert alertWithSucces:@"修改头像成功"];
        
        [TLUser user].photo = key;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kUserInfoChange object:nil];
        
    } failure:^(NSError *error) {
        
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
