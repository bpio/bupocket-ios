//
//  VotingRecordsModel.h
//  bupocket
//
//  Created by huoss on 2019/4/2.
//  Copyright © 2019年 bupocket. All rights reserved.
//

#import "BaseModel.h"

// 操作状态 "0 处理中 1 成功 2 失败"
typedef NS_ENUM(NSInteger, VoteStatus) {
    VoteStatusInProcessing = 0,
    VoteStatusSuccess = 1,
    VoteStatusFailure = 2
};

// 记录类型：1 投票 2 撤票
typedef NS_ENUM(NSInteger, VoteType) {
    VoteTypeThrow = 1,
    VoteTypeWithdraw = 2
};

// 节点身份（1 共识节点 ，2 生态节点）
typedef NS_ENUM(NSInteger, NodeIdentityType) {
    NodeIdentityConsensus = 1,
    NodeIdentityEcological = 2
};

NS_ASSUME_NONNULL_BEGIN

@interface VotingRecordsModel : BaseModel

@property (nonatomic, copy) NSString * identityType;
@property (nonatomic, copy) NSString * type;
@property (nonatomic, copy) NSString * nodeName;
@property (nonatomic, copy) NSString * amount;
@property (nonatomic, copy) NSString * status;
@property (nonatomic, copy) NSString * date;

@end

NS_ASSUME_NONNULL_END
