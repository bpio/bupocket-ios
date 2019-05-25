//
//  HttpTool.m
//  bupocket
//
//  Created by bupocket on 17/2/25.
//  Copyright © 2017年 bupocket. All rights reserved.
//

#import "HttpTool.h"
#import <AFNetworking/AFNetworking.h>

@interface HttpTool()

@property (nonatomic, strong) AFURLSessionManager * sessionManager;
@property (nonatomic, strong) AFHTTPSessionManager * manager;

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
            _shareTool.manager = [AFHTTPSessionManager manager];
            _shareTool.manager.requestSerializer = [AFHTTPRequestSerializer serializer];
            [_shareTool.manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            _shareTool.manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"text/json", @"text/javascript", @"text/html", @"text/plain", nil];
            [_shareTool.manager.requestSerializer setTimeoutInterval:Timeout_Interval];
        }
    });
    return _shareTool;
}
+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shareTool = [super allocWithZone:zone];
    });
    return _shareTool;
}
- (id)copyWithZone:(NSZone *)zone
{
    return _shareTool;
}

- (void)GET:(NSString *)URLString parameters:(NSDictionary *)parameters success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    [self.manager GET:URLString parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
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
    NSData * requestPostData = [[JsonTool JSONStringWithDictionaryOrArray:parameters] dataUsingEncoding:NSUTF8StringEncoding];
    [request setValue:[NSString stringWithFormat:@"%lu",(unsigned long)[requestPostData length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:requestPostData];
    
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
            }
        }
    }] resume];
}
@end
