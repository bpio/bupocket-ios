//
//  TxInfoModel.m
//  bupocket
//
//  Created by bupocket on 2018/10/24.
//  Copyright © 2018年 bupocket. All rights reserved.
//

#import "TxInfoModel.h"

@implementation TxInfoModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"hashStr" :  @"hash"};
}

@end
