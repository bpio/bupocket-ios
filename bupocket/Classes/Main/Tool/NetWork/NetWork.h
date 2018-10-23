//
//  NetWork.h
//  bupocket
//
//  Created by bupocket on 2018/10/23.
//  Copyright © 2018年 bupocket. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NetWork : NSObject

+(void)requestWithMethod:(nullable NSString *)method
                     URL:(nullable NSString *)URL
                 success:(nullable void (^)(NSData *__nullable data,NSURLResponse * __nullable response))success
                 failure:(nullable void (^)(NSError *__nullable error))failure;


+( void)requestGetWithURL:(nullable NSString *)URL
                  success:(nullable void (^)(NSData *__nullable data,NSURLResponse * __nullable response))success
                  failure:(nullable void (^)(NSError *__nullable error))failure;


+(void)requestGetWithURL:(nullable NSString *)URL
              parameters:(nullable id) parameters
                 success:(nullable void (^)(NSData *__nullable data,NSURLResponse * __nullable response))success
                 failure:(nullable void (^)(NSError *__nullable error))failure;

+(void)requestPostWithURL:(nullable NSString *)URL
                  success:(nullable void (^)(NSData *__nullable data,NSURLResponse * __nullable response))success
                  failure:(nullable void (^)(NSError *__nullable error))failure;


+(void)requestPostWithURL:(nullable NSString *)URL
               parameters:(nullable id) parameters
                  success:(nullable void (^)(NSData *__nullable data,NSURLResponse * __nullable response))success
                  failure:(nullable void (^)(NSError *__nullable error))failure;

@end

NS_ASSUME_NONNULL_END
