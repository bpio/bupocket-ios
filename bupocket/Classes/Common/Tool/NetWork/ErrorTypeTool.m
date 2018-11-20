//
//  ErrorTypeTool.m
//  bupocket
//
//  Created by bupocket on 2018/11/13.
//  Copyright © 2018年 bupocket. All rights reserved.
//

#import "ErrorTypeTool.h"

@implementation ErrorTypeTool

+ (NSString *)getDescription:(int32_t)errorCode
{
    NSString *errorDesc;
    switch(errorCode) {
//        case SYSTEM_ERROR: errorDesc = Localized(@"SYSTEM_ERROR"); break;
        default: errorDesc = Localized(@"SYSTEM_ERROR"); break;
    }
    return errorDesc;
}

+ (NSString *)getDescriptionWithErrorCode:(NSInteger)errorCode
{
    NSString * errorDesc;
    switch(errorCode) {
        case ErrorTypeAssetDetail: errorDesc = Localized(@"InabilityToIssue"); break;
        default: errorDesc = Localized(@"LoadFailure"); break;
    }
    return errorDesc;
}

@end
