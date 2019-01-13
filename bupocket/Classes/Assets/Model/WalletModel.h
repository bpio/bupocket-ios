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

/** 钱包名 */
@property (nonatomic, strong) NSString * walletName;
/** 钱包账户地址 */
@property (nonatomic, strong) NSString * walletAddress;
/** 通过钱包私钥和密码生成的keystore */
@property (nonatomic, strong) NSString * walletKeyStore;

@end

NS_ASSUME_NONNULL_END
