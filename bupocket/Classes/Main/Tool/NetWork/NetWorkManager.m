//
//  NetWorkManager.m
//  bupocket
//
//  Created by bupocket on 2018/10/23.
//  Copyright © 2018年 bupocket. All rights reserved.
//

#import "NetWorkManager.h"
#import "NetWork.h"

@implementation NetWorkManager

+ (NetWorkManager *)shareManager
{
    __strong static NetWorkManager * shareManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareManager = [[NetWorkManager alloc]init];
    });
    return shareManager;
}

// Assets
+ (void)getDataWithSuccess:(void (^)(id responseObject))success
                   failure:(void (^)(NSError *error))failure {
    NSString * url = SERVER_COMBINE_API(URLPREFIX, Assets_List);
    //    NSArray * tokenList = @[@{@"assetCode":@"CLB", @"issuer":@"buQWESXjdgXSFFajEZfkwi5H4fuAyTGgzkje"}];
    NSArray * tokenList = [NSArray array];
    //HTTP请求体
    NSDictionary * parmenters = @{@"address":@"buQWESXjdgXSFFajEZfkwi5H4fuAyTGgzkje",
                        @"currencyType":@"UD",
                        @"tokenList": tokenList,
                        @"assetCode": @"",
                        @"issuer=":@""};
    [NetWork requestPostWithURL:url
                       parameters:parmenters
                          success:^(NSData *data,NSURLResponse *response){
                              NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                              NSLog(@"requestPostWithURL(带参数) = %@",string);
                          }
                          failure:^(NSError *error){
                              
                          }];
}

@end
