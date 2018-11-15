//
//  DistributionModel.h
//  bupocket
//
//  Created by bupocket on 2018/10/31.
//  Copyright © 2018年 bupocket. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DistributionModel : BaseModel

@property (nonatomic, copy) NSString * assetCode;
@property (nonatomic, copy) NSString * assetName;
@property (nonatomic, copy) NSString * issueAddress;
@property (nonatomic, copy) NSString * totalSupply;
@property (nonatomic, copy) NSString * actualSupply;
@property (nonatomic, assign) NSInteger decimals;
@property (nonatomic, assign) NSInteger isOverFlow;
@property (nonatomic, copy) NSString * tokenDescription;
@property (nonatomic, copy) NSString * version;

@property (nonatomic, copy) NSString * transactionHash;
@property (nonatomic, copy) NSString * distributionFee;

@end

NS_ASSUME_NONNULL_END
