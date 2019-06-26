//
//  WalletModel.h
//  bupocket
//
//  Created by bupocket on 2019/1/8.
//  Copyright © 2019年 bupocket. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface WalletModel : BaseModel

/** 钱包名 */
@property (nonatomic, strong) NSString * walletName;
/** 钱包icon名 */
@property (nonatomic, strong) NSString * walletIconName;
/** 钱包账户地址 */
@property (nonatomic, strong) NSString * walletAddress;
/** 通过钱包私钥和密码生成的keystore */
@property (nonatomic, strong) NSString * walletKeyStore;

/** 通过keystone存储的随机数 */
@property (nonatomic, strong) NSString * randomNumber;

@end

NS_ASSUME_NONNULL_END
