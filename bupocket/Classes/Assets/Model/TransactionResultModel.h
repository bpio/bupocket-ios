//
//  TransactionResultModel.h
//  bupocket
//
//  Created by bupocket on 2018/10/31.
//  Copyright © 2018年 bupocket. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TransactionResultModel : BaseModel

@property (nonatomic, copy) NSString * transactionHash;
@property (nonatomic, assign) int64_t transactionTime;
@property (nonatomic, strong) NSString *actualFee;
@property (nonatomic, assign) int32_t errorCode;
@property (nonatomic, copy) NSString * errorDesc;


@end

NS_ASSUME_NONNULL_END
