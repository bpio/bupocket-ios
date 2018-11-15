//
//  TxDeatilModel.h
//  bupocket
//
//  Created by bupocket on 2018/10/24.
//  Copyright © 2018年 bupocket. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TxDetailModel : BaseModel

@property (nonatomic, copy) NSString * amount;
@property (nonatomic, copy) NSString * applyTimeDate;
@property (nonatomic, copy) NSString * destAddress;
@property (nonatomic, copy) NSString * errorCode;
@property (nonatomic, copy) NSString * errorMsg;
@property (nonatomic, copy) NSString * fee;
@property (nonatomic, copy) NSString * sourceAddress;
@property (nonatomic, copy) NSString * status;
@property (nonatomic, copy) NSString * originalMetadata;

@end

NS_ASSUME_NONNULL_END
