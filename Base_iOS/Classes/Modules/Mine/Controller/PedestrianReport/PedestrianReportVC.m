//
//  PedestrianReportVC.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/1/8.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "PedestrianReportVC.h"

#import "CoinHeader.h"
#import "AppConfig.h"

@interface PedestrianReportVC ()

@end

@implementation PedestrianReportVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"我的人行报告";
    
    [AppConfig config].cookie = nil;
    
    //获取图片验证码
    [self requestImgVerify];
}

#pragma mark - Data
- (void)requestImgVerify {
    
    ZYNetworking *http = [ZYNetworking new];

//    http.url = kAppendUrl(@"imgrc.do");
    
    //Accept
    [http setHeaderWithValue:@"image/gif, image/jpeg, image/pjpeg, application/x-ms-application, application/xaml+xml, application/x-ms-xbap, */*" headerField:@"Accept"];
    //Referer
    [http setHeaderWithValue:@"https://ipcrs.pbccrc.org.cn/page/login/loginreg.jsp" headerField:@"Referer"];
    //Cache-Control
    [http setHeaderWithValue:@"no-cache" headerField:@"Cache-Control"];
    //Accept-Encoding
    [http setHeaderWithValue:@"gzip, deflate" headerField:@"Accept-Encoding"];
    //Accept-Language
    [http setHeaderWithValue:@"zh-CN" headerField:@"Accept-Language"];
    //cookie
    if ([AppConfig config].cookie) {
        
        [http setHeaderWithValue:[AppConfig config].cookie headerField:@"Cookie"];
    }
    
    [ZYNetworking GET:kAppendUrl(@"imgrc.do") parameters:nil success:^(NSString *msg, id data) {
        
        
    } abnormality:nil failure:^(NSError *error) {
        
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
