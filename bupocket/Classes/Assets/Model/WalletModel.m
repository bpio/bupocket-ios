//
//  WalletModel.m
//  bupocket
//
//  Created by bupocket on 2019/1/8.
//  Copyright © 2019年 bupocket. All rights reserved.
//

#import "WalletModel.h"

@implementation WalletModel

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.walletName = [aDecoder decodeObjectForKey:@"walletName"];
        self.walletIconName = [aDecoder decodeObjectForKey:@"walletIconName"];
        self.walletAddress = [aDecoder decodeObjectForKey:@"walletAddress"];
        self.walletKeyStore = [aDecoder decodeObjectForKey:@"walletKeyStore"];
        self.randomNumber = [aDecoder decodeObjectForKey:@"randomNumber"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.walletName forKey:@"walletName"];
    [aCoder encodeObject:self.walletIconName forKey:@"walletIconName"];
    [aCoder encodeObject:self.walletAddress forKey:@"walletAddress"];
    [aCoder encodeObject:self.walletKeyStore forKey:@"walletKeyStore"];
    [aCoder encodeObject:self.randomNumber forKey:@"randomNumber"];
}

@end
