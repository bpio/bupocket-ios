//
//  HTTPManager.m
//  bupocket
//
//  Created by bupocket on 17/2/25.
//  Copyright © 2017年 bupocket. All rights reserved.
//

#import "HTTPManager.h"
#import "HttpTool.h"
#import "AtpProperty.h"

@interface HTTPManager ()

{
    TransactionService * _transactionService;
    TransactionBuildBlobResponse * _buildBlobResponse;
    NSString * _hash;
}

@end

@implementation HTTPManager

static NSString * _webServerDomain;
static NSString * _bumoNodeUrl;
static HTTPManager * _shareManager = nil;

static int64_t const gasPrice = 1000;

+ (instancetype)shareManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!_shareManager) {
            _shareManager = [[HTTPManager alloc]init];
            [_shareManager initNetWork];
        }
    });
    return _shareManager;
}
+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shareManager = [super allocWithZone:zone];
    });
    return _shareManager;
}
- (void)initNetWork
{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:If_Switch_TestNetwork] == YES) {
        _webServerDomain = WEB_SERVER_DOMAIN_TEST;
        _bumoNodeUrl = BUMO_NODE_URL_TEST;
        _shareManager.pushMessageSocketUrl = PUSH_MESSAGE_SOCKET_URL_TEST;
    } else {
        _webServerDomain = WEB_SERVER_DOMAIN;
        _bumoNodeUrl = BUMO_NODE_URL;
        _shareManager.pushMessageSocketUrl = PUSH_MESSAGE_SOCKET_URL;
    }
}
- (id)copyWithZone:(NSZone *)zone
{
    return _shareManager;
}

#pragma mark -- 辅助函数 处理共同的特性等.
/**
 *  将HTTP的string类型参数转换成字典
 *
 *  @param body phone=1234567&password=321
 *
 *  @return @{@"phone":@"1234567",@"password":@"321"}
 */
- (NSDictionary *)parametersWithHTTPBody:(NSString *)body
{
    if (body.length == 0) {
        return nil;
    }
    NSArray *array = [body componentsSeparatedByString:@"&"];
    NSMutableDictionary * parameters = [NSMutableDictionary dictionary];
    for (NSString * str in array) {
        NSString * key = [str componentsSeparatedByString:@"="][0];
        NSString * value = [str componentsSeparatedByString:@"="][1];
        [parameters setValue:value forKey:key];
    }
    return parameters;
}
// Switched network
- (void)SwitchedNetworkWithIsTest:(BOOL)isTest
{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:YES forKey:If_Show_Switch_Network];
    [defaults setBool:isTest forKey:If_Switch_TestNetwork];
    [defaults synchronize];
    [self initNetWork];
}

// Version Update
- (void)getVersionDataWithSuccess:(void (^)(id responseObject))success
                          failure:(void (^)(NSError *error))failure
{
    NSString * url = SERVER_COMBINE_API(_webServerDomain, Version_Update);
    [[HttpTool shareTool] GET:url parameters:nil success:^(id responseObject) {
        if(success != nil)
        {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        if(failure != nil)
        {
            failure(error);
        }
    }];
}
// Assets
- (void)getAssetsDataWithAddress:(NSString *)address
                    currencyType:(NSString *)currencyType
                       tokenList:(NSArray *)tokenList
                         success:(void (^)(id responseObject))success
                         failure:(void (^)(NSError *error))failure
{
    NSString * url = SERVER_COMBINE_API(_webServerDomain, Assets_List);
    NSDictionary * parameters = @{@"address": address,
                                  @"currencyType": currencyType,
                                  @"tokenList": tokenList
                                  };
    [[HttpTool shareTool] POST:url parameters:parameters success:^(id responseObject) {
        if(success != nil)
        {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        if(failure != nil)
        {
            failure(error);
        }
    }];
}
// Search Assets
- (void)getSearchAssetsDataWithAssetCode:(NSString *)assetCode
                               pageIndex:(NSInteger)pageIndex
                                 success:(void (^)(id responseObject))success
                                 failure:(void (^)(NSError *error))failure
{
    NSString * url = SERVER_COMBINE_API(_webServerDomain, Assets_Search);
    NSDictionary * parameters = @{@"address": CurrentWalletAddress,
                                  @"assetCode" : assetCode,
                                  @"supportFuzzy" : @"true",
                                  @"startPage" : @(pageIndex),
                                  @"pageSize" : @(PageSize_Max)};
    [[HttpTool shareTool] POST:url parameters:parameters success:^(id responseObject) {
        if(success != nil)
        {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        if(failure != nil)
        {
            failure(error);
        }
    }];
}
// AssetsDetail Transaction_Record
- (void)getAssetsDetailDataWithTokenType:(NSInteger)tokenType
                            currencyType:(NSString *)currencyType
                               assetCode:(NSString *)assetCode
                                  issuer:(NSString *)issuer
                                 address:(NSString *)address
                               pageIndex:(NSInteger)pageIndex
                                 success:(void (^)(id responseObject))success
                                 failure:(void (^)(NSError *error))failure
{
    NSString * url = SERVER_COMBINE_API(_webServerDomain, Transaction_Record);
    NSMutableDictionary * parameters = [NSMutableDictionary dictionary];
    [parameters addEntriesFromDictionary:@{@"tokenType" : @(tokenType),
                                           @"currencyType": currencyType,
                                           @"assetCode" : assetCode,
                                           @"issuer" : issuer,
                                           @"address" : address,
                                           @"startPage" : @(pageIndex),
                                           @"pageSize" : @(PageSize_Max)
                                           }];
    [[HttpTool shareTool] POST:url parameters:parameters success:^(id responseObject) {
        if(success != nil)
        {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        if(failure != nil)
        {
            failure(error);
        }
    }];
}
// Transaction detail
- (void)getOrderDetailsDataWithAddress:(NSString *)address
                                 optNo:(NSInteger)optNo
                               success:(void (^)(id responseObject))success
                               failure:(void (^)(NSError *error))failure
{
    NSString * url = SERVER_COMBINE_API(_webServerDomain, Order_Details);
    NSDictionary * parameters = @{
                                  @"address" : address,
                                  @"optNo": @(optNo)
                                  };
    [[HttpTool shareTool] POST:url parameters:parameters success:^(id responseObject) {
        if(success != nil)
        {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        if(failure != nil)
        {
            failure(error);
        }
    }];
}
// Transaction Details
- (void)getTransactionDetailsDataWithHash:(NSString *)hash
                                  success:(void (^)(id responseObject))success
                                  failure:(void (^)(NSError *error))failure
{
    [MBProgressHUD showActivityMessageInWindow:Localized(@"Loading")];
    NSString * url = SERVER_COMBINE_API(_webServerDomain, Transaction_Details);
    NSDictionary * parameters = @{@"Hash" : hash};
    [[HttpTool shareTool] POST:url parameters:parameters success:^(id responseObject) {
        if(success != nil)
        {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        if(failure != nil)
        {
            failure(error);
            [MBProgressHUD showTipMessageInWindow:Localized(@"NoNetWork")];
        }
    }];
}

// Registration / issuance of assets information
- (void)getRegisteredORDistributionDataWithAssetCode:(NSString *)assetCode
                                        issueAddress:(NSString *)issueAddress
                                             success:(void (^)(id responseObject))success
                                             failure:(void (^)(NSError *error))failure
{
    [MBProgressHUD showActivityMessageInWindow:Localized(@"Loading")];
    NSString * url = SERVER_COMBINE_API(_webServerDomain, Registered_And_Distribution);
    NSDictionary * parameters = @{
                                  @"assetCode": assetCode,
                                  @"issueAddress": issueAddress
                                  };
    [[HttpTool shareTool] POST:url parameters:parameters success:^(id responseObject) {
        if(success != nil)
        {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        if(failure != nil)
        {
            failure(error);
            [MBProgressHUD showTipMessageInWindow:Localized(@"NoNetWork")];
        }
    }];
}
// Feedback
- (void)getFeedbackDataWithContent:(NSString *)content
                           contact:(NSString *)contact
                           success:(void (^)(id responseObject))success
                           failure:(void (^)(NSError *error))failure
{
    [MBProgressHUD showActivityMessageInWindow:Localized(@"Loading")];
    NSString * url = SERVER_COMBINE_API(_webServerDomain, Help_And_Feedback);
    NSDictionary * parameters = @{
                                  @"content": content,
                                  @"contact": contact
                                  };
    [[HttpTool shareTool] POST:url parameters:parameters success:^(id responseObject) {
        if(success != nil)
        {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        if(failure != nil)
        {
            failure(error);
            [MBProgressHUD showTipMessageInWindow:Localized(@"NoNetWork")];
        }
    }];
}
// addressBook
- (void)getAddressBookListWithIdentityAddress:(NSString *)identityAddress
                                    pageIndex:(NSInteger)pageIndex
                                      success:(void (^)(id responseObject))success
                                      failure:(void (^)(NSError *error))failure
{
    NSString * url = SERVER_COMBINE_API(_webServerDomain, AddressBook_List);
    NSDictionary * parameters = @{@"identityAddress": identityAddress,
                                  @"startPage" : @(pageIndex),
                                  @"pageSize" : @(PageSize_Max)};
    [[HttpTool shareTool] POST:url parameters:parameters success:^(id responseObject) {
        if(success != nil)
        {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        if(failure != nil)
        {
            failure(error);
        }
    }];
}
// Add AddressBook
- (void)getAddAddressBookDataWithIdentityAddress:(NSString *)identityAddress
                                  linkmanAddress:(NSString *)linkmanAddress
                                        nickName:(NSString *)nickName
                                          remark:(NSString *)remark
                                         success:(void (^)(id responseObject))success
                                         failure:(void (^)(NSError *error))failure
{
    [MBProgressHUD showActivityMessageInWindow:Localized(@"Loading")];
    NSString * url = SERVER_COMBINE_API(_webServerDomain, Add_AddressBook);
    NSDictionary * parameters = @{
                                  @"identityAddress": identityAddress,
                                  @"linkmanAddress": linkmanAddress,
                                  @"nickName": nickName,
                                  @"remark": remark
                                  };
    [[HttpTool shareTool] POST:url parameters:parameters success:^(id responseObject) {
        if(success != nil)
        {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        if(failure != nil)
        {
            failure(error);
            [MBProgressHUD showTipMessageInWindow:Localized(@"NoNetWork")];
        }
    }];
}
// update AddressBook
- (void)getUpdateAddressBookDataWithIdentityAddress:(NSString *)identityAddress
                                  oldLinkmanAddress:(NSString *)oldLinkmanAddress
                                  newLinkmanAddress:(NSString *)newLinkmanAddress
                                           nickName:(NSString *)nickName
                                             remark:(NSString *)remark
                                            success:(void (^)(id responseObject))success
                                            failure:(void (^)(NSError *error))failure
{
    [MBProgressHUD showActivityMessageInWindow:Localized(@"Loading")];
    NSString * url = SERVER_COMBINE_API(_webServerDomain, Update_AddressBook);
    NSDictionary * parameters = @{
                                  @"identityAddress": identityAddress,
                                  @"oldLinkmanAddress": oldLinkmanAddress,
                                  @"newLinkmanAddress": newLinkmanAddress,
                                  @"nickName": nickName,
                                  @"remark": remark
                                  };
    [[HttpTool shareTool] POST:url parameters:parameters success:^(id responseObject) {
        if(success != nil)
        {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        if(failure != nil)
        {
            failure(error);
            [MBProgressHUD showTipMessageInWindow:Localized(@"NoNetWork")];
        }
    }];
}
// Delete AddressBook
- (void)getDeleteAddressBookDataWithIdentityAddress:(NSString *)identityAddress
                                     linkmanAddress:(NSString *)linkmanAddress
                                            success:(void (^)(id responseObject))success
                                            failure:(void (^)(NSError *error))failure
{
    [MBProgressHUD showActivityMessageInWindow:Localized(@"Loading")];
    NSString * url = SERVER_COMBINE_API(_webServerDomain, Delete_AddressBook);
    NSDictionary * parameters = @{
                                  @"identityAddress": identityAddress,
                                  @"linkmanAddress": linkmanAddress
                                  };
    [[HttpTool shareTool] POST:url parameters:parameters success:^(id responseObject) {
        if(success != nil)
        {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        if(failure != nil)
        {
            failure(error);
            [MBProgressHUD showTipMessageInWindow:Localized(@"NoNetWork")];
        }
    }];
}
#pragma mark - Account Center
// user Scan Qr Login
//- (void)getScanCodeLoginDataWithAddress:(NSString *)address
//                                   uuid:(NSString *)uuid
//                                success:(void (^)(id responseObject))success
//                                failure:(void (^)(NSError *error))failure
//{
//    [MBProgressHUD showActivityMessageInWindow:Localized(@"Loading")];
//    NSString * url = SERVER_COMBINE_API(_webServerDomain, Account_Center_ScanQRLogin);
//    NSDictionary * parameters = @{
//                                  @"address": address,
//                                  @"uuid": uuid,
//                                  };
//    [[HttpTool shareTool] POST:url parameters:parameters success:^(id responseObject) {
//        if(success != nil)
//        {
//            success(responseObject);
//        }
//    } failure:^(NSError *error) {
//        if(failure != nil)
//        {
//            failure(error);
//            [MBProgressHUD showTipMessageInWindow:Localized(@"NoNetWork")];
//        }
//    }];
//}
// Confirm Login
- (void)getAccountCenterDataWithAppId:(NSString *)appId
                                 uuid:(NSString *)uuid
                              success:(void (^)(id responseObject))success
                              failure:(void (^)(NSError *error))failure
{
    [MBProgressHUD showActivityMessageInWindow:Localized(@"Loading")];
    NSString * URL = Account_Center_ScanQRLogin;
    if (appId) {
        URL = Account_Center_Confirm_Login;
    }
    NSString * url = SERVER_COMBINE_API(_webServerDomain, URL);
    NSString * body = [NSString stringWithFormat:@"address=%@&uuid=%@&appId=%@", CurrentWalletAddress, uuid, appId];
    NSDictionary * parameters = [[HTTPManager shareManager] parametersWithHTTPBody:body];
    [[HttpTool shareTool] POST:url parameters:parameters success:^(id responseObject) {
        if(success != nil)
        {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        if(failure != nil)
        {
            failure(error);
            [MBProgressHUD showTipMessageInWindow:Localized(@"NoNetWork")];
        }
    }];
}
#pragma mark - Node application
// QR code information
- (void)getDposApplyNodeDataWithQRcodeSessionId:(NSString *)QRcodeSessionId
                                        success:(void (^)(id responseObject))success
                                        failure:(void (^)(NSError *error))failure
{
    [MBProgressHUD showActivityMessageInWindow:Localized(@"Loading")];
    NSString * url = SERVER_COMBINE_API(_webServerDomain, Node_Content);
    NSDictionary * parameters = @{
                                  @"qrcodeSessionId": QRcodeSessionId,
                                  @"initiatorAddress": CurrentWalletAddress
                                  };
    [[HttpTool shareTool] POST:url parameters:parameters success:^(id responseObject) {
        if(success != nil)
        {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        if(failure != nil)
        {
            failure(error);
            [MBProgressHUD showTipMessageInWindow:Localized(@"NoNetWork")];
        }
    }];
}
// Contract Transaction
- (void)getContractTransactionWithModel:(ConfirmTransactionModel *)confirmTransactionModel
                                success:(void (^)(id responseObject))success
                                failure:(void (^)(NSError *error))failure
{
    // Build BUSendOperation
    [MBProgressHUD showActivityMessageInWindow:Localized(@"Loading")];
    NSString * sourceAddress = CurrentWalletAddress;
    NSString * ID = confirmTransactionModel.qrcodeSessionId;
    if (confirmTransactionModel.nodeId) {
        ID = confirmTransactionModel.nodeId;
    }
    NSString * notes = confirmTransactionModel.qrRemark;
    int64_t fee = [[[NSDecimalNumber decimalNumberWithString:confirmTransactionModel.transactionCost] decimalNumberByMultiplyingByPowerOf10: Decimals_BU] longLongValue];
    int64_t nonce = [[HTTPManager shareManager] getAccountNonce: sourceAddress] + 1;
    if (nonce == 0) return;
    NSMutableArray * operations = [NSMutableArray array];
    int64_t amount = [[[NSDecimalNumber decimalNumberWithString:confirmTransactionModel.amount] decimalNumberByMultiplyingByPowerOf10: Decimals_BU] longLongValue];
    ContractInvokeByBUOperation *operation = [ContractInvokeByBUOperation new];
    [operation setSourceAddress: sourceAddress];
    [operation setContractAddress: confirmTransactionModel.destAddress];
    [operation setAmount: amount];
    [operation setInput:confirmTransactionModel.script];
    [operation setMetadata:notes];
    [operations addObject:operation];
    _hash = [[HTTPManager shareManager] buildBlobAndSignAndSubmit:nil :sourceAddress :nonce :gasPrice :fee :operations :notes :ID];
    if (_hash) {
        [[HTTPManager shareManager] getConfirmTransactionDataWithModel:confirmTransactionModel hash:_hash initiatorAddress:CurrentWalletAddress success:^(id responseObject) {
            if(success != nil)
            {
                success(responseObject);
            }
        } failure:^(NSError *error) {
            if(failure != nil)
            {
                failure(error);
                [MBProgressHUD showTipMessageInWindow:Localized(@"NoNetWork")];
            }
        }];
    }
}

// Confirm Transaction
- (void)getConfirmTransactionDataWithModel:(ConfirmTransactionModel *)confirmTransactionModel
                                      hash:(NSString *)hash
                          initiatorAddress:(NSString *)initiatorAddress
                                   success:(void (^)(id responseObject))success
                                   failure:(void (^)(NSError *error))failure
{
    NSString * URL = Node_Confirm;
    if ([confirmTransactionModel.type isEqualToString:TransactionType_NodeWithdrawal]) {
        URL = Node_Withdrawal_Confirm;
    }
    NSString * url = SERVER_COMBINE_API(_webServerDomain, URL);
    NSString * body = [NSString stringWithFormat:@"qrcodeSessionId=%@&hash=%@&initiatorAddress=%@&nodeId=%@", confirmTransactionModel.qrcodeSessionId, hash, initiatorAddress, confirmTransactionModel.nodeId];
    NSDictionary * parameters = [[HTTPManager shareManager] parametersWithHTTPBody:body];
    [[HttpTool shareTool] POST:url parameters:parameters success:^(id responseObject) {
        if(success != nil)
        {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        if(failure != nil)
        {
            failure(error);
            [MBProgressHUD showTipMessageInWindow:Localized(@"NoNetWork")];
        }
    }];
}
// submit Contract Transaction / Transaction Status
- (void)submitContractTransactionPassword:(NSString *)password
                                  success:(void (^)(TransactionResultModel * resultModel))success
                                  failure:(void (^)(TransactionResultModel * resultModel))failure
{
    NSString * walletKeyStore = CurrentWalletKeyStore;
    NSString * privateKey = [NSString decipherKeyStoreWithPW:password keyStoreValueStr:walletKeyStore];
    if ([Tools isEmpty:privateKey]) {
        [MBProgressHUD showTipMessageInWindow:Localized(@"PasswordIsIncorrect")];
        return;
    }
    BOOL ifSubmitSuccess = [[HTTPManager shareManager] buildSignAndSubmit: privateKey];
    if (ifSubmitSuccess) {
        [[HTTPManager shareManager] getTransactionStatusHash:_hash success:success failure:failure];
    }
}
// Node List
- (void)getNodeListDataWithIdentityType:(NSString *)identityType
                               nodeName:(NSString *)nodeName
                         capitalAddress:(NSString *)capitalAddress
                                success:(void (^)(id responseObject))success
                                failure:(void (^)(NSError *error))failure
{
    [MBProgressHUD showActivityMessageInWindow:Localized(@"Loading")];
    NSString * url = SERVER_COMBINE_API(_webServerDomain, Node_List);
    NSString * body = [NSString stringWithFormat:@"address=%@&identityType=%@&nodeName=%@&capitalAddress=%@", CurrentWalletAddress, identityType, nodeName, capitalAddress];
    NSDictionary * parameters = [[HTTPManager shareManager] parametersWithHTTPBody:body];
    [[HttpTool shareTool] POST:url parameters:parameters success:^(id responseObject) {
        if(success != nil)
        {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        if(failure != nil)
        {
            failure(error);
        }
    }];
}
// Voting Record
- (void)getVotingRecordDataWithNodeId:(NSString *)nodeId
                              success:(void (^)(id responseObject))success
                              failure:(void (^)(NSError *error))failure
{
    [MBProgressHUD showActivityMessageInWindow:Localized(@"Loading")];
    NSString * url = SERVER_COMBINE_API(_webServerDomain, Voting_Record);
    NSString * body = [NSString stringWithFormat:@"address=%@&nodeId=%@", CurrentWalletAddress, nodeId];
    NSDictionary * parameters = [[HTTPManager shareManager] parametersWithHTTPBody:body];
    [[HttpTool shareTool] POST:url parameters:parameters success:^(id responseObject) {
        if(success != nil)
        {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        if(failure != nil)
        {
            failure(error);
        }
    }];
}
#pragma mark - SDK
// Check the balance
- (int64_t)getAccountBalance {
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD showActivityMessageInWindow:Localized(@"Loading")];
    });
    AccountService *accountService = [[[SDK sharedInstance] setUrl:_bumoNodeUrl] getAccountService];
    AccountGetBalanceRequest * request = [AccountGetBalanceRequest new];
    [request setAddress : CurrentWalletAddress];
    AccountGetBalanceResponse *response = [accountService getBalance : request];
    if (response.errorCode == Success_Code) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUD];
        });
        return response.result.balance;
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUD];
            [MBProgressHUD showTipMessageInWindow:[ErrorTypeTool getDescription:response.errorCode]];
        });
        return 0;
    }
}

// Query cost standard
// Obtain minimum asset limits and fuel unit prices for accounts in designated blocks
- (void)getBlockLatestFees {
    BlockService *service = [[[SDK sharedInstance] setUrl: _bumoNodeUrl] getBlockService];
    BlockGetLatestFeesResponse * response = [service getLatestFees];
    NSString * minAssetLimit = TransactionCost_MIN;
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    if (response.errorCode == Success_Code) {
        minAssetLimit = [[[NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%lld", response.result.fees.baseReserve]] decimalNumberByMultiplyingByPowerOf10: -Decimals_BU] stringValue];
        [defaults setObject:minAssetLimit forKey:Minimum_Asset_Limitation];
    } else {
        [defaults setObject:minAssetLimit forKey:Minimum_Asset_Limitation];
    }
    
    [defaults synchronize];
}
// Balance judgment
- (NSDecimalNumber *)getDataWithBalanceJudgmentWithCost:(NSString *)cost ifShowLoading:(BOOL)ifShowLoading
{
    if (ifShowLoading == YES) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD showActivityMessageInWindow:Localized(@"Loading")];
        });
    }
    NSDecimalNumber * balance = 0;
    NSDecimalNumber * minLimitationNumber = [NSDecimalNumber decimalNumberWithString:[[NSUserDefaults standardUserDefaults] objectForKey:Minimum_Asset_Limitation]];
    NSDecimalNumber * costNumber = [NSDecimalNumber decimalNumberWithString:cost];
    __block NSDecimalNumber * amount = 0;
    AccountService *accountService = [[[SDK sharedInstance] setUrl:_bumoNodeUrl] getAccountService];
    AccountGetBalanceRequest * request = [AccountGetBalanceRequest new];
    [request setAddress : CurrentWalletAddress];
    AccountGetBalanceResponse *response = [accountService getBalance : request];
    if (response.errorCode == Success_Code) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (ifShowLoading == YES) {
                [MBProgressHUD hideHUD];
            }
        });
        balance = [[NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%lld", response.result.balance]] decimalNumberByMultiplyingByPowerOf10: -Decimals_BU];
//        balance = [Tools MO2BU:response.result.balance];
        amount = [[balance decimalNumberBySubtracting:minLimitationNumber] decimalNumberBySubtracting: costNumber];
//        balance - baseReserve - cost;
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (ifShowLoading == YES) {
                [MBProgressHUD hideHUD];
            }
            amount = [NSDecimalNumber decimalNumberWithString:@""];
            [MBProgressHUD showTipMessageInWindow:[ErrorTypeTool getDescription:response.errorCode]];
        });
    }
    return amount;
}
// Balance of assets
- (int64_t)getAssetInfoWithAddress:(NSString *)address code:(NSString *)code issuer:(NSString *)issuer
{
    AssetGetInfoRequest *request = [AssetGetInfoRequest new];
    [request setAddress : address];
    [request setCode : code];
    [request setIssuer : issuer];
    AssetService *assetService = [[[SDK sharedInstance] setUrl: _bumoNodeUrl] getAssetService];
    AssetGetInfoResponse *response = [assetService getInfo : request];
    if (response.errorCode == 0) {
        AssetInfo *assetInfo = response.result.assets[0];
        return assetInfo.amount;
    } else {
        [MBProgressHUD showTipMessageInWindow:[ErrorTypeTool getDescription:response.errorCode]];
        return 0;
    }
}

// Query account / Is it activated?
- (NSString *)getAccountInfoWithAddress:(NSString *)address {
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [MBProgressHUD showActivityMessageInWindow:Localized(@"Loading")];
//    });
    AccountService * accountService = [[[SDK sharedInstance] setUrl:_bumoNodeUrl] getAccountService];
    AccountGetInfoRequest *request = [AccountGetInfoRequest new];
    [request setAddress : address];
    AccountGetInfoResponse *response = [accountService getInfo : request];
    if (response.errorCode == 0) {
        //        NSLog(@"%@", [response.result yy_modelToJSONString]);
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [MBProgressHUD hideHUD];
//        });
        return TransactionCost_MIN;
    } else if (response.errorCode == 4) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [MBProgressHUD hideHUD];
//        });
        return TransactionCost_NotActive_MIN;
    } else {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [MBProgressHUD hideHUD];
//            [MBProgressHUD showTipMessageInWindow:[ErrorTypeTool getDescription:response.errorCode]];
//        });
        return TransactionCost_MIN;
    }
}

// identity data
- (void)setAccountDataWithRandom:(NSData *)random
                        password:(NSString *)password
                    identityName:(NSString *)identityName
                       typeTitle:(NSString *)typeTitle
                         success:(void (^)(id responseObject))success
                         failure:(void (^)(NSError *error))failure
{
    [MBProgressHUD showActivityMessageInWindow:Localized(@"Loading")];
//    __weak typeof(self) weakSelf = self;
    NSOperationQueue * queue = [[NSOperationQueue alloc] init];
    [queue addOperationWithBlock:^{
        // Random number -> mnemonic
        NSArray * words = [Mnemonic generateMnemonicCode: [random copy]];
        NSMutableArray * hdPaths = [NSMutableArray arrayWithObjects:@"M/44H/526H/0H/0/0", @"M/44H/526H/1H/0/0", nil];
        NSArray *privateKeys = [Mnemonic generatePrivateKeys: words : hdPaths];
        NSString * randomKey = [NSString generateKeyStoreWithPW:password randomKey:random];
        // private key -> address
        NSString * identityAddress = [Keypair getEncAddress : [Keypair getEncPublicKey: [privateKeys firstObject]]];
        NSString * identityKeyStore = [NSString generateKeyStoreWithPW:password key:[privateKeys firstObject]];
        NSString * walletAddress = [Keypair getEncAddress : [Keypair getEncPublicKey: [privateKeys lastObject]]];
        NSString * walletKeyStore = [NSString generateKeyStoreWithPW:password key:[privateKeys lastObject]];
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            if (randomKey == nil || identityKeyStore == nil || walletKeyStore == nil) {
                [MBProgressHUD hideHUD];
                if ([typeTitle isEqualToString:Localized(@"CreateIdentity")]) {
                    [MBProgressHUD showTipMessageInWindow:Localized(@"CreateIdentityFailure")];
                } else if ([typeTitle isEqualToString:Localized(@"RestoreIdentity")]) {
                    [MBProgressHUD showTipMessageInWindow:Localized(@"MnemonicIsIncorrect")];
                } else if ([typeTitle isEqualToString:Localized(@"ModifyPassword")]) {
                    [MBProgressHUD showTipMessageInWindow:Localized(@"ModifyPasswordFailure")];
                } else if ([typeTitle isEqualToString:Localized(@"SafetyReinforcementTitle")]) {
                    [MBProgressHUD showTipMessageInWindow:Localized(@"PasswordIsIncorrect")];
                }
            } else {
                [MBProgressHUD hideHUD];
                if(success != nil)
                {
                    AccountModel * account = [[AccountModel alloc] init];
                    account.identityName = identityName;
                    account.randomNumber = randomKey;
                    account.identityAddress = identityAddress;
                    account.identityKeyStore = identityKeyStore;
                    account.walletName = Current_WalletName;
                    account.walletAddress = walletAddress;
                    account.walletKeyStore = walletKeyStore;
                    [[AccountTool shareTool] save:account];
                    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
                    [defaults setObject:walletAddress forKey:Current_WalletAddress];
                    [defaults setObject:walletKeyStore forKey:Current_WalletKeyStore];
                    [defaults setObject:Current_WalletName forKey:Current_WalletName];
                    [defaults synchronize];
                    success(words);
                }
            }
        }];
    }];
}

// Wallet data
- (void)setWalletDataWithMnemonics:(NSArray *)mnemonics
                          password:(NSString *)password
                        walletName:(NSString *)walletName
                           success:(void (^)(id responseObject))success
                           failure:(void (^)(NSError *error))failure
{
    [MBProgressHUD showActivityMessageInWindow:Localized(@"Loading")];
    //    __weak typeof(self) weakSelf = self;
    NSOperationQueue * queue = [[NSOperationQueue alloc] init];
    [queue addOperationWithBlock:^{
        // Random number -> mnemonic
        NSMutableArray * hdPaths = [NSMutableArray arrayWithObjects:@"M/44H/526H/0H/0/0", @"M/44H/526H/1H/0/0", nil];
        NSArray * privateKeys = [Mnemonic generatePrivateKeys: mnemonics : hdPaths];
        // private key -> address
        NSString * walletAddress = [Keypair getEncAddress : [Keypair getEncPublicKey: [privateKeys lastObject]]];
        NSString * walletKeyStore = [NSString generateKeyStoreWithPW:password key:[privateKeys lastObject]];
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            if (walletKeyStore == nil) {
                [MBProgressHUD hideHUD];
                [MBProgressHUD showTipMessageInWindow:Localized(@"FailureToImportWallet")];
            } else {
                [MBProgressHUD hideHUD];
                if(success != nil)
                {
                    BOOL ifImportSuccess = [self importWalletDataWalletName:walletName walletAddress:walletAddress walletKeyStore:walletKeyStore];
                    if (ifImportSuccess) {
                        success(walletAddress);
                    }
                }
            }
        }];
    }];
}
- (BOOL)importWalletDataWalletName:(NSString *)walletName
                     walletAddress:(NSString *)walletAddress
                    walletKeyStore:(NSString *)walletKeyStore
{
    BOOL imported = NO;
    if ([walletAddress isEqualToString:[[[AccountTool shareTool] account] walletAddress]]) {
        [MBProgressHUD showTipMessageInWindow:Localized(@"WalletDuplicateImport")];
        imported = YES;
    }
    NSArray * importedWalletArray = [[WalletTool shareTool] walletArray];
    for (WalletModel * walletModel in importedWalletArray) {
        if ([walletModel.walletAddress isEqualToString:walletAddress]) {
            [MBProgressHUD showTipMessageInWindow:Localized(@"WalletDuplicateImport")];
            imported = YES;
        }
    }
    if (imported == NO) {
        NSMutableArray * importedWallet = [NSMutableArray array];
        [importedWallet addObjectsFromArray:importedWalletArray];
        WalletModel * walletModel = [[WalletModel alloc] init];
        walletModel.walletName = walletName;
        walletModel.walletAddress = walletAddress;
        walletModel.walletKeyStore = walletKeyStore;
        [importedWallet addObject:walletModel];
        [[WalletTool shareTool] save:importedWallet];
    }
    return !imported;
}
// Transfer accounts
- (void)setTransferDataWithTokenType:(NSInteger)tokenType
                            password:(NSString *)password
                         destAddress:(NSString *)destAddress
                              assets:(NSString *)assets
                            decimals:(NSInteger)decimals
                            feeLimit:(NSString *)feeLimit
                               notes:(NSString *)notes
                                code:(NSString *)code
                              issuer:(NSString *)issuer
                             success:(void (^)(TransactionResultModel * resultModel))success
                             failure:(void (^)(TransactionResultModel * resultModel))failure
{
    // Build BUSendOperation
    NSString * sourceAddress = CurrentWalletAddress;
    NSString * walletKeyStore = CurrentWalletKeyStore;
    NSString * privateKey = [NSString decipherKeyStoreWithPW:password keyStoreValueStr:walletKeyStore];
    if ([Tools isEmpty:privateKey]) {
        [MBProgressHUD showTipMessageInWindow:Localized(@"PasswordIsIncorrect")];
        return;
    }
    int64_t fee = [[[NSDecimalNumber decimalNumberWithString:feeLimit] decimalNumberByMultiplyingByPowerOf10: Decimals_BU] longLongValue];
    int64_t nonce = [[HTTPManager shareManager] getAccountNonce: sourceAddress] + 1;
    if (nonce == 0) return;
    NSString * hash;
    NSMutableArray * operations = [NSMutableArray array];
    if (tokenType == Token_Type_BU) {
        // BU
        int64_t amount = [[[NSDecimalNumber decimalNumberWithString:assets] decimalNumberByMultiplyingByPowerOf10: Decimals_BU] longLongValue];
        BUSendOperation *operation = [BUSendOperation new];
        [operation setSourceAddress: sourceAddress];
        [operation setDestAddress: destAddress];
        [operation setAmount: amount];
        [operations addObject:operation];
        hash = [[HTTPManager shareManager] buildBlobAndSignAndSubmit:privateKey :sourceAddress :nonce :gasPrice :fee :operations :notes :nil];
    } else {
        // Other currencies
        int64_t amount = [[[NSDecimalNumber decimalNumberWithString:assets] decimalNumberByMultiplyingByPowerOf10: decimals] longLongValue];
//        int64_t amount = multiplierNumber * powl(10, decimals);
        if ([[self getAccountInfoWithAddress: destAddress] isEqualToString:TransactionCost_NotActive_MIN]) {
            AccountActivateOperation *activateOperation = [AccountActivateOperation new];
            [activateOperation setSourceAddress: sourceAddress];
            [activateOperation setDestAddress: destAddress];
            int64_t initBalance = [[[NSDecimalNumber decimalNumberWithString:ActivateInitBalance] decimalNumberByMultiplyingByPowerOf10: Decimals_BU] longLongValue];
            [activateOperation setInitBalance: initBalance];
            [operations addObject: activateOperation];
            
        }
        AssetSendOperation *operation = [AssetSendOperation new];
        [operation setSourceAddress: sourceAddress];
        [operation setDestAddress: destAddress];
        [operation setCode: code];
        [operation setIssuer: issuer];
        [operation setAmount: amount];
        [operations addObject: operation];
        hash = [[HTTPManager shareManager] buildBlobAndSignAndSubmit:privateKey :sourceAddress :nonce :gasPrice :fee :operations :notes :nil];
    }
    if (![Tools isEmpty: hash]) {
        [[HTTPManager shareManager] getTransactionStatusHash:hash success:success failure:failure];
    }
}

// register
- (void)getRegisteredDataWithPassword:(NSString *)password
                      registeredModel:(RegisteredModel *)registeredModel
                              success:(void (^)(TransactionResultModel * resultModel))success
                              failure:(void (^)(TransactionResultModel * resultModel))failure
{
    NSString * sourceAddress = CurrentWalletAddress;
    NSString *key = [NSString stringWithFormat: @"asset_property_%@", registeredModel.code];
    AtpProperty * atpProperty = [[AtpProperty alloc] init];
    int64_t total = [[[NSDecimalNumber decimalNumberWithString:registeredModel.amount] decimalNumberByMultiplyingByPowerOf10: registeredModel.decimals] longLongValue];
    atpProperty.name = registeredModel.name;
    atpProperty.code = registeredModel.code;
    atpProperty.totalSupply = total;
    atpProperty.decimals = registeredModel.decimals;
    atpProperty.Description = registeredModel.desc;
    atpProperty.icon = @"";
    atpProperty.version = ATP_Version;
    NSString * value = [atpProperty yy_modelToJSONString];
    AccountSetMetadataOperation *operation = [AccountSetMetadataOperation new];
    [operation setSourceAddress : sourceAddress];
    [operation setKey : key];
    [operation setValue : value];
    NSString * privateKey = [NSString decipherKeyStoreWithPW:password keyStoreValueStr:CurrentWalletKeyStore];
    if ([Tools isEmpty:privateKey]) {
        [MBProgressHUD showTipMessageInWindow:Localized(@"PasswordIsIncorrect")];
        return;
    }
    int64_t feeLimit = [[[NSDecimalNumber decimalNumberWithString:Registered_Cost] decimalNumberByMultiplyingByPowerOf10: Decimals_BU] longLongValue];
    int64_t nonce = [[HTTPManager shareManager] getAccountNonce: sourceAddress] + 1;
    if (nonce == 0) return;
    NSMutableArray * operations = [NSMutableArray array];
    [operations addObject:operation];
    NSString * hash = [[HTTPManager shareManager] buildBlobAndSignAndSubmit:privateKey :sourceAddress :nonce :gasPrice :feeLimit :operations :nil :nil];
    if (![Tools isEmpty: hash]) {
        [[HTTPManager shareManager] getTransactionStatusHash:hash success:success failure:failure];
    }
}
// Issue
- (void)getIssueAssetDataWithPassword:(NSString *)password
                            assetCode:(NSString *)assetCode
                           assetAmount:(int64_t)assetAmount
                             decimals:(NSInteger)decimals
                              success:(void (^)(TransactionResultModel * resultModel))success
                              failure:(void (^)(TransactionResultModel * resultModel))failure
{
    NSString * sourceAddress = CurrentWalletAddress;
    // Asset amount
//    int64_t amount = [assetAmount longLongValue] * powl(10, decimals);
    AssetIssueOperation *operation = [AssetIssueOperation new];
    [operation setSourceAddress: sourceAddress];
    [operation setCode: assetCode];
    [operation setAmount: assetAmount];
    NSString * privateKey = [NSString decipherKeyStoreWithPW:password keyStoreValueStr:CurrentWalletKeyStore];
    if ([Tools isEmpty:privateKey]) {
        [MBProgressHUD showTipMessageInWindow:Localized(@"PasswordIsIncorrect")];
        return;
    }
    int64_t feeLimit = [[[NSDecimalNumber decimalNumberWithString:Distribution_Cost] decimalNumberByMultiplyingByPowerOf10: Decimals_BU] longLongValue];
    int64_t nonce = [[HTTPManager shareManager] getAccountNonce: sourceAddress] + 1;
    if (nonce == 0) return;
    NSMutableArray * operations = [NSMutableArray array];
    [operations addObject:operation];
    NSString * hash = [[HTTPManager shareManager] buildBlobAndSignAndSubmit:privateKey :sourceAddress :nonce :gasPrice :feeLimit :operations :nil : nil];
    if (![Tools isEmpty: hash]) {
        [[HTTPManager shareManager] getTransactionStatusHash:hash success:success failure:failure];
    }
}

- (int64_t) getAccountNonce: (NSString *)address {
    int64_t nonce = -1;
    AccountService *accountService = [[[SDK sharedInstance] setUrl:_bumoNodeUrl] getAccountService];
    AccountGetNonceRequest * request = [AccountGetNonceRequest new];
    [request setAddress : address];
    AccountGetNonceResponse *response = [accountService getNonce : request];
    if (response.errorCode == Success_Code) {
        nonce = response.result.nonce;
    } else {
        [MBProgressHUD showTipMessageInWindow:[ErrorTypeTool getDescription:response.errorCode]];
    }
    return nonce;
}
// transaction information
- (NSString *) buildBlobAndSignAndSubmit : (NSString *) privateKey : (NSString *) sourceAddress : (int64_t) nonce : (int64_t) gasPrice : (int64_t) feeLimit : (NSMutableArray<BaseOperation *> *) operations : (NSString *) notes : (NSString *)ID {
    TransactionBuildBlobRequest *buildBlobRequest = [TransactionBuildBlobRequest new];
    [buildBlobRequest setSourceAddress : sourceAddress];
    [buildBlobRequest setNonce : nonce];
    [buildBlobRequest setGasPrice : gasPrice];
    [buildBlobRequest setFeeLimit : feeLimit];
    //[buildBlobRequest addOperation : operation];
    [buildBlobRequest setOperations: operations];
    [buildBlobRequest setMetadata: notes];
    
    // Serialization transaction
    _transactionService = [[[SDK sharedInstance] setUrl:_bumoNodeUrl] getTransactionService];
    _buildBlobResponse = [_transactionService buildBlob : buildBlobRequest];
    __block NSString *hash = nil;
    if (_buildBlobResponse.errorCode == Success_Code) {
        hash = _buildBlobResponse.result.transactionHash;
    } else {
        [MBProgressHUD showTipMessageInWindow:[ErrorTypeTool getDescription:_buildBlobResponse.errorCode]];
    }

    if (hash && !ID) {
        BOOL ifSubmitSuccess = [[HTTPManager shareManager] buildSignAndSubmit :privateKey];
        if (!ifSubmitSuccess) {
            hash = nil;
        }
    }
    return hash;
}
// Submit transaction
- (BOOL)buildSignAndSubmit : (NSString *)privateKey
{
    // sign
    TransactionSignRequest *signRequest = [TransactionSignRequest new];
    [signRequest setBlob : _buildBlobResponse.result.transactionBlob];
    [signRequest addPrivateKey : privateKey];
    TransactionSignResponse * signResponse = [_transactionService sign : signRequest];
    if (signResponse.errorCode == Success_Code) {
        // Submission of transactions
        TransactionSubmitRequest *submitRequest = [TransactionSubmitRequest new];
        [submitRequest setTransactionBlob : _buildBlobResponse.result.transactionBlob];
        [submitRequest setSignatures : [signResponse.result.signatures copy]];
        TransactionSubmitResponse *submitResponse = [_transactionService submit : submitRequest];
        if (submitResponse.errorCode == Success_Code) {
            return YES;
        } else {
            [MBProgressHUD showTipMessageInWindow:[ErrorTypeTool getDescription:submitResponse.errorCode]];
            return NO;
        }
    } else {
        [MBProgressHUD showTipMessageInWindow:[ErrorTypeTool getDescription:signResponse.errorCode]];
        return NO;
    }
}



// Judge whether the transfer / registration / issuance is successful.
- (void)getTransactionStatusHash:(NSString *)hash
                         success:(void (^)(TransactionResultModel * resultModel))success
                         failure:(void (^)(TransactionResultModel * resultModel))failure
{
    [MBProgressHUD showActivityMessageInWindow:Localized(@"Loading")];
    __block TransactionGetInfoResponse *response = [TransactionGetInfoResponse new];
    __block TransactionResultModel * resultModel = [[TransactionResultModel alloc] init];
    resultModel.transactionHash = hash;
    __block NSInteger state = 0;
    
    // 创建一个定时器(dispatch_source_t本质还是个OC对象)
    dispatch_queue_t queue = dispatch_get_main_queue();
    __block dispatch_source_t gcdTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    uint64_t interval = (uint64_t)(1 * NSEC_PER_SEC);
    //  DISPATCH_TIME_NOW 立即执行
    dispatch_source_set_timer(gcdTimer, DISPATCH_TIME_NOW, interval, 0);
    
    // 设置回调
    dispatch_source_set_event_handler(gcdTimer, ^{
        if (state == Maximum_Number) {
            dispatch_async(dispatch_get_main_queue(), ^{
                dispatch_cancel(gcdTimer);
                gcdTimer = nil;
                [MBProgressHUD hideHUD];
                if(failure != nil)
                {
                    resultModel.errorCode = response.errorCode;
                    failure(resultModel);
                }
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                TransactionGetInfoRequest *request = [TransactionGetInfoRequest new];
                [request setHash: hash];
                TransactionService *service = [[[SDK sharedInstance] setUrl: _bumoNodeUrl] getTransactionService];
                response = [service getInfo: request];
                if (response.errorCode == Success_Code) {
                    dispatch_cancel(gcdTimer);
                    gcdTimer = nil;
                } else {
                    state ++;
                }
                if(response.result.transactions != nil && success != nil)
                {
                    [MBProgressHUD hideHUD];
                    TransactionHistory * history = response.result.transactions[0];
                    resultModel.transactionTime = history.closeTime;
                    resultModel.actualFee = [[[NSDecimalNumber decimalNumberWithString:history.actualFee] decimalNumberByMultiplyingByPowerOf10: -Decimals_BU] stringValue];
                    resultModel.errorCode = history.errorCode;
                    resultModel.errorDesc = history.errorDesc;
                    success(resultModel);
                }
            });
        }
        TransactionGetInfoRequest *request = [TransactionGetInfoRequest new];
        [request setHash: hash];
        TransactionService *service = [[[SDK sharedInstance] setUrl: _bumoNodeUrl] getTransactionService];
        response = [service getInfo: request];
        
    });
    
    dispatch_resume(gcdTimer);
}

@end
