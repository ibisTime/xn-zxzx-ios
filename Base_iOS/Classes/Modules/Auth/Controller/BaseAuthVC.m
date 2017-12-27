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

#import "TLProgressHUD.h"
#import "TLAuthHelper.h"
#import <CoreLocation/CoreLocation.h>
#import "AppMacro.h"

@interface BaseAuthVC ()<CLLocationManagerDelegate>

//调查单
@property (nonatomic, strong) QuestionModel *investModel;
//报告单
@property (nonatomic, strong) QuestionModel *reportModel;
//
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

@end

@implementation BaseAuthVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

#pragma mark - 定位管理
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
            
            
        } else {
            
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
        
        }
        
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
            
            //跳到资质报告
            
        } else {
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
        
        [self pushViewController];
        
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
    [TLAlert alertWithTitle:@"" msg:@"" confirmMsg:@"" cancleMsg:@"" cancle:^(UIAlertAction *action) {
        
    } confirm:^(UIAlertAction *action) {
        
        if (![TLAuthHelper isEnableLocation]) {
            
            // 请求定位授权
            [weakSelf.sysLocationManager requestWhenInUseAuthorization];
            
            [TLAlert alertWithTitle:@"" msg:@"为了更好的为您服务,请在设置中打开定位服务" confirmMsg:@"设置" cancleMsg:@"取消" cancle:^(UIAlertAction *action) {
                
            } confirm:^(UIAlertAction *action) {
                
                [TLAuthHelper openSetting];
                
            }];
            
            return;
            
        }
        
        [weakSelf.sysLocationManager startUpdatingLocation];

    }];
    
    //通讯录认证
    //运营商认证
    //芝麻信用评分
    //行业关注名单
    //欺诈认证
    //同盾认证
    //已完成
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
