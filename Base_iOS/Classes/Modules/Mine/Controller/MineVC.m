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
#import "MineHeaderView.h"

//C
#import "CreditReportVC.h"
#import "SettingVC.h"
#import "HTMLStrVC.h"

#import "TLImagePicker.h"
#import "TLUploadManager.h"
#import <UIImageView+WebCache.h>
#import "NSString+Extension.h"
#import "TLProgressHUD.h"

@interface MineVC ()<MineHeaderSeletedDelegate>

//
@property (nonatomic, strong) MineGroup *group;
//
@property (nonatomic, strong) MineTableView *tableView;

@property (nonatomic, strong) MineHeaderView *headerView;

@property (nonatomic, strong) TLImagePicker *imagePicker;
//服务电话
@property (nonatomic, strong) UILabel *mobileLbl;
//服务时间
@property (nonatomic, strong) UILabel *serviceTimeLbl;
//版本号
@property (nonatomic, strong) UILabel *versionLbl;

@end

@implementation MineVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"我的";
    //模型
    [self initGroup];
    //
    [self initTableView];
    //通知
    [self addNotification];
    //
    [self changeInfo];
    //版本号
    [self initVersionView];
    //服务信息
    [self initServiceInfo];
    
    if ([TLUser user].userId) {
        //获取服务时间
        [self requestServiceTime];
        //获取服务电话
        [self requestServiceMobile];
    }
}

- (void)initGroup {
    
    BaseWeakSelf;
    
    //我的资信报告
    MineModel *creditReport = [MineModel new];
    
    creditReport.text = @"我的资信报告";
    creditReport.imgName = @"我的资信报告";
    creditReport.action = ^{
        
        CreditReportVC *creditReportVC = [CreditReportVC new];
        
        creditReportVC.type = ReportTypeLastReport;
        
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
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 100)];
    
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.backgroundColor = kAppCustomMainColor;
    
    imageView.tag = 1500;
    
    [self.view addSubview:imageView];
    
    self.tableView = [[MineTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kTabBarHeight) style:UITableViewStyleGrouped];
    
    self.tableView.mineGroup = self.group;
    
    [self.view addSubview:self.tableView];
    
    //tableview的header
    self.headerView = [[MineHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 100)];
    
    self.headerView.delegate = self;

    self.tableView.tableHeaderView = self.headerView;
    
}

- (TLImagePicker *)imagePicker {
    
    if (!_imagePicker) {
        
        BaseWeakSelf;
        
        _imagePicker = [[TLImagePicker alloc] initWithVC:self];
        
        _imagePicker.allowsEditing = NO;
        _imagePicker.clipHeight = kScreenWidth;
        
        _imagePicker.pickFinish = ^(UIImage *photo, NSDictionary *info){
            
            UIImage *image = info == nil ? photo: info[@"UIImagePickerControllerOriginalImage"];
            
            NSData *imgData = UIImageJPEGRepresentation(image, 0.1);
            
            //进行上传
            [TLProgressHUD show];
            
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
//服务信息
- (void)initServiceInfo {
    
    CGFloat serviceH = 60;
    
    UIView *serviceView = [[UIView alloc] init];
    
    [self.view addSubview:serviceView];
    [serviceView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(self.versionLbl.mas_top).offset(-15);
        make.height.equalTo(@(serviceH));
        make.left.equalTo(@0);
        make.width.equalTo(@(kScreenWidth));
        
    }];
    
    self.mobileLbl = [UILabel labelWithFrame:CGRectMake(0, 0, kScreenWidth, 16) textAligment:NSTextAlignmentCenter backgroundColor:kClearColor font:Font(15) textColor:kTextColor];
    
    [serviceView addSubview:self.mobileLbl];
    
    self.serviceTimeLbl = [UILabel labelWithFrame:CGRectMake(0, self.mobileLbl.yy + 10, kScreenWidth, 12) textAligment:NSTextAlignmentCenter backgroundColor:kClearColor font:Font(15) textColor:kTextColor];
    
    [serviceView addSubview:self.serviceTimeLbl];
    
}

- (void)initVersionView {
    //版本号
    UILabel *versionLbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor font:15.0];
    
    NSDictionary *infoDictionary = [NSBundle mainBundle].infoDictionary;
    
    NSString *version = infoDictionary[@"CFBundleShortVersionString"];
    
    versionLbl.text = [NSString stringWithFormat:@"V %@", version];
    
    [self.view addSubview:versionLbl];
    [versionLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(@0);
        make.bottom.equalTo(@(-20));
        make.height.equalTo(@20);
        
    }];
    
    self.versionLbl = versionLbl;
}

#pragma mark - Notification
- (void)addNotification {
        
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeInfo) name:kUserInfoChange object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginOut) name:kUserLoginOutNotification object:nil];
    
    
}

#pragma mark - Events
- (void)changeInfo {
    //
    
    [self.headerView.userPhoto sd_setImageWithURL:[NSURL URLWithString:[[TLUser user].photo convertImageUrl]] placeholderImage:USER_PLACEHOLDER_SMALL];
    
    self.headerView.nameLbl.text = [TLUser user].mobile;
    
}

- (void)loginOut {
    
    self.headerView.nameLbl.text = @"";
    
    self.headerView.userPhoto.image = USER_PLACEHOLDER_SMALL;
    
}

- (void)changeHeadIconWithKey:(NSString *)key imgData:(NSData *)imgData {
    
    TLNetworking *http = [TLNetworking new];
    
//    http.showView = self.view;
    http.code = USER_CHANGE_USER_PHOTO;
    http.parameters[@"userId"] = [TLUser user].userId;
    http.parameters[@"photo"] = key;
    http.parameters[@"token"] = [TLUser user].token;
    [http postWithSuccess:^(id responseObject) {
        
        [TLProgressHUD dismiss];
        
        [TLAlert alertWithSucces:@"修改头像成功"];
        
        [TLUser user].photo = key;
        //替换头像
        [self.headerView.userPhoto sd_setImageWithURL:[NSURL URLWithString:[key convertImageUrl]] placeholderImage:USER_PLACEHOLDER_SMALL];
        
    } failure:^(NSError *error) {
        
        
    }];
}

- (void)requestServiceTime {
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = USER_CKEY_CVALUE;
    
    http.parameters[@"ckey"] = @"time";
    
    [http postWithSuccess:^(id responseObject) {
        
        self.serviceTimeLbl.text = [NSString stringWithFormat:@"服务时间: %@", responseObject[@"data"][@"cvalue"]];
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)requestServiceMobile {
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = USER_CKEY_CVALUE;
    
    http.parameters[@"ckey"] = @"telephone";
    
    [http postWithSuccess:^(id responseObject) {
        
        self.mobileLbl.text = [NSString stringWithFormat:@"服务电话: %@", responseObject[@"data"][@"cvalue"]];

    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - MineHeaderSeletedDelegate
- (void)didSelectedWithType:(MineHeaderSeletedType)type {
    
    switch (type) {
            
        case MineHeaderSeletedTypeSelectPhoto:
        {
            [self.imagePicker picker];

        }break;
            
        default:
            break;
            
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
