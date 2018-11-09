//
//  AccountModel.m
//  bupocket
//
//  Created by bupocket on 2018/10/26.
//  Copyright © 2018年 bupocket. All rights reserved.
//

#import "AccountModel.h"

@implementation AccountModel


/**
 *  当从文件中解析出一个对象的时候调用
 *  在这个方法中写清楚：怎么解析文件中的数据
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.identityName = [aDecoder decodeObjectForKey:@"identityName"];
        self.randomNumber = [aDecoder decodeObjectForKey:@"randomNumber"];
        self.identityAccount = [aDecoder decodeObjectForKey:@"identityAccount"];
        self.identityKey = [aDecoder decodeObjectForKey:@"identityKey"];
        self.purseAccount = [aDecoder decodeObjectForKey:@"purseAccount"];
        self.purseKey = [aDecoder decodeObjectForKey:@"purseKey"];
    }
    return self;
}

/**
 *  将对象写入文件的时候调用
 *  在这个方法中写清楚：要存储哪些对象的哪些属性，以及怎样存储属性
 */
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.identityName forKey:@"identityName"];
    [aCoder encodeObject:self.randomNumber forKey:@"randomNumber"];
    [aCoder encodeObject:self.identityAccount forKey:@"identityAccount"];
    [aCoder encodeObject:self.identityKey forKey:@"identityKey"];
    [aCoder encodeObject:self.purseAccount forKey:@"purseAccount"];
    [aCoder encodeObject:self.purseKey forKey:@"purseKey"];
}

@end
