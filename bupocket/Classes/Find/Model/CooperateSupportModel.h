//
//  CooperateSupportModel.h
//  bupocket
//
//  Created by huoss on 2019/4/13.
//  Copyright © 2019年 bupocket. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CooperateSupportModel : BaseModel

@property (nonatomic, copy) NSString * initiatorAddress;
@property (nonatomic, copy) NSString * amount;
@property (nonatomic, copy) NSString * createTime;

@end

NS_ASSUME_NONNULL_END
