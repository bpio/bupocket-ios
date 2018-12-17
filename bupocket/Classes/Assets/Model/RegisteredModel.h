//
//  RegisteredModel.h
//  bupocket
//
//  Created by bupocket on 2018/10/30.
//  Copyright © 2018年 bupocket. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RegisteredModel : BaseModel

@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * code;
@property (nonatomic, strong) NSString * amount;
@property (nonatomic, assign) NSInteger decimals;
@property (nonatomic, copy) NSString * desc;


@property (nonatomic, copy) NSString * transactionHash;
@property (nonatomic, copy) NSString * registeredFee;

@end

NS_ASSUME_NONNULL_END
