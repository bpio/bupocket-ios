//
//  CooperateDetailModel.h
//  bupocket
//
//  Created by huoss on 2019/4/13.
//  Copyright © 2019年 bupocket. All rights reserved.
//

#import "BaseModel.h"

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

@end

NS_ASSUME_NONNULL_END
