//
//  WalletModel.m
//  bupocket
//
//  Created by huoss on 2019/1/8.
//  Copyright © 2019年 bupocket. All rights reserved.
//

#import "WalletModel.h"

@implementation WalletModel

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.walletName = [aDecoder decodeObjectForKey:@"walletName"];
        self.walletAddress = [aDecoder decodeObjectForKey:@"walletAddress"];
        self.walletKeyStore = [aDecoder decodeObjectForKey:@"walletKeyStore"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.walletName forKey:@"walletName"];
    [aCoder encodeObject:self.walletAddress forKey:@"walletAddress"];
    [aCoder encodeObject:self.walletKeyStore forKey:@"walletKeyStore"];
}

@end
