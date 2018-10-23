//
//  NetWork.m
//  bupocket
//
//  Created by bupocket on 2018/10/23.
//  Copyright © 2018年 bupocket. All rights reserved.
//

#import "NetWork.h"
#import "URLRequestSerialization.h"
#import "HTTPRequestOperationManager.h"

@implementation NetWork

//不带parameters
+(void)requestWithMethod:(NSString *)method
                     URL:(NSString *)URL
                 success:(void (^)(NSData *__nullable data,NSURLResponse * __nullable response))success
                 failure:(void (^)(NSError *__nullable error))failure
{
    
    HTTPRequestOperationManager *manange = [[HTTPRequestOperationManager alloc] initWithMethod:method URL:URL parameters:nil];
    [manange driveTask:success failure:failure];
}


//GET不带parameters
+(void)requestGetWithURL:(NSString *)URL
                 success:(void (^)(NSData *__nullable data,NSURLResponse * __nullable response))success
                 failure:(void (^)(NSError *__nullable error))failure
{
    
    HTTPRequestOperationManager *manange = [[HTTPRequestOperationManager alloc] initWithMethod:@"GET" URL:URL parameters:nil];
    [manange driveTask:success failure:failure];
}
//GET带parameters
+(void)requestGetWithURL:(NSString *)URL
              parameters:(id) parameters
                 success:(void (^)(NSData *__nullable data,NSURLResponse * __nullable response))success
                 failure:(void (^)(NSError *__nullable error))failure
{
    
    HTTPRequestOperationManager *manange = [[HTTPRequestOperationManager alloc] initWithMethod:@"GET" URL:URL parameters:parameters];
    [manange driveTask:success failure:failure];
}



//POST不带parameters
+(void)requestPostWithURL:(NSString *)URL
                  success:(void (^)(NSData *__nullable data,NSURLResponse * __nullable response))success
                  failure:(void (^)(NSError *__nullable error))failure
{
    
    HTTPRequestOperationManager *manange = [[HTTPRequestOperationManager alloc] initWithMethod:@"POST" URL:URL parameters:nil];
    [manange driveTask:success failure:failure];
}
//POST带parameters
+(void)requestPostWithURL:(NSString *)URL
               parameters:(id) parameters
                  success:(void (^)(NSData *__nullable data,NSURLResponse * __nullable response))success
                  failure:(void (^)(NSError *__nullable error))failure
{
    
    HTTPRequestOperationManager *manange = [[HTTPRequestOperationManager alloc] initWithMethod:@"POST" URL:URL parameters:parameters];
    [manange driveTask:success failure:failure];
}

@end
