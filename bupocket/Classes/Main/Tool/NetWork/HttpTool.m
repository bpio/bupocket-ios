//
//  HttpTool.m
//  TheImperialPalaceMuseum
//
//  Created by bupocket on 17/2/25.
//  Copyright © 2017年 hss. All rights reserved.
//

#import "HttpTool.h"
#import "AFNetworking.h"

@interface HttpTool()

@property (nonatomic, strong) AFURLSessionManager * sessionManager;

@end

@implementation HttpTool

static HttpTool * _shareTool = nil;
+ (instancetype)shareTool
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!_shareTool) {
            _shareTool = [[HttpTool alloc] init];
             NSURLSessionConfiguration * sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
             sessionConfiguration.timeoutIntervalForRequest = Timeout_Interval;
             sessionConfiguration.requestCachePolicy = NSURLRequestReloadIgnoringCacheData;
            _shareTool.sessionManager = [[AFURLSessionManager alloc] initWithSessionConfiguration:sessionConfiguration];
            [_shareTool.sessionManager.reachabilityManager startMonitoring];
        }
    });
    return _shareTool;
}


- (void)GET:(NSString *)URLString parameters:(NSDictionary *)parameters success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    [MBProgressHUD showActivityMessageInWindow:Localized(@"Loading")];
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    [manager GET:URLString parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [MBProgressHUD hideHUD];
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD hideHUD];
        if (failure) {
            failure(error);
            [MBProgressHUD showTipMessageInWindow:Localized(@"NoNetWork")];
        }
    }];
}
- (void)POST:(NSString *)URLString parameters:(NSDictionary *)parameters success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    NSMutableURLRequest * request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:URLString parameters:nil error:nil];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPBody:[[JsonTool JSONStringWithDictionaryOrArray:parameters] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [[self.sessionManager dataTaskWithRequest:request uploadProgress:^(NSProgress * _Nonnull uploadProgress) {
        
    } downloadProgress:^(NSProgress * _Nonnull downloadProgress) {
        
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (!error) {
            [MBProgressHUD hideHUD];
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                if (success) {
                    success(responseObject);
                }
            }
        } else {
            [MBProgressHUD hideHUD];
            if (failure) {
                failure(error);
                [MBProgressHUD showTipMessageInWindow:Localized(@"NoNetWork")];
            }
        }
    }] resume];
}
@end
