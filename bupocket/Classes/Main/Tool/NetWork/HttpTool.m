//
//  HttpTool.m
//  TheImperialPalaceMuseum
//
//  Created by 霍双双 on 17/2/25.
//  Copyright © 2017年 hss. All rights reserved.
//

#import "HttpTool.h"
#import <AFNetworking.h>
#import <MBProgressHUD.h>
//#import <Reachability.h>

@implementation HttpTool

+ (HttpTool *)shareTool
{
    __strong static HttpTool * shareTool;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareTool = [[HttpTool alloc]init];
    });
    return shareTool;
}
+ (void)GET:(NSString *)URLString parameters:(NSDictionary *)parameters success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
//    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
//    [SVProgressHUD showWithStatus:@"加载中, 请稍后..."];
//    [MBProgressHUD showActivityMessageInWindow:nil];
//    Reachability * reachability = [Reachability reachabilityWithHostname:@""];
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setTimeoutInterval:30.0];
    [manager GET:URLString parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
//            [SVProgressHUD dismiss];
//            [MBProgressHUD hideHUD];
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
//            [SVProgressHUD dismiss];
//            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
//            [MBProgressHUD hideHUD];
//            [MBProgressHUD showErrorMessage:error.localizedDescription];
            if (error.code != -1009) {
            }
        }
    }];
//    [reachability stopNotifier];
}
+ (void)POST:(NSString *)URLString parameters:(NSDictionary *)parameters success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
//    Reachability * reachability = [Reachability reachabilityWithHostname:@""];
//    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
//    [SVProgressHUD showWithStatus:@"加载中, 请稍后..."];
//    [MBProgressHUD showActivityMessageInWindow:nil];
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setTimeoutInterval:30.0];
    [manager POST:URLString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
//            [SVProgressHUD dismiss];
//            [MBProgressHUD hideHUD];
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
//            [MBProgressHUD hideHUD];
//            [MBProgressHUD showErrorMessage:error.localizedDescription];
//            [SVProgressHUD dismiss];
//            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
            if (error.code != -1009) {
            }
        }
    }];
//    [reachability stopNotifier];
}

+ (void)POSTHtml:(NSString *)URLString parameters:(NSDictionary *)parameters success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
//    Reachability * reachability = [Reachability reachabilityWithHostname:@""];
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html",@"image/jpeg",@"text/plain", nil];
    [manager.requestSerializer setTimeoutInterval:30.0];
    [manager POST:URLString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
//    [reachability startNotifier];
}

@end
