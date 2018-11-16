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

/** 通过存储的身份账户 */
@property (nonatomic, strong) NSString * identityAccount;

/** 通过存储的钱包账户 */
@property (nonatomic, strong) NSString * purseAccount;

/** 通过keystone存储的身份账户 */
@property (nonatomic, strong) NSString * identityKey;

/** 通过keystone存储的钱包账户 */
@property (nonatomic, strong) NSString * purseKey;

@end

NS_ASSUME_NONNULL_END