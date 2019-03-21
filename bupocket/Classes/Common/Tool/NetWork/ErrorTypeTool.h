//
//  ErrorTypeTool.h
//  bupocket
//
//  Created by bupocket on 2018/11/13.
//  Copyright © 2018年 bupocket. All rights reserved.
//

#import <sdk_ios/sdk_ios.h>

NS_ASSUME_NONNULL_BEGIN

@interface ErrorTypeTool : SDKError

// Error type
typedef NS_ENUM(NSInteger, ErrorType) {
    ErrorTypeParams = 100001, // Request parameter error
    ErrorTypeAssetDetail = 500004, // Details of assets do not exist
    ErrorTypeTxHash = 100013, // Invalid transaction hash
    ErrorTypePurseAddress = 100008, // Illegal wallet address
};

// SDK Error type
typedef NS_ENUM(NSInteger, ErrorCode) {
    ERRCODE_ACCOUNT_LOW_RESERVE = 100, //  your credit is running low
    ERRCODE_FEE_NOT_ENOUGH = 111, // Insufficient transaction costs
};

+ (NSString *)getDescriptionWithErrorCode:(NSInteger)errorCode;

@end

NS_ASSUME_NONNULL_END
