//
//  HttpTool.h
//  TheImperialPalaceMuseum
//
//  Created by 霍双双 on 17/2/25.
//  Copyright © 2017年 hss. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HttpTool : NSObject

+ (HttpTool *)shareTool;
/**
 *  发送一个get请求
 *
 *  @param URLString  请求地址
 *  @param parameters 请求参数
 *  @param success    成功后的回调
 *  @param failure    失败后的回调
 */
+ (void)GET:(NSString *)URLString
 parameters:(NSDictionary *)parameters
    success:(void(^)(id responseObject))success
    failure:(void(^)(NSError * error))failure;
/**
 *  发送一个post请求
 *
 *  @param URLString  请求地址
 *  @param parameters 请求参数
 *  @param success    成功后的回调
 *  @param failure    失败后的回调
 */
+ (void)POST:(NSString *)URLString
  parameters:(NSDictionary *)parameters
     success:(void(^)(id responseObject))success
     failure:(void(^)(NSError * error))failure;
/**
 *  发送一个post请求
 *
 *  @param URLString  请求地址
 *  @param parameters 请求参数
 *  @param success    成功后的回调
 *  @param failure    失败后的回调
 */
+ (void)POSTHtml:(NSString *)URLString
      parameters:(NSDictionary *)parameters
         success:(void(^)(id responseObject))success
         failure:(void(^)(NSError * error))failure;

@end
