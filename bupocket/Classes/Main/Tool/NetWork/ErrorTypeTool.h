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

// 错误类型
typedef NS_ENUM(NSInteger, ErrorType) {
    ErrorTypeParams = 100001, // 请求参数错误
    ErrorTypeAssetDetail = 500004, // 资产详情不存在
    ErrorTypeTxHash = 100013, // 无效的交易hash
    ErrorTypePurseAddress = 100008, // 非法钱包地址
};

+ (NSString *)getDescriptionWithErrorCode:(NSInteger)errorCode;

@end

NS_ASSUME_NONNULL_END
