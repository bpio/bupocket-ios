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
    TransactionSignResponse * _signResponse;
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
    [self setNodeURL];
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults boolForKey:If_Custom_Network] == YES) {
        _webServerDomain = [defaults objectForKey:Server_Custom];
        _bumoNodeUrl = [defaults objectForKey:Current_Node_URL_Custom];
    } else if ([defaults boolForKey:If_Switch_TestNetwork] == YES) {
        _webServerDomain = WEB_SERVER_DOMAIN_TEST;
        // BUMO_NODE_URL_TEST
        _bumoNodeUrl = [defaults objectForKey:Current_Node_URL_Test];
        _shareManager.pushMessageSocketUrl = BUMO_TOOLS_URL_TEST;
    } else {
        _webServerDomain = WEB_SERVER_DOMAIN;
        // BUMO_NODE_URL
        _bumoNodeUrl = [defaults objectForKey:Current_Node_URL];
        _shareManager.pushMessageSocketUrl = BUMO_TOOLS_URL;
    }
}
- (void)setNodeURL
{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSArray * nodeURLArray = [defaults objectForKey:Node_URL_Array];
    if (nodeURLArray.count < 2) {
        [defaults setObject:@[BUMO_NODE_URL] forKey:Node_URL_Array];
        [defaults setObject:BUMO_NODE_URL forKey:Current_Node_URL];
        [defaults synchronize];
    }
    NSArray * nodeURLTestArray = [defaults objectForKey:Node_URL_Array_Test];
    if (nodeURLTestArray.count < 2) {
        [defaults setObject:@[BUMO_NODE_URL_TEST] forKey:Node_URL_Array_Test];
        [defaults setObject:BUMO_NODE_URL_TEST forKey:Current_Node_URL_Test];
        [defaults synchronize];
    }
    /*
    NSArray * nodeURLCustomArray = [defaults objectForKey:Node_URL_Array_Custom];
    NSString * customNodeUrl = [defaults objectForKey:Current_Node_URL_Custom];
    if (nodeURLCustomArray.count < 2 && NotNULLString(customNodeUrl)) {
        [defaults setObject:@[customNodeUrl] forKey:Node_URL_Array_Custom];
        [defaults setObject:customNodeUrl forKey:Current_Node_URL_Custom];
        [defaults synchronize];
    }
     */
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
// show Custom network
- (void)ShowCustomNetwork
{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:YES forKey:If_Show_Custom_Network];
    [defaults synchronize];
}
// Custom network
- (void)SwitchedNetworkWithIsCustom:(BOOL)isCustom
{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:isCustom forKey:If_Custom_Network];
    [defaults synchronize];
    [self initNetWork];
}
// Switched Node url
- (void)SwitchedNodeWithURL:(NSString *)URL
{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults boolForKey:If_Custom_Network] == YES) {
        [defaults setObject:URL forKey:Current_Node_URL_Custom];
    } else if ([defaults boolForKey:If_Switch_TestNetwork]) {
        [defaults setObject:URL forKey:Current_Node_URL_Test];
    } else {
        [defaults setObject:URL forKey:Current_Node_URL];
    }
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
            [MBProgressHUD showTipMessageInWindow:Localized(@"NoNetWork")];
        }
    }];
}
// Version Log
- (void)getVersionLogDataWithPageIndex:(NSInteger)pageIndex
                               success:(void (^)(id responseObject))success
                               failure:(void (^)(NSError *error))failure
{
    NSString * url = SERVER_COMBINE_API(_webServerDomain, Version_Log);
    NSString * body = [NSString stringWithFormat:@"appType=2&pageStart=%zd&pageSize=%d", pageIndex, PageSize_Max];
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
                                  @"contact": contact,
                                  @"walletAddress": CurrentWalletAddress,
                                  @"walletVer": [NSString stringWithFormat:@"V%@", App_Version],
                                  @"osVer": [NSString stringWithFormat:@"%@ %@", iOS_Name, iOS_Version],
                                  @"brandName": [[UIDevice currentDevice] machineModelName]
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
// find ad banner
- (void)getAdsDataWithURL:(NSString *)URL
                  success:(void (^)(id responseObject))success
                  failure:(void (^)(NSError *error))failure
{
    NSString * url = SERVER_COMBINE_API(_webServerDomain, URL);
    [[HttpTool shareTool] GET:url parameters:nil success:^(id responseObject) {
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
// Node URL Check
- (void)getNodeDataWithURL:(NSString *)URL
                  success:(void (^)(id responseObject))success
                  failure:(void (^)(NSError *error))failure
{
    [MBProgressHUD showActivityMessageInWindow:Localized(@"Loading")];
    [[HttpTool shareTool] GET:URL parameters:nil success:^(id responseObject) {
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

#pragma mark 确认交易
// Contract Transaction hash
- (BOOL)getTransactionHashWithModel:(ConfirmTransactionModel *)confirmTransactionModel
{
    NSString * sourceAddress = CurrentWalletAddress;
    NSString * ID = confirmTransactionModel.qrcodeSessionId;
    if (confirmTransactionModel.nodeId) {
        ID = confirmTransactionModel.nodeId;
    }
    NSString * notes = confirmTransactionModel.qrRemarkEn;
    int64_t fee = [[[NSDecimalNumber decimalNumberWithString:confirmTransactionModel.transactionCost] decimalNumberByMultiplyingByPowerOf10: Decimals_BU] longLongValue];
    int64_t nonce = [[HTTPManager shareManager] getAccountNonce: sourceAddress] + 1;
    if (nonce == 0) return NO;
    NSMutableArray * operations = [NSMutableArray array];
    int64_t amount = [[[NSDecimalNumber decimalNumberWithString:confirmTransactionModel.amount] decimalNumberByMultiplyingByPowerOf10: Decimals_BU] longLongValue];
    
    if ([confirmTransactionModel.type integerValue] == TransactionTypeCooperate) {
        ContractCreateOperation * contractCreateOperation = [ContractCreateOperation new];
        [contractCreateOperation setSourceAddress: sourceAddress];
        int64_t activateCost = [[[NSDecimalNumber decimalNumberWithString:Activate_Cooperate_MIN] decimalNumberByMultiplyingByPowerOf10: Decimals_BU] longLongValue];
        [contractCreateOperation setInitBalance:amount + activateCost];
        NSDictionary * scriptDic = [JsonTool dictionaryOrArrayWithJSONSString:confirmTransactionModel.script];
        [contractCreateOperation setInitInput:scriptDic[@"input"]];
        [contractCreateOperation setPayload:scriptDic[@"payload"]];
        [contractCreateOperation setMetadata:notes];
        [operations addObject:contractCreateOperation];
    } else {
        ContractInvokeByBUOperation *operation = [ContractInvokeByBUOperation new];
        [operation setSourceAddress: sourceAddress];
        [operation setContractAddress: confirmTransactionModel.destAddress];
        [operation setAmount: amount];
        [operation setInput:confirmTransactionModel.script];
        [operation setMetadata:notes];
        [operations addObject:operation];
    }
    return [[HTTPManager shareManager] getHashWithSourceAddress:sourceAddress nonce:nonce gasPrice:gasPrice feeLimit:fee operations:operations notes:notes];
}
#pragma mark 确认交易
- (void)getContractTransactionWithModel:(ConfirmTransactionModel *)confirmTransactionModel
                                success:(void (^)(id responseObject))success
                                failure:(void (^)(NSError *error))failure
{
    // Build BUSendOperation
    [MBProgressHUD showActivityMessageInWindow:Localized(@"DataChecking")];
    DLog(@"hash:%@", _hash);
    if (([confirmTransactionModel.type integerValue] == TransactionTypeCooperateSupport || [confirmTransactionModel.type integerValue] == TransactionTypeCooperateSignOut) && confirmTransactionModel.isCooperateDetail == YES) {
        NSString * URL = Node_Cooperate_Exit;
        if ([confirmTransactionModel.type integerValue] == TransactionTypeCooperateSupport) {
            URL = Node_Cooperate_Support;
        }
        [[HTTPManager shareManager] getNodeCooperateCheckDataWithURL:URL nodeId:confirmTransactionModel.nodeId copies:confirmTransactionModel.copies success:^(id responseObject) {
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
    } else {
        [[HTTPManager shareManager] getConfirmTransactionDataWithModel:confirmTransactionModel initiatorAddress:CurrentWalletAddress success:^(id responseObject) {
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
                          initiatorAddress:(NSString *)initiatorAddress
                                   success:(void (^)(id responseObject))success
                                   failure:(void (^)(NSError *error))failure
{
    NSString * URL = Node_Confirm;
    if ([confirmTransactionModel.type integerValue] == TransactionTypeNodeWithdrawal) {
        URL = Node_Withdrawal_Confirm;
    }
    NSString * url = SERVER_COMBINE_API(_webServerDomain, URL);
    NSString * body = [NSString stringWithFormat:@"qrcodeSessionId=%@&hash=%@&initiatorAddress=%@&nodeId=%@", confirmTransactionModel.qrcodeSessionId, _hash, initiatorAddress, confirmTransactionModel.nodeId];
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
// short link
- (void)getShortLinkDataWithType:(NSString *)type
                            path:(NSString *)path
                         success:(void (^)(id responseObject))success
                         failure:(void (^)(NSError *error))failure
{
    [MBProgressHUD showActivityMessageInWindow:Localized(@"Loading")];
    NSString * url = SERVER_COMBINE_API(_webServerDomain, Node_ShortLink_URL);
    NSString * body = [NSString stringWithFormat:@"type=%@&path=%@", type, path];
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
// Node List
- (void)getNodeListDataWithIdentityType:(NSString *)identityType
                               nodeName:(NSString *)nodeName
                         capitalAddress:(NSString *)capitalAddress
                                success:(void (^)(id responseObject))success
                                failure:(void (^)(NSError *error))failure
{
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

// Node Invitation Vote
- (void)getNodeInvitationVoteDataWithNodeId:(NSString *)nodeId
                                    success:(void (^)(id responseObject))success
                                    failure:(void (^)(NSError *error))failure
{
    NSString * url = SERVER_COMBINE_API(_webServerDomain, Node_Invitation_Vote);
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

// Voting Record
- (void)getVotingRecordDataWithNodeId:(NSString *)nodeId
                              success:(void (^)(id responseObject))success
                              failure:(void (^)(NSError *error))failure
{
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
// Node Cooperate List
- (void)getNodeCooperateListDataSuccess:(void (^)(id responseObject))success
                                failure:(void (^)(NSError *error))failure
{
    NSString * url = SERVER_COMBINE_API(_webServerDomain, Node_Cooperate_List);
    [[HttpTool shareTool] POST:url parameters:nil success:^(id responseObject) {
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
// Node Cooperate Detail
- (void)getNodeCooperateDetailDataWithNodeId:(NSString *)nodeId
                                     success:(void (^)(id responseObject))success
                                     failure:(void (^)(NSError *error))failure
{
    NSString * url = SERVER_COMBINE_API(_webServerDomain, Node_Cooperate_Detail);
    NSString * body = [NSString stringWithFormat:@"nodeId=%@", nodeId];
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
// Node Cooperate Check
- (void)getNodeCooperateCheckDataWithURL:(NSString *)URL
                                  nodeId:(NSString *)nodeId
                                  copies:(NSString *)copies
                                 success:(void (^)(id responseObject))success
                                 failure:(void (^)(NSError *error))failure
{
    [MBProgressHUD showActivityMessageInWindow:Localized(@"DataChecking")];
    NSString * url = SERVER_COMBINE_API(_webServerDomain, URL);
    NSString * body = [NSString stringWithFormat:@"nodeId=%@&hash=%@&copies=%@&initiatorAddress=%@", nodeId, _hash, copies, CurrentWalletAddress];
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
#pragma mark - Voucher
// voucher list
- (void)getVoucherListDataWithPageIndex:(NSInteger)pageIndex
                                success:(void (^)(id responseObject))success
                                failure:(void (^)(NSError *error))failure
{
    NSString * url = SERVER_COMBINE_API(_webServerDomain, Voucher_List);
    NSMutableDictionary * parameters = [NSMutableDictionary dictionary];
    [parameters addEntriesFromDictionary:@{@"address" : CurrentWalletAddress,
                                           @"pageStart" : @(pageIndex),
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
// voucher detail
- (void)getVoucherDetailDataWithVoucherId:(NSString *)voucherId
                                trancheId:(NSString *)trancheId
                                    spuId:(NSString *)spuId
                          contractAddress:(NSString *)contractAddress
                                  success:(void (^)(id responseObject))success
                                  failure:(void (^)(NSError *error))failure
{
    [MBProgressHUD showActivityMessageInWindow:Localized(@"Loading")];
    NSString * url = SERVER_COMBINE_API(_webServerDomain, Voucher_Detail);
    NSMutableDictionary * parameters = [NSMutableDictionary dictionary];
    [parameters addEntriesFromDictionary:@{
                                           @"address" : CurrentWalletAddress,
                                           @"voucherId" : voucherId,
                                           @"trancheId" : trancheId,
                                           @"spuId": spuId,
                                           @"contractAddress" : contractAddress
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
        amount = [[balance decimalNumberBySubtracting:minLimitationNumber] decimalNumberBySubtracting: costNumber];
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
    AccountService * accountService = [[[SDK sharedInstance] setUrl:_bumoNodeUrl] getAccountService];
    AccountGetInfoRequest *request = [AccountGetInfoRequest new];
    [request setAddress : address];
    AccountGetInfoResponse *response = [accountService getInfo : request];
    if (response.errorCode == 0) {
        return TransactionCost_MIN;
    } else if (response.errorCode == 4) {
        return TransactionCost_NotActive_MIN;
    } else {
        return TransactionCost_MIN;
    }
}
// vouther Balace
- (int64_t)getVoutherBalanceWithDposModel:(DposModel *)dposModel {
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD showActivityMessageInWindow:Localized(@"Loading")];
    });
    ContractService * service = [[[SDK sharedInstance] setUrl: _bumoNodeUrl] getContractService];
    int64_t fee = [[[NSDecimalNumber decimalNumberWithString:dposModel.tx_fee] decimalNumberByMultiplyingByPowerOf10: Decimals_BU] longLongValue];
    ContractCallRequest * request = [ContractCallRequest new];
    [request setSourceAddress:CurrentWalletAddress];
    [request setContractAddress:dposModel.dest_address];
    [request setInput:dposModel.input];
    [request setOptType:2]; // query接口
    [request setFeeLimit:fee];
    [request setGasPrice:gasPrice];
    ContractCallResponse * response = [service call:request];
    if (response.errorCode == Success_Code) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUD];
        });
        if (response.result.queryRets.count > 0) {
            NSDictionary * result = [[response.result.queryRets firstObject] objectForKey:@"result"];
            NSDictionary * error = [[response.result.queryRets firstObject] objectForKey:@"error"];
            if (result) {
                NSString * str = [JsonTool dictionaryOrArrayWithJSONSString:result[@"value"]][@"available"];
                return [str longLongValue];
            } else if (error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSString * message = [JsonTool dictionaryOrArrayWithJSONSString:error[@"data"][@"exception"]][@"msg"];
                    [MBProgressHUD showTipMessageInWindow:message];
                });
                return 0;
            }
            return 0;
        }
        return 0;
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUD];
            [MBProgressHUD showTipMessageInWindow:[ErrorTypeTool getDescription:response.errorCode]];
        });
        return 0;
    }
}
#pragma mark - account data
- (void)setAccountDataWithRandom:(NSData *)random
                        password:(NSString *)password
                            name:(NSString *)name
                 accountDataType:(AccountDataType)accountDataType
                         success:(void (^)(id responseObject))success
                         failure:(void (^)(NSError *error))failure
{
    [MBProgressHUD showActivityMessageInWindow:Localized(@"Loading")];
    NSOperationQueue * queue = [[NSOperationQueue alloc] init];
    [queue addOperationWithBlock:^{
        // Random number -> mnemonic
        NSArray * words = [Mnemonic generateMnemonicCode: [random copy]];
        NSArray * privateKeys = [Mnemonic generatePrivateKeys: words : HDPaths];
        NSString * randomKey = [NSString generateKeyStoreWithPW:password randomKey:random];
        // private key -> address
        NSString * identityAddress = [Keypair getEncAddress : [Keypair getEncPublicKey: [privateKeys firstObject]]];
        NSString * identityKeyStore = [NSString generateKeyStoreWithPW:password key:[privateKeys firstObject]];
        NSString * walletAddress = [Keypair getEncAddress : [Keypair getEncPublicKey: [privateKeys lastObject]]];
        NSString * walletKeyStore = [NSString generateKeyStoreWithPW:password key:[privateKeys lastObject]];
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            if (randomKey == nil || identityKeyStore == nil || walletKeyStore == nil) {
                [MBProgressHUD hideHUD];
                if (accountDataType == AccountDataCreateID) {
//                    [MBProgressHUD showTipMessageInWindow:Localized(@"CreateIdentityFailure")];
                    [Encapsulation showAlertControllerWithErrorMessage:Localized(@"CreateIdentityFailure") handler:nil];
                } else if (accountDataType == AccountDataCreateWallet) {
                    //                    [MBProgressHUD showTipMessageInWindow:Localized(@"MnemonicIsIncorrect")];
                    [Encapsulation showAlertControllerWithErrorMessage:Localized(@"CreateWalletFailure") handler:nil];
                } else if (accountDataType == AccountDataRecoveryID) {
//                    [MBProgressHUD showTipMessageInWindow:Localized(@"MnemonicIsIncorrect")];
                    [Encapsulation showAlertControllerWithErrorMessage:Localized(@"MnemonicIsIncorrect") handler:nil];
                } else if (accountDataType == AccountDataSafe) {
//                    [MBProgressHUD showTipMessageInWindow:Localized(@"PasswordIsIncorrect")];
                    [Encapsulation showAlertControllerWithErrorMessage:Localized(@"PasswordIsIncorrect") handler:nil];
                }
            } else {
                [MBProgressHUD hideHUD];
                if(success != nil)
                {
                    if (accountDataType == AccountDataCreateWallet) {
                        [self setWalletDataWalletName:name walletAddress:walletAddress walletKeyStore:walletKeyStore randomNumber:randomKey];
                    } else {
                        AccountModel * account = [[AccountModel alloc] init];
                        account.identityName = name;
                        account.randomNumber = randomKey;
                        account.identityAddress = identityAddress;
                        account.identityKeyStore = identityKeyStore;
                        account.walletName = Current_WalletName;
                        NSInteger index = RandomNumber(0, 9);
                        NSString * walletIconName = (index == 0) ? Current_Wallet_IconName : [NSString stringWithFormat:@"%@_%zd", Current_Wallet_IconName, index];
                        account.walletIconName = walletIconName;
                        account.walletAddress = walletAddress;
                        account.walletKeyStore = walletKeyStore;
                        [[AccountTool shareTool] save:account];
                        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
                        [defaults setObject:walletAddress forKey:Current_WalletAddress];
                        [defaults setObject:walletKeyStore forKey:Current_WalletKeyStore];
                        [defaults setObject:Current_WalletName forKey:Current_WalletName];
                        [defaults setObject:walletIconName forKey:Current_Wallet_IconName];
                        [defaults synchronize];
                    }
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
    NSOperationQueue * queue = [[NSOperationQueue alloc] init];
    [queue addOperationWithBlock:^{
        // Random number -> mnemonic
        NSArray * privateKeys = [Mnemonic generatePrivateKeys: mnemonics : HDPaths];
        // private key -> address
        NSString * walletAddress = [Keypair getEncAddress : [Keypair getEncPublicKey: [privateKeys lastObject]]];
        NSString * walletKeyStore = [NSString generateKeyStoreWithPW:password key:[privateKeys lastObject]];
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            if (privateKeys == nil || walletKeyStore == nil) {
                [MBProgressHUD hideHUD];
                [Encapsulation showAlertControllerWithErrorMessage:Localized(@"MnemonicIsIncorrect") handler:nil];
//                [MBProgressHUD showTipMessageInWindow:Localized(@"FailureToImportWallet")];
            } else {
                [MBProgressHUD hideHUD];
                if(success != nil)
                {
                    NSData * random = [Mnemonic randomFromMnemonicCode: mnemonics];
                    NSString * randomKey = [NSString generateKeyStoreWithPW:password randomKey:random];
                    BOOL ifImportSuccess = [self setWalletDataWalletName:walletName walletAddress:walletAddress walletKeyStore:walletKeyStore randomNumber:randomKey];
                    if (ifImportSuccess) {
                        success(walletAddress);
                    }
                }
            }
        }];
    }];
}

- (BOOL)setWalletDataWalletName:(NSString *)walletName
                  walletAddress:(NSString *)walletAddress
                 walletKeyStore:(NSString *)walletKeyStore
                   randomNumber:(NSString *)randomNumber
{
    BOOL success = YES;
    if ([walletAddress isEqualToString:[[[AccountTool shareTool] account] walletAddress]]) {
        [MBProgressHUD showTipMessageInWindow:Localized(@"WalletDuplicateImport")];
        success = NO;
    }
    NSArray * importedWalletArray = [[WalletTool shareTool] walletArray];
    for (WalletModel * walletModel in importedWalletArray) {
        if ([walletModel.walletAddress isEqualToString:walletAddress]) {
            [MBProgressHUD showTipMessageInWindow:Localized(@"WalletDuplicateImport")];
            success = NO;
        }
    }
    if (success == YES) {
        NSMutableArray * importedWallet = [NSMutableArray array];
        [importedWallet addObjectsFromArray:importedWalletArray];
        WalletModel * walletModel = [[WalletModel alloc] init];
        walletModel.walletName = walletName;
        NSInteger index = RandomNumber(0, 9);
        NSString * walletIconName = (index == 0) ? Current_Wallet_IconName : [NSString stringWithFormat:@"%@_%zd", Current_Wallet_IconName, index];
        walletModel.walletIconName = walletIconName;
        walletModel.walletAddress = walletAddress;
        walletModel.walletKeyStore = walletKeyStore;
        walletModel.randomNumber = randomNumber;
        [importedWallet addObject:walletModel];
        [[WalletTool shareTool] save:importedWallet];
    }
    return success;
}
- (void)modifyPasswordWithOldPW:(NSString *)oldPW
                             PW:(NSString *)PW
                    walletModel:(WalletModel *)walletModel
                        success:(void (^)(id responseObject))success
{
    [MBProgressHUD showActivityMessageInWindow:Localized(@"Loading")];
    NSString * walletPrivateKey = [NSString decipherKeyStoreWithPW:oldPW keyStoreValueStr:walletModel.walletKeyStore];
    if ([Tools isEmpty:walletPrivateKey]) {
        [MBProgressHUD hideHUD];
        [Encapsulation showAlertControllerWithMessage:Localized(@"OldPWFormat") handler:nil];
        return;
    }
    NSString * walletKeyStore = [NSString generateKeyStoreWithPW:PW key:walletPrivateKey];
    if (walletKeyStore == nil) {
        [MBProgressHUD hideHUD];
        [Encapsulation showAlertControllerWithMessage:Localized(@"OldPWFormat") handler:nil];
        return;
    }
    NSString * randomKey;
    if (NotNULLString(walletModel.randomNumber)) {
        NSData * random = [NSString decipherKeyStoreWithPW:oldPW randomKeyStoreValueStr:walletModel.randomNumber];
        if (random == nil) {
            [MBProgressHUD hideHUD];
            [Encapsulation showAlertControllerWithMessage:Localized(@"OldPWFormat") handler:nil];
            return;
        }
        randomKey = [NSString generateKeyStoreWithPW:PW randomKey:random];
        if (randomKey == nil) {
            [MBProgressHUD hideHUD];
            [Encapsulation showAlertControllerWithMessage:Localized(@"OldPWFormat") handler:nil];
            return;
        }
    }
    WalletModel * mode = walletModel;
    mode.randomNumber = randomKey;
    mode.walletKeyStore = walletKeyStore;
    if(success != nil)
    {
        [MBProgressHUD hideHUD];
        success(mode);
    }
}
#pragma mark - 转账
// Transfer accounts
- (BOOL)setTransferDataWithTokenType:(NSInteger)tokenType
                         destAddress:(NSString *)destAddress
                              assets:(NSString *)assets
                            decimals:(NSInteger)decimals
                            feeLimit:(NSString *)feeLimit
                               notes:(NSString *)notes
                                code:(NSString *)code
                              issuer:(NSString *)issuer
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD showActivityMessageInWindow:Localized(@"Loading")];
    });
    // Build BUSendOperation
    NSString * sourceAddress = CurrentWalletAddress;
    int64_t fee = [[[NSDecimalNumber decimalNumberWithString:feeLimit] decimalNumberByMultiplyingByPowerOf10: Decimals_BU] longLongValue];
    NSMutableArray * operations = [NSMutableArray array];
    int64_t nonce = [[HTTPManager shareManager] getAccountNonce: sourceAddress] + 1;
    if (nonce == 0) return NO;
    if (tokenType == Token_Type_BU) {
        // BU
        int64_t amount = [[[NSDecimalNumber decimalNumberWithString:assets] decimalNumberByMultiplyingByPowerOf10: Decimals_BU] longLongValue];
        BUSendOperation *operation = [BUSendOperation new];
        [operation setSourceAddress: sourceAddress];
        [operation setDestAddress: destAddress];
        [operation setAmount: amount];
        [operations addObject:operation];
    } else {
        // Other currencies
        int64_t amount = [[[NSDecimalNumber decimalNumberWithString:assets] decimalNumberByMultiplyingByPowerOf10: decimals] longLongValue];
        if ([[self getAccountInfoWithAddress: destAddress] isEqualToString:TransactionCost_NotActive_MIN]) {
            AccountActivateOperation *activateOperation = [self AccountActivateWithAddress:destAddress];
            [operations addObject: activateOperation];
        }
        AssetSendOperation *operation = [AssetSendOperation new];
        [operation setSourceAddress: sourceAddress];
        [operation setDestAddress: destAddress];
        [operation setCode: code];
        [operation setIssuer: issuer];
        [operation setAmount: amount];
        [operations addObject: operation];
    }
    return [[HTTPManager shareManager] getHashWithSourceAddress:sourceAddress nonce:nonce gasPrice:gasPrice feeLimit:fee operations:operations notes:notes];
}
- (AccountActivateOperation *)AccountActivateWithAddress:(NSString *)address
{
    AccountActivateOperation * activateOperation = [AccountActivateOperation new];
    [activateOperation setSourceAddress: CurrentWalletAddress];
    [activateOperation setDestAddress: address];
    int64_t initBalance = [[[NSDecimalNumber decimalNumberWithString:ActivateInitBalance] decimalNumberByMultiplyingByPowerOf10: Decimals_BU] longLongValue];
    [activateOperation setInitBalance: initBalance];
    return activateOperation;
}
// register
- (BOOL)getRegisteredDataWithRegisteredModel:(RegisteredModel *)registeredModel
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD showActivityMessageInWindow:Localized(@"Loading")];
    });
    NSString * sourceAddress = CurrentWalletAddress;
    int64_t nonce = [[HTTPManager shareManager] getAccountNonce: CurrentWalletAddress] + 1;
    if (nonce == 0) return NO;
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
    int64_t feeLimit = [[[NSDecimalNumber decimalNumberWithString:Registered_Cost] decimalNumberByMultiplyingByPowerOf10: Decimals_BU] longLongValue];
    NSMutableArray * operations = [NSMutableArray array];
    [operations addObject:operation];
    return [[HTTPManager shareManager] getHashWithSourceAddress:sourceAddress nonce:nonce gasPrice:gasPrice feeLimit:feeLimit operations:operations notes:nil];
}
// Issue
- (BOOL)getIssueAssetDataWithAssetCode:(NSString *)assetCode
                            assetAmount:(int64_t)assetAmount
                               decimals:(NSInteger)decimals
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD showActivityMessageInWindow:Localized(@"Loading")];
    });
    NSString * sourceAddress = CurrentWalletAddress;
    int64_t nonce = [[HTTPManager shareManager] getAccountNonce: CurrentWalletAddress] + 1;
    if (nonce == 0) return NO;
    // Asset amount
    AssetIssueOperation *operation = [AssetIssueOperation new];
    [operation setSourceAddress: sourceAddress];
    [operation setCode: assetCode];
    [operation setAmount: assetAmount];
    int64_t feeLimit = [[[NSDecimalNumber decimalNumberWithString:Distribution_Cost] decimalNumberByMultiplyingByPowerOf10: Decimals_BU] longLongValue];
    NSMutableArray * operations = [NSMutableArray array];
    [operations addObject:operation];
    return [[HTTPManager shareManager] getHashWithSourceAddress:sourceAddress nonce:nonce gasPrice:gasPrice feeLimit:feeLimit operations:operations notes:nil];
}

#pragma mark - Nonce
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
#pragma mark - hash
- (BOOL)getHashWithSourceAddress:(NSString *)sourceAddress
                           nonce:(int64_t)nonce
                        gasPrice:(int64_t)gasPrice
                        feeLimit:(int64_t)feeLimit
                      operations:(NSMutableArray<BaseOperation *> *)operations
                           notes:(NSString *) notes
{
    TransactionBuildBlobRequest *buildBlobRequest = [TransactionBuildBlobRequest new];
    [buildBlobRequest setSourceAddress : sourceAddress];
    [buildBlobRequest setNonce : nonce];
    [buildBlobRequest setGasPrice : gasPrice];
    [buildBlobRequest setFeeLimit : feeLimit];
    [buildBlobRequest setOperations: operations];
    [buildBlobRequest setMetadata: notes];
    
    // Serialization transaction
    _transactionService = [[[SDK sharedInstance] setUrl:_bumoNodeUrl] getTransactionService];
    _buildBlobResponse = [_transactionService buildBlob : buildBlobRequest];
    if (_buildBlobResponse.errorCode == Success_Code) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUD];
        });
        _hash = _buildBlobResponse.result.transactionHash;
        return YES;
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUD];
            [MBProgressHUD showTipMessageInWindow:[ErrorTypeTool getDescription:self->_buildBlobResponse.errorCode]];
        });
        return NO;
    }
}
#pragma mark - sign
- (BOOL)getSignWithPrivateKey:(NSString *)privateKey
{
    TransactionSignRequest *signRequest = [TransactionSignRequest new];
    [signRequest setBlob : _buildBlobResponse.result.transactionBlob];
    [signRequest addPrivateKey : privateKey];
    _signResponse = [_transactionService sign : signRequest];
    if (_signResponse.errorCode == Success_Code) {
        return YES;
    } else {
        [MBProgressHUD showTipMessageInWindow:[ErrorTypeTool getDescription:_signResponse.errorCode]];
        return NO;
    }
}
#pragma mark - Submit transaction
- (BOOL)submitTransaction
{
    [MBProgressHUD showActivityMessageInWindow:Localized(@"InProcessing")];
    // Submission of transactions
    TransactionSubmitRequest *submitRequest = [TransactionSubmitRequest new];
    [submitRequest setTransactionBlob : _buildBlobResponse.result.transactionBlob];
    [submitRequest setSignatures : [_signResponse.result.signatures copy]];
    TransactionSubmitResponse *submitResponse = [_transactionService submit : submitRequest];
    if (submitResponse.errorCode == Success_Code) {
        [MBProgressHUD hideHUD];
        return YES;
    } else {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showTipMessageInWindow:[ErrorTypeTool getDescription:submitResponse.errorCode]];
        return NO;
    }
}
#pragma mark 提交交易
- (void)submitTransactionWithSuccess:(void (^)(TransactionResultModel * resultModel))success
                             failure:(void (^)(TransactionResultModel * resultModel))failure
{
    if (![[HTTPManager shareManager] submitTransaction]) return;
    [[HTTPManager shareManager] getTransactionStatusSuccess:success failure:failure];
}


// Judge whether the transfer / registration / issuance is successful.
- (void)getTransactionStatusSuccess:(void (^)(TransactionResultModel * resultModel))success
                         failure:(void (^)(TransactionResultModel * resultModel))failure
{
    [MBProgressHUD showActivityMessageInWindow:Localized(@"InProcessing")];
    __block TransactionGetInfoResponse *response = [TransactionGetInfoResponse new];
    __block TransactionResultModel * resultModel = [[TransactionResultModel alloc] init];
    resultModel.transactionHash = _hash;
    __block NSInteger state = 0;
    dispatch_queue_t queue = dispatch_get_main_queue();
    __block dispatch_source_t gcdTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    uint64_t interval = (uint64_t)(1 * NSEC_PER_SEC);
    dispatch_source_set_timer(gcdTimer, DISPATCH_TIME_NOW, interval, 0);
    dispatch_source_set_event_handler(gcdTimer, ^{
        DLog(@"循环次数：%zd", state);
        if (state == Maximum_Number) {
            DLog(@"请求超时");
            dispatch_cancel(gcdTimer);
            gcdTimer = nil;
            [MBProgressHUD hideHUD];
            if(failure != nil)
            {
                resultModel.errorCode = response.errorCode;
                failure(resultModel);
            }
        } else {
            TransactionGetInfoRequest *request = [TransactionGetInfoRequest new];
            [request setHash: self->_hash];
            TransactionService *service = [[[SDK sharedInstance] setUrl: _bumoNodeUrl] getTransactionService];
            response = [service getInfo: request];
            if (response.errorCode == Success_Code) {
                DLog(@"请求成功");
                dispatch_cancel(gcdTimer);
                gcdTimer = nil;
            } else {
                DLog(@"请求失败");
                state ++;
            }
            if(response.result.transactions != nil && success != nil)
            {
                DLog(@"请求超时（成功或失败）");
                [MBProgressHUD hideHUD];
                TransactionHistory * history = response.result.transactions[0];
                resultModel.transactionTime = history.closeTime;
                resultModel.transactionHash = history.transactionHash;
                resultModel.actualFee = [[[NSDecimalNumber decimalNumberWithString:history.actualFee] decimalNumberByMultiplyingByPowerOf10: -Decimals_BU] stringValue];
                resultModel.errorCode = history.errorCode;
                resultModel.errorDesc = history.errorDesc;
                success(resultModel);
            }
        }
    });
    dispatch_resume(gcdTimer);
}

#pragma mark - 调用底层合约
- (BOOL)getTransactionWithDposModel:(DposModel *)dposModel isDonateVoucher:(BOOL)isDonateVoucher
{
    // Build BUSendOperation
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD showActivityMessageInWindow:Localized(@"Loading")];
    });
    NSString * sourceAddress = CurrentWalletAddress;
    NSString * notes = (NotNULLString(dposModel.notes)) ? dposModel.notes : Localized(@"DposContract");
    int64_t fee = [[[NSDecimalNumber decimalNumberWithString:dposModel.tx_fee] decimalNumberByMultiplyingByPowerOf10: Decimals_BU] longLongValue];
    int64_t nonce = [[HTTPManager shareManager] getAccountNonce: sourceAddress] + 1;
    if (nonce == 0) return NO;
    NSMutableArray * operations = [NSMutableArray array];
    int64_t amount = [[[NSDecimalNumber decimalNumberWithString:dposModel.amount] decimalNumberByMultiplyingByPowerOf10: Decimals_BU] longLongValue];
    
    if (isDonateVoucher && [[self getAccountInfoWithAddress: dposModel.to_address] isEqualToString:TransactionCost_NotActive_MIN]) {
        AccountActivateOperation *activateOperation = [self AccountActivateWithAddress:dposModel.to_address];
        [operations addObject: activateOperation];
    }
    ContractInvokeByBUOperation *operation = [ContractInvokeByBUOperation new];
    [operation setSourceAddress: sourceAddress];
    [operation setContractAddress: dposModel.dest_address];
    [operation setAmount: amount];
    [operation setInput:dposModel.input];
    [operation setMetadata:notes];
    [operations addObject:operation];
    return [[HTTPManager shareManager] getHashWithSourceAddress:sourceAddress nonce:nonce gasPrice:gasPrice feeLimit:fee operations:operations notes:notes];
}



@end
