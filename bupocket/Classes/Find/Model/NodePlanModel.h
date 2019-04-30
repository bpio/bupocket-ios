//
//  NodePlanModel.h
//  bupocket
//
//  Created by huoss on 2019/4/2.
//  Copyright © 2019年 bupocket. All rights reserved.
//

#import "BaseModel.h"

//(1: 申请成功，2: 退出中，3: 已退出)
typedef NS_ENUM(NSInteger, NodeStatus) {
    NodeStatusSuccess = 1,
    NodeStatusExit = 2,
    NodeStatusQuit = 3
};
// 节点身份（1 共识节点 ，2 生态节点）
typedef NS_ENUM(NSInteger, NodeIDType) {
    NodeIDTypeConsensus = 1,
    NodeIDTypeEcological = 2
};

NS_ASSUME_NONNULL_BEGIN

@interface NodePlanModel : BaseModel

@property (nonatomic, copy) NSString * nodeId;
@property (nonatomic, copy) NSString * nodeName;
@property (nonatomic, copy) NSString * nodeLogo;
@property (nonatomic, copy) NSString * applyAvatar;
@property (nonatomic, copy) NSString * nodeCapitalAddress;
@property (nonatomic, copy) NSString * identityType;
@property (nonatomic, copy) NSString * identityStatus;
@property (nonatomic, copy) NSString * nodeVote;
@property (nonatomic, copy) NSString * myVoteCount;
@property (nonatomic, copy) NSString * introduce;
@property (nonatomic, copy) NSString * support;
@property (nonatomic, copy) NSString * shareStartTime;
@property (nonatomic, copy) NSString * status;

@property (nonatomic, copy) NSString * shortLink;

@end

NS_ASSUME_NONNULL_END
