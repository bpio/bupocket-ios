//
//  BlockInfoModel.m
//  bupocket
//
//  Created by bupocket on 2018/10/24.
//  Copyright © 2018年 bupocket. All rights reserved.
//

#import "BlockInfoModel.h"

@implementation BlockInfoModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"hashStr" :  @"hash"};
}

@end
