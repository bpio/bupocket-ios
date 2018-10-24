//
//  HTTPManager.m
//  TheImperialPalaceMuseum
//
//  Created by 霍双双 on 17/2/25.
//  Copyright © 2017年 hss. All rights reserved.
//

#import "HTTPManager.h"
#import "HttpTool.h"

//#import "Util.h"

@implementation HTTPManager

+ (HTTPManager *)shareManager
{
    __strong static HTTPManager * shareManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareManager = [[HTTPManager alloc]init];
    });
    return shareManager;
}
#pragma mark -- 辅助函数 处理共同的特性等.
/**
 *  将HTTP的string类型参数转换成字典
 *
 *  @param body phone=1234567&password=321
 *
 *  @return @{@"phone":@"1234567",@"password":@"321"}
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
+ (void)getAssetsDataWithAddress:(NSString *)address
                    currencyType:(NSString *)currencyType
                       tokenList:(NSArray *)tokenList
                         success:(void (^)(id responseObject))success
                         failure:(void (^)(NSError *error))failure
{
    NSString * url = SERVER_COMBINE_API(URLPREFIX, Assets_List);
    //HTTP请求体
    NSDictionary * parmenters = @{@"address": address,
                                  @"currencyType": currencyType,
                                  @"tokenList": tokenList
                                  };
    [[HttpTool shareTool] POST:url parameters:parmenters success:^(id responseObject) {
        if(success != nil)
        {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        if(failure != nil)
        {
            failure(error);
        }
    }];
    
    /*
    
    
    //请求体转换成字典
//    NSDictionary * parameters = [[HTTPManager shareManager] parametersWithHTTPBody:body];
//    NSError * error;
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:parmenters options:NSJSONWritingPrettyPrinted error:nil];
     NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    NSString * jsonString;
    if (jsonData && [jsonData length] > 0) {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    AFURLSessionManager * manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", nil];
    //创建请求request
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:url parameters:nil error:nil];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    // 转NSData作为HTTPBody
    [request setHTTPBody:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
    [[manager dataTaskWithRequest:request uploadProgress:^(NSProgress * _Nonnull uploadProgress) {
        
    } downloadProgress:^(NSProgress * _Nonnull downloadProgress) {
        
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (!error) {
            if (success) {
                success(responseObject);
            }
        } else {
            if (failure) {
                failure(error);
            }
        }
        
    }] resume];
     */
    
//    [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:0 timeoutInterval:30];
//
//    //设置请求方式为POST
//    request.HTTPMethod = @"POST";
//    //设置请求内容格式
////    [request setValue:@"application/json;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
//    request.HTTPBody = data;
//
//    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    manager.requestSerializer = [AFJSONRequestSerializer serializer];
//    [manager.requestSerializer setValue:@"application/json;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html",@"image/jpeg",@"text/plain", nil];
//    [manager.requestSerializer setTimeoutInterval:30.0];
//    NSURLSessionDataTask *dataTask =[manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
//        //8.解析数据
//        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
//        NSLog(@"%@",dict);
//
//    }];
//    //7.执行任务
//    [dataTask resume];
}
// AssetsDetail Transaction_Record
+ (void)getAssetsDetailDataWithAssetCode:(NSString *)assetCode
                                  issuer:(NSString *)issuer
                                 address:(NSString *)address
                               pageIndex:(NSInteger)pageIndex
                                 success:(void (^)(id responseObject))success
                                 failure:(void (^)(NSError *error))failure
{
    NSString * url;
    NSMutableDictionary * parmenters = [NSMutableDictionary dictionary];
    [parmenters addEntriesFromDictionary:@{@"startPage" : @(pageIndex),
                                           @"pageSize" : @(10)}];
    if ([assetCode isEqualToString:@"BU"]) {
        url = SERVER_COMBINE_API(URLPREFIX, Transaction_Record_BU);
        [parmenters setObject:address forKey:@"walletAddress"];
    } else {
        url = SERVER_COMBINE_API(URLPREFIX, Transaction_Record);
        [parmenters addEntriesFromDictionary:@{@"assetCode" : assetCode,
                                               @"issuer" : issuer,
                                               @"address" : address}];
    }
    [[HttpTool shareTool] POST:url parameters:parmenters success:^(id responseObject) {
        if(success != nil)
        {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        if(failure != nil)
        {
            failure(error);
        }
    }];
}

// OrderDetails
+ (void)getOrderDetailsDataWithHash:(NSString *)hash
                            success:(void (^)(id responseObject))success
                            failure:(void (^)(NSError *error))failure
{
    NSString * url = SERVER_COMBINE_API(URLPREFIX, Order_Details);
    NSDictionary * parmenters = @{@"Hash" : hash};
    [[HttpTool shareTool] POST:url parameters:parmenters success:^(id responseObject) {
        if(success != nil)
        {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        if(failure != nil)
        {
            failure(error);
        }
    }];
}

@end
