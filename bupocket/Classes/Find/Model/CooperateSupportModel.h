//
//  CooperateSupportModel.h
//  bupocket
//
//  Created by bupocket on 2019/4/13.
//  Copyright © 2019年 bupocket. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CooperateSupportModel : BaseModel

@property (nonatomic, copy) NSString * initiatorAddress;
@property (nonatomic, copy) NSString * amount;
@property (nonatomic, copy) NSString * createTime;
// 类型： (1: 共建节点认购，2: 共建节点认购撤销)
@property (nonatomic, copy) NSString * type;

@end

NS_ASSUME_NONNULL_END
