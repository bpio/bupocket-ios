//
//  NetworkingManager.m
//  bupocket
//
//  Created by bupocket on 2018/10/23.
//  Copyright © 2018年 bupocket. All rights reserved.
//

#import "NetworkingManager.h"
#import "HTTPSessionManager.h"

@interface NetworkingManager ()
{
    NSInteger _loadAppInitalTime;   //  初始化成功的时间
}

@property (nonatomic, strong) HTTPSessionManager * sessionManager;

@end

@implementation NetworkingManager

+ (instancetype)sharedManager
{
    static NetworkingManager *__defaultManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!__defaultManager) {
            __defaultManager = [[NetworkingManager alloc] init];
            __defaultManager.sessionManager = [HTTPSessionManager sessionManager];
            __defaultManager.currentStatus = AFNetworkReachabilityStatusUnknown;
            [__defaultManager.sessionManager.reachabilityManager startMonitoring];
//            __defaultManager.initialModel = [[DZInitialModel alloc] init];
//            NSString *cachedJson = [[NSUserDefaults standardUserDefaults] objectForKey:@"reviewStatus"];
//            __defaultManager.initialModel.review_type = cachedJson;
            
            [__defaultManager.sessionManager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
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
            [__defaultManager.sessionManager.reachabilityManager startMonitoring];
        }
    });
    return __defaultManager;
}

- (NSInteger)getSystemTime
{
    NSInteger tn = (NSInteger)[[NSDate date] timeIntervalSince1970];
//    NSInteger t = [self.initialModel.system_timestamp integerValue] + (tn - _loadAppInitalTime);
    return tn;
}
/*
- (NSString *)signatureWithMethod:(NSString *)method urlString:(NSString *)urlString param:(NSDictionary *)param timestamp:(NSInteger)timestamp
{
    NSString *secret1 = [secretArray substringWithRange:NSMakeRange(200, 16)];
    NSString *secret2 = [secretArray substringWithRange:NSMakeRange(492, 16)];
    
    NSArray* values = [param allKeys];
    NSArray* sortedKeys = [values sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    NSString *query_string = @"";
    for (NSString *key in sortedKeys){
        
        NSString *value = [param objectForKey:key];
        NSString *kv = [NSString stringWithFormat:@"%@=%@", key,value];
        query_string =[NSString stringWithFormat:@"%@%@", query_string, kv];
    }
    
    NSString *r = [NSString stringWithFormat:@"%@:%@:%@:%@:%@%@", method, urlString, query_string, @(timestamp), secret1, secret2];
    return [r md5String];
}
 */

- (NSDictionary *)parametersWithHTTPBody:(NSString *)body
{
    if (body.length == 0) {
        return nil;
    }
    NSArray *array = [body componentsSeparatedByString:@"&"];
    NSMutableDictionary * parameters = [NSMutableDictionary dictionary];
    for (NSString * str in array) {
        NSString * key = [str componentsSeparatedByString:@"="][0];
        NSString * value = [str componentsSeparatedByString:@"="][1];
        [parameters setValue:value forKey:key];
    }
    return parameters;
}

// Assets
- (NSURLSessionDataTask *)getDataWithSuccessHandler:(ResponseObjectSuccessHandler)successHandler failureHandler:(ResponseObjectFailureHandler)failureHandler {
    NSString * url = SERVER_COMBINE_API(URLPREFIX, Assets_List);
    NSArray * tokenList = @[@{@"assetCode":@"CLB", @"issuer":@"buQWESXjdgXSFFajEZfkwi5H4fuAyTGgzkje"}];
    //HTTP请求体
    NSString * body = [NSString stringWithFormat:@"address=%@&currencyType=%@&tokenList=%@&assetCode=%@&issuer=%@", @"buQWESXjdgXSFFajEZfkwi5H4fuAyTGgzkje", @"USD", tokenList, @"", @""];
    //请求体转换成字典
    NSDictionary * parameters = [[NetworkingManager sharedManager] parametersWithHTTPBody:body];
    //    NSData --> NSDictionary
    // NSDictionary --> NSData
    NSData * data = [NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:nil];
    //创建请求request
    NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:0 timeoutInterval:30];
    request.HTTPBody = data;
//    NSString * jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return [self.sessionManager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            if ([responseObject[@"code"] integerValue] == 0) {
                successHandler(@"成功", responseObject[@"data"]);
            } else {
                failureHandler(nil);
                [XHToast showCenterWithText:responseObject[@"msg"]];
            }
        } else {
            failureHandler(nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [XHToast showCenterWithText:error.localizedDescription];
    }];
}

@end
