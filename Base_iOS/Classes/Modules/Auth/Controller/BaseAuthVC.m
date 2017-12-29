//
//  BaseAuthVC.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/12/27.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "BaseAuthVC.h"

//M
#import "QuestionModel.h"
//C
#import "QuestionRemarkVC.h"
#import "ZMAuthVC.h"
#import "BaseInfoAuthVC.h"
#import "IdAuthVC.h"
#import "ContactAuthVC.h"
#import "TongDunVC.h"
#import "ZMOPScoreVC.h"
#import "ZMFoucsNameVC.h"
#import "CreditReportVC.h"

#import "TLProgressHUD.h"
#import "TLAuthHelper.h"
#import <CoreLocation/CoreLocation.h>
#import "AppMacro.h"
#import "UIBarButtonItem+convience.h"

@interface BaseAuthVC ()<CLLocationManagerDelegate>

//调查单
@property (nonatomic, strong) QuestionModel *investModel;
//报告单
@property (nonatomic, strong) QuestionModel *reportModel;
//定位
@property (nonatomic,strong) CLLocationManager *sysLocationManager;

@property (nonatomic,copy) NSString *province;
@property (nonatomic,copy) NSString *city;
@property (nonatomic,copy) NSString *area;
//详细地址
@property (nonatomic, copy) NSString *address;
//经度
@property (nonatomic,copy) NSString *lon;
//纬度
@property (nonatomic,copy) NSString *lat;
//运营商认证
//是否完成
@property (nonatomic, copy) NSString *isApply;

@end

@implementation BaseAuthVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //如果不是根控制器就添加返回按钮
    if (![self isRootViewController]) {
        
        [self initBackItem];
    }
}

- (void)initBackItem {
    
//    self.navigationController.viewControllers
    [UIBarButtonItem addLeftItemWithImageName:@"返回-白色" frame:CGRectMake(-10, 0, 40, 44) vc:self action:@selector(clickBack)];

}

- (void)clickBack {
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - 定位认证
- (CLLocationManager *)sysLocationManager {
    
    if (!_sysLocationManager) {
        
        _sysLocationManager = [[CLLocationManager alloc] init];
        _sysLocationManager.delegate = self;
        _sysLocationManager.distanceFilter = 50.0;
        
    }
    return _sysLocationManager;
    
}

#pragma mark - 系统定位
- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
    
    [TLAlert alertWithInfo:@"定位失败"];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    [manager stopUpdatingLocation];
    
    CLGeocoder *gecoder = [[CLGeocoder alloc] init];
    CLLocation *location = manager.location;
    
    [gecoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        
        CLPlacemark *placemark = [placemarks lastObject];
        
        if (error) {
            
            return ;
        }
        
        self.lon = [NSString stringWithFormat:@"%.10f", location.coordinate.longitude];
        
        self.lat = [NSString stringWithFormat:@"%.10f", location.coordinate.latitude];
        
        self.province = placemark.administrativeArea ;
        self.city = placemark.locality ? : placemark.administrativeArea; //市
        self.area = placemark.subLocality; //区
        
        //道路
        NSString *road = placemark.thoroughfare;
        STRING_NIL_NULL(road);
        //具体地方
        NSString *building = placemark.name;
        STRING_NIL_NULL(building);
        //详细地址
        self.address = [NSString stringWithFormat:@"%@%@", road,building];
        
        [self locationAuth];
    }];
    
}

/**
 定位认证
 */
- (void)locationAuth {
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"805255";
    http.parameters[@"searchCode"] = [TLUser user].tempSearchCode;
    
    http.parameters[@"province"] = self.province;
    http.parameters[@"city"] = self.city;
    http.parameters[@"area"] = self.area;
    http.parameters[@"address"] = self.address;
    http.parameters[@"latitude"] = self.lat;
    http.parameters[@"longitude"] = self.lon;
    
    [http postWithSuccess:^(id responseObject) {
        
        [TLProgressHUD dismiss];
        
        [TLAlert alertWithSucces:@"定位认证成功"];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self pushViewController];
            
        });
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - 运营商认证
- (void)authRespWithTaskId:(NSString *)taskId {
    
    [TLProgressHUD show];
    
    //获取用户当前正在进行的申请记录
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"805256";
    
    http.parameters[@"userId"] = [TLUser user].userId;
    http.parameters[@"searchCode"] = [TLUser user].tempSearchCode;
    http.parameters[@"taskId"] = taskId;
    
    [http postWithSuccess:^(id responseObject) {
        
        [self requestCarrierStatus];
        
    } failure:^(NSError *error) {
        
    }];
}

//获取运营商状态
- (void)requestCarrierStatus {
    
    //认证结果查询
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"805334";
    http.showView = self.view;
    http.parameters[@"reportCode"] = [TLUser user].tempReportCode;
    
    [http postWithSuccess:^(id responseObject) {
        
        QuestionModel *questionModel = [QuestionModel mj_objectWithKeyValues:responseObject[@"data"]];
        
        //运营商是否已认证(0:未认证  1:等待中  2:成功  3:失败)
        if ([questionModel.PYYS4Status isEqualToString:@"2"]) {
            
            [TLAlert alertWithSucces:@"运营商认证成功"];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [self pushViewController];

            });
            
        } else if([questionModel.PYYS4Status isEqualToString:@"1"]){
            
            //重复调认证状态接口
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [self requestCarrierStatus];
                
            });
            
        } else {
            
            [TLAlert alertWithTitle:@"提示" message:@"运营商认证失败, 请重新认证" confirmMsg:@"OK" confirmAction:^{
                
                [self.navigationController popToRootViewControllerAnimated:YES];
            }];
        }
        
        
    } failure:^(NSError *error) {
        
        
    }];
}

#pragma mark - 欺诈信息认证

/**
 欺诈信息认证
 */
- (void)cheatAuth {
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"805260";
    http.showView = self.view;
    http.parameters[@"searchCode"] = [TLUser user].tempSearchCode;
    
    http.parameters[@"isH5"] = @"0";
    http.parameters[@"ip"] = [NSString getIPAddress:YES];;
    http.parameters[@"wifimac"] = [NSString getWifiMacAddress];
    http.parameters[@"mac"] = @"";
    http.parameters[@"imei"] = @"";
    
    [http postWithSuccess:^(id responseObject) {
        
        [TLAlert alertWithSucces:@"欺诈信息认证成功"];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self pushViewController];
            
        });
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - 同盾认证

/**
 同盾认证
 */
- (void)tongDunAuth {
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"805261";
    http.showView = self.view;
    http.parameters[@"searchCode"] = [TLUser user].tempSearchCode;
    
    [http postWithSuccess:^(id responseObject) {
        
        [TLAlert alertWithSucces:@"同盾认证成功"];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self pushViewController];
            
        });
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - Data
/**
 查询调查单详情
 */
- (void)queryInvestDetail {
    
    [TLProgressHUD show];
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"805281";
    http.parameters[@"code"] = [TLUser user].tempSearchCode;
    
    [http postWithSuccess:^(id responseObject) {
        
        self.investModel = [QuestionModel mj_objectWithKeyValues:responseObject[@"data"]];
        
        //调查单状态是已完成
        if ([self.investModel.status isEqualToString:@"2"]) {
            
            [TLProgressHUD dismiss];

            //跳到资质报告
            CreditReportVC *reportVC = [CreditReportVC new];
            
            reportVC.type = ReportTypeLookReport;
            
            [self.navigationController pushViewController:reportVC animated:YES];
            
        } else if ([self.investModel.status isEqualToString:@"3"]) {
            //调查单已过期
            [TLProgressHUD dismiss];

            [TLAlert alertWithInfo:@"调查单已过期"];
            
        }else {
            //查询报关单详情
            [self queryQuestionDetail];
        }
        
    } failure:^(NSError *error) {
        
        
    }];
}
/**
 查询报关单详情
 */
- (void)queryQuestionDetail {
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"805334";
    http.parameters[@"reportCode"] = [TLUser user].tempReportCode;
    
    [http postWithSuccess:^(id responseObject) {
        
        [TLProgressHUD dismiss];

        self.reportModel = [QuestionModel mj_objectWithKeyValues:responseObject[@"data"]];
        
        [self vcShouldPush];
        
    } failure:^(NSError *error) {
        
        
    }];
}

#pragma mark - PushVC

- (void)pushViewController {
    
    //查询报关单详情
    [self queryInvestDetail];

}
//跳到下个界面
- (void)vcShouldPush {
    
    BaseWeakSelf;
    
    //芝麻认证
    if ([self.investModel.F2 isEqualToString:@"Y"] && self.reportModel.F2 == nil) {
        
        QuestionRemarkVC *remarkVC = [QuestionRemarkVC new];
        
        [self.navigationController pushViewController:remarkVC animated:YES];
        
        return ;
    }
    //基本信息认证
    if ([self.investModel.F3 isEqualToString:@"Y"] && self.reportModel.F3 == nil) {
        
        BaseInfoAuthVC *baseInfoAuthVC = [BaseInfoAuthVC new];
        
        [self.navigationController pushViewController:baseInfoAuthVC animated:YES];
        
        return ;
    }
   
    //身份证认证
    if ([self.investModel.PID1 isEqualToString:@"Y"] && self.reportModel.PID1 == nil) {
        
        IdAuthVC *idAuthVC = [IdAuthVC new];
        
        [self.navigationController pushViewController:idAuthVC animated:YES];
        
        return ;
    }
    
    //定位认证
    if ([self.investModel.PDW2 isEqualToString:@"Y"] && self.reportModel.PDW2 == nil) {
        
        [TLAlert alertWithTitle:@"提示" msg:@"是否进行定位认证?" confirmMsg:@"确认" cancleMsg:@"取消" cancle:^(UIAlertAction *action) {
            
        } confirm:^(UIAlertAction *action) {
            
            if (![TLAuthHelper isEnableLocation]) {
                
                // 请求定位授权
                [weakSelf.sysLocationManager requestWhenInUseAuthorization];
                
                [TLAlert alertWithTitle:@"提示" msg:@"为了更好的为您服务,请在设置中打开定位服务" confirmMsg:@"设置" cancleMsg:@"取消" cancle:^(UIAlertAction *action) {
                    
                } confirm:^(UIAlertAction *action) {
                    
                    [TLAuthHelper openSetting];
                    
                }];
                
                return;
                
            }
            
            [TLProgressHUD show];
            
            [weakSelf.sysLocationManager startUpdatingLocation];
            
        }];
        
        return ;
    }
    
    //通讯录认证
    if ([self.investModel.PTXL3 isEqualToString:@"Y"] && self.reportModel.PTXL3 == nil) {
        
        ContactAuthVC *contactAuthVC = [ContactAuthVC new];
        
        [self.navigationController pushViewController:contactAuthVC animated:YES];
        
        return ;
    }
    //运营商认证
    
    if ([self.investModel.PYYS4 isEqualToString:@"Y"] && self.reportModel.PYYS4 == nil) {
        
        TongDunVC *yysAuthVC = [TongDunVC new];
        
        yysAuthVC.respBlock = ^(NSString *taskId) {
            
            [weakSelf authRespWithTaskId:taskId];
        };
        
        [self.navigationController pushViewController:yysAuthVC animated:YES];
        
        return ;
    }
    

    //芝麻信用评分
    if ([self.investModel.PZM5 isEqualToString:@"Y"] && self.reportModel.PZM5 == nil) {
        
        ZMOPScoreVC *zmOPScoreVC = [ZMOPScoreVC new];
        
        [self.navigationController pushViewController:zmOPScoreVC animated:YES];
        
        return ;
    }
    //行业关注名单
    if ([self.investModel.PZM6 isEqualToString:@"Y"] && self.reportModel.PZM6 == nil) {
        
        ZMFoucsNameVC *foucsNameVC = [ZMFoucsNameVC new];
        
        [self.navigationController pushViewController:foucsNameVC animated:YES];
        
        return ;
    }
    //欺诈认证
    if ([self.investModel.PZM7 isEqualToString:@"Y"] && self.reportModel.PZM7 == nil) {
        
        [TLAlert alertWithTitle:@"提示" msg:@"是否进行欺诈信息认证?" confirmMsg:@"确认" cancleMsg:@"取消" cancle:^(UIAlertAction *action) {
            
        } confirm:^(UIAlertAction *action) {
            
            [self cheatAuth];
        }];
        
        return ;
    }
    //同盾认证
    if ([self.investModel.PTD8 isEqualToString:@"Y"] && self.reportModel.PTD8 == nil) {
        
        [TLAlert alertWithTitle:@"提示" msg:@"是否进行同盾认证?" confirmMsg:@"确认" cancleMsg:@"取消" cancle:^(UIAlertAction *action) {
            
        } confirm:^(UIAlertAction *action) {
            
            [self tongDunAuth];
        }];
        
        return ;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
