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
    ErrorTypeContactExisted = 100055,
};

// SDK Error type
typedef NS_ENUM(NSInteger, ErrorCode) {
    ERRCODE_ACCOUNT_LOW_RESERVE = 100, //  your credit is running low
    ERRCODE_FEE_NOT_ENOUGH = 111, // Insufficient transaction costs
};

// Node Error type
typedef NS_ENUM(NSInteger, NodeErrorCode) {
    ErrorPhysicalAddressApplied = 1003,
    ErrorAccountApplied = 1009,
    ErrorNotSubmitted = 1011,
    ErrorCommitteeAuthority = 1024,
    ErrorNoVoteJurisdiction = 1029,
};

// Error type
+ (NSString *)getDescriptionWithErrorCode:(NSInteger)errorCode;

// Node Error type
+ (NSString *)getDescriptionWithNodeErrorCode:(NSInteger)errorCode;

@end

NS_ASSUME_NONNULL_END
