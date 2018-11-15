//
//  TxInfoModel.h
//  bupocket
//
//  Created by bupocket on 2018/10/24.
//  Copyright © 2018年 bupocket. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TxInfoModel : BaseModel

@property (nonatomic, copy) NSString * amount;
@property (nonatomic, copy) NSString * sourceAddress;
@property (nonatomic, copy) NSString * destAddress;
@property (nonatomic, copy) NSString * fee;
@property (nonatomic, copy) NSString * hashStr;
@property (nonatomic, copy) NSString * ledgerSeq;
@property (nonatomic, copy) NSString * nonce;
@property (nonatomic, copy) NSString * signatureStr;

@end

NS_ASSUME_NONNULL_END
