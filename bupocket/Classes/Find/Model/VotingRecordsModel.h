//
//  VotingRecordsModel.h
//  bupocket
//
//  Created by huoss on 2019/4/2.
//  Copyright © 2019年 bupocket. All rights reserved.
//

#import "BaseModel.h"

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
