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
        // SDK ERRCODE_ACCOUNT_LOW_RESERVE
        case ERRCODE_ACCOUNT_LOW_RESERVE: errorDesc = Localized(@"NotSufficientFunds");
        break;
        case ERRCODE_FEE_NOT_ENOUGH: errorDesc = Localized(@"ERRCODE_FEE_NOT_ENOUGH");
        break;
        
        // getBalance
        case INVALID_ADDRESS_ERROR: errorDesc = Localized(@"INVALID_ADDRESS_ERROR");
        break;
//            INVALID_ADDRESS_ERROR 11006无效地址
//            The account does not have the asset  帐户没有资产
//        case NO_ASSET_ERROR: errorDesc = Localized(@"");
//            break;
        case CONNECTNETWORK_ERROR: errorDesc = Localized(@"NoNetWork");
            break;
            // SourceAddress cannot be equal to destAddress
        case SOURCEADDRESS_EQUAL_DESTADDRESS_ERROR: errorDesc = Localized(@"CannotTransferToOneself");
            break;
        case ERRCODE_CONTRACT_EXECUTE_FAIL: errorDesc = [NSString stringWithFormat:Localized(@"ContractTransferFailure%ld"), ERRCODE_CONTRACT_EXECUTE_FAIL];
            break;
            case SYSTEM_ERROR: errorDesc = Localized(@"SYSTEM_ERROR");
        default: errorDesc = Localized(@"LoadFailure");
            break;
    }
    return errorDesc;
}

+ (NSString *)getDescriptionWithErrorCode:(NSInteger)errorCode
{
    NSString * errorDesc;
    switch(errorCode) {
        case ErrorTypeAssetDetail: errorDesc = Localized(@"InabilityToIssue"); break;
        case ErrorTypeContactExisted: errorDesc = Localized(@"ContactExisted"); break;
        case ErrorTypePurseAddress: errorDesc = Localized(@"INVALID_ADDRESS_ERROR"); break;
        default: errorDesc = Localized(@"LoadFailure"); break;
    }
    return errorDesc;
}

+ (NSString *)getDescriptionWithNodeErrorCode:(NSInteger)errorCode
{
    NSString * errorDesc;
    switch(errorCode) {
        case ErrorPhysicalAddressApplied: errorDesc = Localized(@"PhysicalAddressApplied"); break;
        case ErrorAccountApplied: errorDesc = Localized(@"AccountApplied"); break;
        case ErrorNotSubmitted: errorDesc = Localized(@"NotSubmitted"); break;
        case ErrorCommitteeAuthority: errorDesc = Localized(@"CommitteeAuthority"); break;
        case ErrorNoVoteJurisdiction: errorDesc = Localized(@"NoVoteJurisdiction"); break;
        case ErrorUnsupportedSubscription: errorDesc = Localized(@"UnsupportedSubscription"); break;
        case ErrorInsufficientSurplus: errorDesc = Localized(@"InsufficientSurplus"); break;
        case ErrorCooperateUnsupported: errorDesc = Localized(@"CooperateUnsupported"); break;
        case ErrorCooperateCompleted: errorDesc = Localized(@"CooperateCompleted"); break;
        case ErrorInitiatorCanNotSupport: errorDesc = Localized(@"InitiatorCanNotSupport"); break;
        default: errorDesc = Localized(@"LoadFailure"); break;
    }
    return errorDesc;
}


@end
