//
//  BlockInfoModel.h
//  bupocket
//
//  Created by bupocket on 2018/10/24.
//  Copyright © 2018年 bupocket. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BlockInfoModel : BaseModel

// 区块信息底层参数
@property (nonatomic, copy) NSString * closeTimeDate;
@property (nonatomic, copy) NSString * hashStr;
@property (nonatomic, copy) NSString * previousHash;
@property (nonatomic, copy) NSString * seq;
@property (nonatomic, copy) NSString * txCount;
@property (nonatomic, copy) NSString * validatorsHash;

@end

NS_ASSUME_NONNULL_END
