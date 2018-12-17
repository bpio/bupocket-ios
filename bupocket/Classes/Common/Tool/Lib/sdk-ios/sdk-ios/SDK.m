//
//  SDK.m
//  sdk-ios
//
//  Created by dxl on 2018/8/8.
//  Copyright © 2018 dxl. All rights reserved.
//

#import "SDK.h"
#import "AccountServiceImpl.h"
#import "AssetServiceImpl.h"
#import "TransactionServiceImpl.h"
#import "BlockServiceImpl.h"
#import "ContractServiceImpl.h"
#import "Ctp10TokenServiceImpl.h"
#import "General.h"

@implementation SDK

static SDK *_sdk = nil;

+ (instancetype) sharedInstance {
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        _sdk = [[super allocWithZone:NULL] init] ;
    }) ;
    return _sdk ;
}
+ (id) allocWithZone : (struct _NSZone *)zone {
    return [SDK sharedInstance] ;
}
- (id) copyWithZone : (struct _NSZone *)zone {
    return [SDK sharedInstance] ;
}
- (instancetype) setUrl : (NSString *) url {
    [[General sharedInstance] setUrl : url];
    return self;
}

- (AccountService *) getAccountService {
    return [AccountServiceImpl new];
}

- (AssetService *) getAssetService {
    return [AssetServiceImpl new];
}

- (TransactionService *) getTransactionService {
    return [TransactionServiceImpl new];
}

- (BlockService *) getBlockService {
    return [BlockServiceImpl new];
}
- (ContractService *) getContractService {
    return [ContractServiceImpl new];
}
- (Ctp10TokenService *) getCtp10TokenService {
    return [Ctp10TokenServiceImpl new];
}
@end
