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
        self.identityAccount = [aDecoder decodeObjectForKey:@"identityAccount"];
        self.identityKey = [aDecoder decodeObjectForKey:@"identityKey"];
        self.walletName = [aDecoder decodeObjectForKey:@"walletName"];
        self.purseAccount = [aDecoder decodeObjectForKey:@"purseAccount"];
        self.purseKey = [aDecoder decodeObjectForKey:@"purseKey"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.identityName forKey:@"identityName"];
    [aCoder encodeObject:self.randomNumber forKey:@"randomNumber"];
    [aCoder encodeObject:self.identityAccount forKey:@"identityAccount"];
    [aCoder encodeObject:self.identityKey forKey:@"identityKey"];
    [aCoder encodeObject:self.walletName forKey:@"walletName"];
    [aCoder encodeObject:self.purseAccount forKey:@"purseAccount"];
    [aCoder encodeObject:self.purseKey forKey:@"purseKey"];
}

@end
