//
//  NodePlanModel.h
//  bupocket
//
//  Created by huoss on 2019/4/2.
//  Copyright © 2019年 bupocket. All rights reserved.
//

#import "BaseModel.h"

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

@property (nonatomic, copy) NSString * shortLink;

@end

NS_ASSUME_NONNULL_END
