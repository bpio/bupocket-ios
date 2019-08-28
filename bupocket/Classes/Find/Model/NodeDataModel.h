//
//  NodeDataModel.h
//  bupocket
//
//  Created by huoss on 2019/8/27.
//  Copyright © 2019 bupocket. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface NodeDataModel : BaseModel

@property (nonatomic, copy) NSString * deposit;
@property (nonatomic, copy) NSString * equityValue;
@property (nonatomic, copy) NSString * ratio;
@property (nonatomic, copy) NSString * receiveRewardAmount;
@property (nonatomic, copy) NSString * totalRewardAmount;
@property (nonatomic, copy) NSString * totalVoteCount;

@end

NS_ASSUME_NONNULL_END
