//
//  HttpTool.m
//  TheImperialPalaceMuseum
//
//  Created by bupocket on 17/2/25.
//  Copyright © 2017年 hss. All rights reserved.
//

#import "HttpTool.h"
#import "AFNetworking.h"

//#import <MBProgressHUD.h>
//#import <Reachability.h>

@interface HttpTool()

@property (nonatomic, strong) AFURLSessionManager * sessionManager;

@end

@implementation HttpTool

static HttpTool *__shareTool = nil;
+ (instancetype)shareTool
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!__shareTool) {
            __shareTool = [[HttpTool alloc] init];
             NSURLSessionConfiguration * sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
             sessionConfiguration.timeoutIntervalForRequest = 30.f;
             sessionConfiguration.requestCachePolicy = NSURLRequestReloadIgnoringCacheData;//NSURLRequestUseProtocolCachePolicy;
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
//            sessionTool.responseSerializer = [AFHTTPResponseSerializer serializer];
            //    sessionTool.requestSerializer = [AFJSONRequestSerializer serializer];
            //    [sessionTool.requestSerializer setValue:@"application/json;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
            //    sessionTool.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
            __shareTool.sessionManager = [[AFURLSessionManager alloc] initWithSessionConfiguration:sessionConfiguration];
//            __shareTool.sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html",@"image/jpeg",@"text/plain", nil];
//            __shareTool.currentStatus = AFNetworkReachabilityStatusUnknown;
//            [__shareTool.sessionManager.reachabilityManager startMonitoring];
            //            __defaultManager.initialModel = [[DZInitialModel alloc] init];
            //            NSString *cachedJson = [[NSUserDefaults standardUserDefaults] objectForKey:@"reviewStatus"];
            //            __defaultManager.initialModel.review_type = cachedJson;
            
            [__shareTool.sessionManager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
                switch (status) {
                    case AFNetworkReachabilityStatusUnknown: {
                    }
                        break;
                    case AFNetworkReachabilityStatusNotReachable: {
                    }
                        break;
                    case AFNetworkReachabilityStatusReachableViaWWAN:
                    {
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"netAppNotification"object:nil];
                    }
                        break;
                    case AFNetworkReachabilityStatusReachableViaWiFi:
                    {
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"netAppNotification"object:nil];
                    }
                        break;
                    default:
                        break;
                }
            }];
            [__shareTool.sessionManager.reachabilityManager startMonitoring];
        }
    });
    return __shareTool;
}


+ (void)GET:(NSString *)URLString parameters:(NSDictionary *)parameters success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
//    [MBProgressHUD wb_showActivity];
    [MBProgressHUD showActivityMessageInWindow:Localized(@"Loading")];
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setTimeoutInterval:30.0];
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
        }
    }];
}
- (void)POST:(NSString *)URLString parameters:(NSDictionary *)parameters success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    NSMutableURLRequest * request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:URLString parameters:nil error:nil];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    // NSaData -> HTTPBody
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
                [MBProgressHUD showTipMessageInWindow:error.localizedDescription];
            }
        }
    }] resume];
}
/*
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
*/
@end
