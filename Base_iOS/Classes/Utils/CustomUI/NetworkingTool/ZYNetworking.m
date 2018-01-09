//
//  ZYNetworking.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/1/8.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "ZYNetworking.h"

#import "SVProgressHUD.h"
#import "AppConfig.h"
#import "HttpLogger.h"
#import "TLProgressHUD.h"
#import "TLUser.h"
#import "TLAlert.h"

@implementation ZYNetworking
//默认header：User-Agent、Connection、Content-Type

/*Cache-Control
[http setHeaderWithValue:@"no-cache" headerField:@"Cache-Control"];
//Accept-Encoding
[http setHeaderWithValue:@"gzip, deflate, br" headerField:@"Accept-Encoding"];
//Accept-Language
[http setHeaderWithValue:@"zh-CN,zh;q=0.9,en;q=0.8" headerField:@"Accept-Language"];
*/
+ (AFHTTPSessionManager *)HTTPSessionManager
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer.timeoutInterval = 15.0;
    //Cache-Control
    [manager.requestSerializer setValue:@"no-cache" forHTTPHeaderField:@"Cache-Control"];
    //Accept-Encoding
    [manager.requestSerializer setValue:@"gzip, deflate, br" forHTTPHeaderField:@"Accept-Encoding"];
    //Accept-Language
    [manager.requestSerializer setValue:@"zh-CN,zh;q=0.9,en;q=0.8" forHTTPHeaderField:@"Accept-Language"];
    //Cookie
    if ([AppConfig config].cookie) {
        
        [manager.requestSerializer setValue:[AppConfig config].cookie forHTTPHeaderField:@"Cookie"];
    }
    //
//    [manager.requestSerializer setValue:@"image/gif, image/jpeg, image/pjpeg, application/x-ms-application, application/xaml+xml, application/x-ms-xbap, */*" forHTTPHeaderField:@"Accept"];
//    //Referer
//    [manager.requestSerializer setValue:@"https://ipcrs.pbccrc.org.cn/page/login/loginreg.jsp" forHTTPHeaderField:@"Referer"];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/html",@"text/plain", nil];
    
    return manager;
}

+ (NSString *)serveUrl {
    
    return [[self baseUrl] stringByAppendingString:@"/forward-service/api"];
}

+ (NSString *)baseUrl {
    
    return [AppConfig config].pedestAddr;
    
}

+ (NSString *)systemCode {
    
    return [AppConfig config].systemCode;
    
}

+ (NSString *)companyCode {
    
    return [AppConfig config].companyCode;
}

- (instancetype)init {
    
    if(self = [super init]) {
        
        _manager = [[self class] HTTPSessionManager];
        _isShowMsg = YES;
        self.parameters = [NSMutableDictionary dictionary];
        
    }
    return self;
    
}

- (NSURLSessionDataTask *)postWithSuccess:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    //如果想要设置其它 请求头信息 直接设置 HTTPSessionManager 的 requestSerializer 就可以了，不用直接设置 NSURLRequest
    
    if(self.showView) {
        
        [TLProgressHUD show];
    }
    
    if (self.parameters) {
        
        NSData *data = [NSJSONSerialization dataWithJSONObject:self.parameters options:NSJSONWritingPrettyPrinted error:nil];
        self.parameters = [NSMutableDictionary dictionaryWithCapacity:2];
        self.parameters[@"code"] = self.code;
        self.parameters[@"json"] = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    
    if (!self.url || !self.url.length) {
        NSLog(@"url 不存在啊");

        return nil;
    }

    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.url]];
    
    [HttpLogger logDebugInfoWithRequest:request apiName:self.code requestParams:self.parameters httpMethod:@"POST"];
    
    return [self.manager POST:self.url parameters:self.parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [HttpLogger logDebugInfoWithResponse:task.response apiName:self.code resposeString:responseObject request:task.originalRequest error:nil];
        
        //打印JSON字符串
        [HttpLogger logJSONStringWithResponseObject:responseObject];
        
        if(self.showView) {
            
            [TLProgressHUD dismiss];
        }
        
        if([responseObject[@"errorCode"] isEqual:@"0"]){ //成功
            
            if(success) {
                
                success(responseObject);
            }
            
        } else {
            
            if (failure) {
                
                failure(nil);
            }
            
            if ([responseObject[@"errorCode"] isEqual:@"4"]) {
                //token错误  4
                
                [TLAlert alertWithTitle:nil message:@"为了您的账户安全，请重新登录" confirmAction:^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:kUserLoginOutNotification object:nil];
                }];
                return;
            }
            
            if(self.isShowMsg) { //异常也是失败
                
                [TLAlert alertWithInfo:responseObject[@"errorInfo"]];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if(self.showView) {
            
            [TLProgressHUD dismiss];
        }
        
        if (self.isShowMsg) {
            
            [TLAlert alertWithInfo:@"网络异常"];
        }
        
        if(failure) {
            
            failure(error);
        }
        
    }];
    
}

- (void)hundleSuccess:(id)responseObj {
    
    if([responseObj[@"success"] isEqual:@1]){
        
        
    }
}

+ (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(NSDictionary *)parameters
                       success:(void (^)(id responseObject))success
                       failure: (void (^)(NSError *error))failure{
    
    AFHTTPSessionManager *manager = [self HTTPSessionManager];
    
    return [manager POST:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (success) {
            
            success(responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if(failure){
            
            failure(error);
        }
        
    }];
    
    
}

+ (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(NSDictionary *)parameters
                       success:(void (^)(id responseObject))success
                   abnormality:(void (^)(NSString *msg))abnormality
                       failure:(void (^)(NSError * _Nullable  error))failure;
{
    //先检查网络
    
    AFHTTPSessionManager *manager = [self HTTPSessionManager];
    
    return [manager POST:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if(failure) {
            
            failure(error);
        }
        
    }];
    
}


//#pragma mark - GET
- (NSURLSessionDataTask *)GET:(NSString *)URLString
                      success:(void (^)(NSString *msg,id data))success
                      failure:(void (^)(NSError *error))failure;
{
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:URLString]];

    [HttpLogger logDebugInfoWithRequest:request apiName:@"" requestParams:self.parameters httpMethod:@"GET"];

    return [_manager GET:URLString parameters:self.parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [HttpLogger logDebugInfoWithResponse:task.response apiName:nil resposeString:responseObject request:task.originalRequest error:nil];
        
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        //设置cookie
        NSString *cookie = response.allHeaderFields[@"Set-Cookie"];
        [AppConfig setUserDefaultCookie:cookie];
        
        if (success) {
            
            success(@"",responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (failure) {
            
            failure(error);
        }
    }];
}

#pragma mark - Header
//设置请求headers
- (void)setHeaderWithValue:(NSString *)value headerField:(NSString *)headerField {
    
    [_manager.requestSerializer setValue:value forHTTPHeaderField:headerField];
}

@end
