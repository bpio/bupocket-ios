//
//  NetworkingManager.h
//  bupocket
//
//  Created by bupocket on 2018/10/23.
//  Copyright © 2018年 bupocket. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFHTTPSessionManager.h>

NS_ASSUME_NONNULL_BEGIN

@interface NetworkingManager : NSObject

@property (nonatomic, assign) AFNetworkReachabilityStatus currentStatus;

//extern NSString * const ALHTTPClientTransportErrorDomain;
//extern NSString * const ALHTTPClientTransportErrorDescriptionKey;
//extern NSString * const ALHTTPClientTransportErrorLocalizedReasonKey;

typedef void (^ResponseObjectSuccessHandler)(NSString* msg, id data);
typedef void (^ResponseObjectFailureHandler)(NSError *failure);
typedef void (^ResponseListSuccessHandler)(int code, NSString *message, NSArray<NSObject *> *listOfObjects);

+ (instancetype)sharedManager;
- (NSInteger)getSystemTime;

// Assets
- (NSURLSessionDataTask *)getDataWithSuccessHandler:(ResponseObjectSuccessHandler)successHandler failureHandler:(ResponseObjectFailureHandler)failureHandler;

@end

NS_ASSUME_NONNULL_END
