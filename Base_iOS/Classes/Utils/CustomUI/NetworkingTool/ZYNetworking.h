//
//  ZYNetworking.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/1/8.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface ZYNetworking : NSObject

+ (AFHTTPSessionManager *)HTTPSessionManager;

@property (nonatomic,strong, readonly) AFHTTPSessionManager *manager;
@property (nonatomic,strong)  NSMutableDictionary *parameters;

@property (nonatomic,copy) NSString *code; //接口编号
@property (nonatomic,strong) UIView *showView; //hud展示superView
@property (nonatomic,assign) BOOL isShowMsg; //是否展示警告信息
@property (nonatomic,copy) NSString *url;
@property (nonatomic, copy) NSString *isShow;


- (NSURLSessionDataTask *)postWithSuccess:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;


+ (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(NSDictionary *)parameters
                       success:( void (^)(id responseObject))success
                       failure: (void (^)(NSError *error))failure;


+ (NSURLSessionDataTask *)GET:(NSString *)URLString
                   parameters:(NSDictionary *)parameters
                      success:(void (^)(NSString *msg,id data))success
                  abnormality:(void (^)())abnormality
                      failure:(void (^)(NSError *error))failure;

//设置请求headers
- (void)setHeaderWithValue:(NSString *)value headerField:(NSString *)headerField;
@end
