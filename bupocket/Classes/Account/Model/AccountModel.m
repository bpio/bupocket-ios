//
//  AccountModel.m
//  bupocket
//
//  Created by bupocket on 2018/10/26.
//  Copyright © 2018年 bupocket. All rights reserved.
//

#import "AccountModel.h"

@implementation AccountModel


- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.identityName = [aDecoder decodeObjectForKey:@"identityName"];
        self.randomNumber = [aDecoder decodeObjectForKey:@"randomNumber"];
        self.identityAddress = [aDecoder decodeObjectForKey:@"identityAddress"];
        self.identityKeyStore = [aDecoder decodeObjectForKey:@"identityKeyStore"];
        self.walletName = [aDecoder decodeObjectForKey:@"walletName"];
        self.walletIconName = [aDecoder decodeObjectForKey:@"walletIconName"];
        self.walletAddress = [aDecoder decodeObjectForKey:@"walletAddress"];
        self.walletKeyStore = [aDecoder decodeObjectForKey:@"walletKeyStore"];
        self.purseAccount = [aDecoder decodeObjectForKey:@"purseAccount"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.identityName forKey:@"identityName"];
    [aCoder encodeObject:self.randomNumber forKey:@"randomNumber"];
    [aCoder encodeObject:self.identityAddress forKey:@"identityAddress"];
    [aCoder encodeObject:self.identityKeyStore forKey:@"identityKeyStore"];
    [aCoder encodeObject:self.walletName forKey:@"walletName"];
    [aCoder encodeObject:self.walletIconName forKey:@"walletIconName"];
    [aCoder encodeObject:self.walletAddress forKey:@"walletAddress"];
    [aCoder encodeObject:self.walletKeyStore forKey:@"walletKeyStore"];
    [aCoder encodeObject:self.purseAccount forKey:@"purseAccount"];
}

@end
