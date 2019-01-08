//
//  WalletModel.h
//  bupocket
//
//  Created by huoss on 2019/1/8.
//  Copyright © 2019年 bupocket. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface WalletModel : BaseModel

@property (nonatomic, copy) NSString * walletName;
@property (nonatomic, copy) NSString * walletAddress;
@property (nonatomic, copy) NSString * walletKeyStore;

@end

NS_ASSUME_NONNULL_END
