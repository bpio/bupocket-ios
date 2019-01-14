//
//  AccountModel.h
//  bupocket
//
//  Created by bupocket on 2018/10/26.
//  Copyright © 2018年 bupocket. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface AccountModel : BaseModel<NSCoding>

/** 身份名 */
@property (nonatomic, strong) NSString * identityName;

/** 通过keystone存储的随机数 */
@property (nonatomic, strong) NSString * randomNumber;

/** 身份账户地址 */
@property (nonatomic, strong) NSString * identityAddress;

/** 通过身份私钥和密码生成的keystore */
@property (nonatomic, strong) NSString * identityKeyStore;

/** 钱包名 */
@property (nonatomic, strong) NSString * walletName;

/** 钱包账户地址 */
@property (nonatomic, strong) NSString * walletAddress;
@property (nonatomic, strong) NSString * purseAccount;

/** 通过钱包私钥和密码生成的keystore */
@property (nonatomic, strong) NSString * walletKeyStore;

@end

NS_ASSUME_NONNULL_END
