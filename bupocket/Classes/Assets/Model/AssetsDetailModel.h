//
//  AssetsDetailModel.h
//  bupocket
//
//  Created by bupocket on 2018/10/24.
//  Copyright © 2018年 bupocket. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface AssetsDetailModel : BaseModel

@property (nonatomic, copy) NSString * fromAddress;
@property (nonatomic, copy) NSString * ledger;
@property (nonatomic, assign) NSInteger outinType;
@property (nonatomic, copy) NSString * toAddress;
@property (nonatomic, copy) NSString * amount;
@property (nonatomic, assign) NSInteger txStatus;
@property (nonatomic, copy) NSString * txTime;
@property (nonatomic, copy) NSString * txHash;
@property (nonatomic, assign) NSInteger optNo;

@end

NS_ASSUME_NONNULL_END
