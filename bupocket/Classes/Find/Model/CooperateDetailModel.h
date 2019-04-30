//
//  CooperateDetailModel.h
//  bupocket
//
//  Created by huoss on 2019/4/13.
//  Copyright © 2019年 bupocket. All rights reserved.
//

#import "BaseModel.h"

// 状态：1-共建中 ，2-共建成功， 3-共建失败
typedef NS_ENUM(NSInteger, CooperateStatus) {
    CooperateStatusInProcessing = 1,
    CooperateStatusSuccess = 2,
    CooperateStatusFailure = 3
};

NS_ASSUME_NONNULL_BEGIN

@interface CooperateDetailModel : BaseModel

@property (nonatomic, copy) NSString * nodeId;
@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSString * perAmount;
@property (nonatomic, copy) NSString * totalCopies;
@property (nonatomic, copy) NSString * leftCopies;
@property (nonatomic, copy) NSString * cobuildCopies;
@property (nonatomic, copy) NSString * rewardRate;
@property (nonatomic, copy) NSString * totalAmount;
@property (nonatomic, copy) NSString * initiatorAmount;
@property (nonatomic, copy) NSString * selfCopies;
@property (nonatomic, copy) NSString * status;
@property (nonatomic, copy) NSString * supportAmount;
@property (nonatomic, copy) NSArray * supportList;
@property (nonatomic, copy) NSString * supportPerson;
@property (nonatomic, copy) NSString * originatorAddress;

@property (nonatomic, copy) NSString * contractAddress;

@end

NS_ASSUME_NONNULL_END
