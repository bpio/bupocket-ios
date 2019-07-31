//
//  VoucherModel.m
//  bupocket
//
//  Created by bupocket on 2019/7/5.
//  Copyright © 2019 bupocket. All rights reserved.
//

#import "VoucherModel.h"
#import <MJExtension/MJExtension.h>

@implementation VoucherModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"desc" : @"description"
             };
}

@end
