//
//  HTTPSessionManager.m
//  bupocket
//
//  Created by bupocket on 2018/10/23.
//  Copyright © 2018年 bupocket. All rights reserved.
//

#import "HTTPSessionManager.h"

@implementation HTTPSessionManager

+ (instancetype)sessionManager
{
    NSURLSessionConfiguration *resourceSessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    resourceSessionConfiguration.timeoutIntervalForRequest = 30.f;
    resourceSessionConfiguration.requestCachePolicy = NSURLRequestReloadIgnoringCacheData;//NSURLRequestUseProtocolCachePolicy;
    HTTPSessionManager * sessionManager = [[HTTPSessionManager alloc] initWithSessionConfiguration:resourceSessionConfiguration];
    /*
     [sessionManager addDeviceInfoHeader];
     sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/plain", @"text/html", nil];
    NSString *agentString = nil;
    NSString *channel = nil;
    //liaoai;liaoai_lwm;liaoai_biwei;liaoai_lizhen;liaoai_teyue;liaoai_liaopai
    agentString = @"dianzhuan_ios";
    channel = @"dianzhuan_ios";
    
    NSString *userAgent = [NSString stringWithFormat:@"%@;%@;%@;%@;%@;%@", agentString,[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"], [[UIDevice currentDevice] model], [[UIDevice currentDevice] systemVersion], [[UIDevice currentDevice] machineModelName],channel];
    if (userAgent) {
        if (![userAgent canBeConvertedToEncoding:NSASCIIStringEncoding]) {
            NSMutableString *mutableUserAgent = [userAgent mutableCopy];
            if (CFStringTransform((__bridge CFMutableStringRef)(mutableUserAgent), NULL, (__bridge CFStringRef)@"Any-Latin; Latin-ASCII; [:^ASCII:] Remove", false)) {
                userAgent = mutableUserAgent;
            }
        }
        [sessionManager.requestSerializer setValue:userAgent forHTTPHeaderField:@"User-Agent"];
    }
     */
    sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
    [sessionManager.requestSerializer setValue:@"application/json;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    
    return sessionManager;
}
- (void)addDeviceInfoHeader
{
}
#pragma mark - Override
- (NSURLSessionDataTask *)GET:(NSString *)URLString parameters:(id)parameters progress:(void (^)(NSProgress * _Nonnull))downloadProgress success:(void (^)(NSURLSessionDataTask * _Nonnull, id _Nullable))success failure:(void (^)(NSURLSessionDataTask * _Nullable, NSError * _Nonnull))failure
{
    NSURLSessionDataTask *dataTask = [super GET:URLString parameters:parameters progress:[downloadProgress copy] success:^(NSURLSessionDataTask *task, id responseObject) {
        success(task, responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSError *err = [self transportErrorWithResponseError:error];
        failure(task, err);
    }];
    return dataTask;
}
- (NSURLSessionDataTask *)POST:(NSString *)URLString parameters:(id)parameters progress:(void (^)(NSProgress * _Nonnull))uploadProgress success:(void (^)(NSURLSessionDataTask * _Nonnull, id _Nullable))success failure:(void (^)(NSURLSessionDataTask * _Nullable, NSError * _Nonnull))failure
{
    return [super POST:URLString parameters:parameters progress:[uploadProgress copy] success:^(NSURLSessionDataTask *task, id responseObject) {
        success(task, responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSError *err = [self transportErrorWithResponseError:error];
        failure(task, err);
    }];
}
- (NSURLSessionDataTask *)POST:(NSString *)URLString parameters:(id)parameters constructingBodyWithBlock:(void (^)(id<AFMultipartFormData> _Nonnull))block progress:(void (^)(NSProgress * _Nonnull))uploadProgress success:(void (^)(NSURLSessionDataTask * _Nonnull, id _Nullable))success failure:(void (^)(NSURLSessionDataTask * _Nullable, NSError * _Nonnull))failure
{
    return [super POST:URLString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> __nonnull multipartFormData) {
        block(multipartFormData);
    } progress:[uploadProgress copy] success:^(NSURLSessionDataTask *task, id responseObject) {
        success(task, responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSError *err = [self transportErrorWithResponseError:error];
        failure(task, err);
    }];
}



#pragma mark - Error handlers

- (NSError *)transportErrorWithResponseError:(NSError *)error {
    NSData *errorData =error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
    if (errorData) {
        NSDictionary *errorJSON = [NSJSONSerialization JSONObjectWithData:errorData options:NSJSONReadingAllowFragments|NSJSONReadingMutableContainers error:nil];
        if (errorJSON && errorJSON[@"development_reason"] && errorJSON[@"message"]) {
            NSDictionary *userInfo = @{@"development_reason":errorJSON[@"development_reason"], @"message" : errorJSON[@"message"], @"realm" : errorJSON[@"message"]};
            NSError *serverError = [NSError errorWithDomain:@"com.heydo.papa.networking.api.error" code:[errorJSON[@"code"] intValue] userInfo:userInfo];
            return serverError;
        }
    }
    return error;
}


@end
