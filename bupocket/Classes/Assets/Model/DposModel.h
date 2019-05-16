//
//  DposModel.h
//  bupocket
//
//  Created by bupocket on 2019/5/8.
//  Copyright © 2019 bupocket. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DposModel : BaseModel

@property (nonatomic, copy) NSString * dest_address;
@property (nonatomic, copy) NSString * amount;
@property (nonatomic, copy) NSString * input;
@property (nonatomic, copy) NSString * tx_fee;

@end

NS_ASSUME_NONNULL_END
