//
//  BaseModel.m
//  bupocket
//
//  Created by bupocket on 2018/10/23.
//  Copyright © 2018年 bupocket. All rights reserved.
//

#import "BaseModel.h"

@implementation BaseModel

- (void)setValue:(id)value forKey:(NSString *)key
{
    if ([value isKindOfClass:[NSNull class]]) {
        return;
    }
    [super setValue:value forKey:key];
}

@end
