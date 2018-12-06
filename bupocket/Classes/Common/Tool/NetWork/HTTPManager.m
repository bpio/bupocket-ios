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
//    [[HUDHelper sharedInstance] syncLoading];
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
//            [[HUDHelper sharedInstance] syncStopLoadingMessage:Localized(@"NoNetWork")];
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
    NSDictionary * parmenters = @{@"address": address,
                                  @"currencyType": currencyType,
                                  @"tokenList": tokenList
                                  };
    [[HttpTool shareTool] POST:url parameters:parmenters success:^(id responseObject) {
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
    NSDictionary * parmenters = @{@"address": [[AccountTool account] purseAccount],
                                  @"assetCode" : assetCode,
                                  @"startPage" : @(pageIndex),
                                  @"pageSize" : @(PageSize_Max)};
    [[HttpTool shareTool] POST:url parameters:parmenters success:^(id responseObject) {
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
//- (void)getAssetsDetailDataWithTokenType:(NSInteger)tokenType
//                               assetCode:(NSString *)assetCode
//                                  issuer:(NSString *)issuer
//                                 address:(NSString *)address
//                            currencyType:(NSString *)currencyType
//                               pageIndex:(NSInteger)pageIndex
//                                 success:(void (^)(id responseObject))success
//                                 failure:(void (^)(NSError *error))failure
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
    NSMutableDictionary * parmenters = [NSMutableDictionary dictionary];
    [parmenters addEntriesFromDictionary:@{@"tokenType" : @(tokenType),
                                           @"currencyType": currencyType,
                                           @"assetCode" : assetCode,
                                           @"issuer" : issuer,
                                           @"address" : address,
                                           @"startPage" : @(pageIndex),
                                           @"pageSize" : @(PageSize_Max)
                                           }];
    /*
    NSString * url;
    NSMutableDictionary * parmenters = [NSMutableDictionary dictionary];
    [parmenters addEntriesFromDictionary:@{@"startPage" : @(pageIndex),
                                           @"pageSize" : @(PageSize_Max),
                                           @"currencyType": currencyType
                                           }];
    if (tokenType == Token_Type_BU) {
        url = SERVER_COMBINE_API(_webServerDomain, Transaction_Record_BU);
        [parmenters setObject:address forKey:@"walletAddress"];
    } else {
        url = SERVER_COMBINE_API(_webServerDomain, Transaction_Record);
        [parmenters addEntriesFromDictionary:@{@"assetCode" : assetCode,
                                               @"issuer" : issuer,
                                               @"address" : address,
                                               }];
        //        [[HUDHelper sharedInstance] syncLoading];
    }
     */
    [[HttpTool shareTool] POST:url parameters:parmenters success:^(id responseObject) {
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
// OrderDetails
- (void)getOrderDetailsDataWithAddress:(NSString *)address
                                 optNo:(NSInteger)optNo
                               success:(void (^)(id responseObject))success
                               failure:(void (^)(NSError *error))failure
{
    NSString * url = SERVER_COMBINE_API(_webServerDomain, Order_Details);
    NSDictionary * parmenters = @{
                                  @"address" : address,
                                  @"optNo": @(optNo)
                                  };
//    [[HUDHelper sharedInstance] syncLoading];
    [[HttpTool shareTool] POST:url parameters:parmenters success:^(id responseObject) {
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
    [[HUDHelper sharedInstance] syncLoading];
    NSString * url = SERVER_COMBINE_API(_webServerDomain, Transaction_Details);
    NSDictionary * parmenters = @{@"Hash" : hash};
    [[HttpTool shareTool] POST:url parameters:parmenters success:^(id responseObject) {
        if(success != nil)
        {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        if(failure != nil)
        {
            failure(error);
            [[HUDHelper sharedInstance] syncStopLoadingMessage:Localized(@"NoNetWork")];
        }
    }];
}

// Registration / issuance of assets information
- (void)getRegisteredORDistributionDataWithAssetCode:(NSString *)assetCode
                                        issueAddress:(NSString *)issueAddress
                                             success:(void (^)(id responseObject))success
                                             failure:(void (^)(NSError *error))failure
{
    [[HUDHelper sharedInstance] syncLoading];
    NSString * url = SERVER_COMBINE_API(_webServerDomain, Registered_And_Distribution);
    NSDictionary * parmenters = @{
                                  @"assetCode": assetCode,
                                  @"issueAddress": issueAddress
                                  };
    [[HttpTool shareTool] POST:url parameters:parmenters success:^(id responseObject) {
        if(success != nil)
        {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        if(failure != nil)
        {
            failure(error);
            [[HUDHelper sharedInstance] syncStopLoadingMessage:Localized(@"NoNetWork")];
        }
    }];
}
// Feedback
- (void)getFeedbackDataWithContent:(NSString *)content
                           contact:(NSString *)contact
                           success:(void (^)(id responseObject))success
                           failure:(void (^)(NSError *error))failure
{
    [[HUDHelper sharedInstance] syncLoading];
    NSString * url = SERVER_COMBINE_API(_webServerDomain, Help_And_Feedback);
    NSDictionary * parmenters = @{
                                  @"content": content,
                                  @"contact": contact
                                  };
    [[HttpTool shareTool] POST:url parameters:parmenters success:^(id responseObject) {
        if(success != nil)
        {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        if(failure != nil)
        {
            failure(error);
            [[HUDHelper sharedInstance] syncStopLoadingMessage:Localized(@"NoNetWork")];
        }
    }];
}
#pragma mark - SDK
// Check the balance
- (int64_t)getAccountBalance {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[HUDHelper sharedInstance] syncLoading];
    });
    AccountService *accountService = [[[SDK sharedInstance] setUrl:_bumoNodeUrl] getAccountService];
    AccountGetBalanceRequest * request = [AccountGetBalanceRequest new];
    [request setAddress : [AccountTool account].purseAccount];
    AccountGetBalanceResponse *response = [accountService getBalance : request];
    if (response.errorCode == Success_Code) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[HUDHelper sharedInstance] syncStopLoading];
        });
        return response.result.balance;
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[HUDHelper sharedInstance] syncStopLoadingMessage:[ErrorTypeTool getDescription:response.errorCode]];
        });
        return 0;
    }
}

// Query cost standard
// Obtain minimum asset limits and fuel unit prices for accounts in designated blocks
- (void)getBlockFees {
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [[HUDHelper sharedInstance] syncLoading];
//    });
    BlockGetFeesRequest *request = [BlockGetFeesRequest new];
    [request setBlockNumber: 617247];
    BlockService *service = [[[SDK sharedInstance] setUrl: _bumoNodeUrl] getBlockService];
    BlockGetFeesResponse *response = [service getFees: request];
    double minAssetLimit = 0.1;
    if (response.errorCode == Success_Code) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [[HUDHelper sharedInstance] syncStopLoading];
//        });
        minAssetLimit = [Tools MO2BU:response.result.fees.baseReserve];
    } else {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [[HUDHelper sharedInstance] syncStopLoading];
//            [[HUDHelper sharedInstance] syncStopLoadingMessage:[ErrorTypeTool getDescription:response.errorCode]];
//        });
    }
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@(minAssetLimit) forKey:Minimum_Asset_Limitation];
    [defaults synchronize];
}
// Balance judgment
- (CGFloat)getDataWithBalanceJudgmentWithCost:(double)cost ifShowLoading:(BOOL)ifShowLoading
{
    if (ifShowLoading == YES) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[HUDHelper sharedInstance] syncLoading];
        });
    }
    double balance = 0;
    double baseReserve = [[[NSUserDefaults standardUserDefaults] objectForKey:Minimum_Asset_Limitation] doubleValue];
    AccountService *accountService = [[[SDK sharedInstance] setUrl:_bumoNodeUrl] getAccountService];
    AccountGetBalanceRequest * request = [AccountGetBalanceRequest new];
    [request setAddress : [AccountTool account].purseAccount];
    AccountGetBalanceResponse *response = [accountService getBalance : request];
    if (response.errorCode == Success_Code) {
        balance = [Tools MO2BU:response.result.balance];
    } else {
        if (ifShowLoading == YES) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[HUDHelper sharedInstance] syncStopLoading];
//                [[HUDHelper sharedInstance] syncStopLoadingMessage:[ErrorTypeTool getDescription:response.errorCode]];
            });
        }
//        [MBProgressHUD showErrorMessage:response.errorDesc];
    }
    CGFloat amount = balance - baseReserve - cost;
//    if (amount < 0) {
//        amount = 0;
//    }
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
        dispatch_async(dispatch_get_main_queue(), ^{
            [[HUDHelper sharedInstance] syncStopLoadingMessage:[ErrorTypeTool getDescription:response.errorCode]];
        });
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
        //        NSLog(@"%@", [response.result yy_modelToJSONString]);
        return [NSString stringWithFormat:@"%.2f", TransactionCost_MIN];
    } else if (response.errorCode == 4) {
        return [NSString stringWithFormat:@"%.2f", TransactionCost_NotActive_MIN];
    } else {
        return nil;
    }
}

// identity data
- (void)setAccountDataWithRandom:(NSData *)random
                        password:(NSString *)password
                    identityName:(NSString *)identityName
                         success:(void (^)(id responseObject))success
                         failure:(void (^)(NSError *error))failure
{
    [[HUDHelper sharedInstance] syncLoading];
    // Random number -> mnemonic
    NSArray * words = [Mnemonic generateMnemonicCode: [random copy]];
    NSMutableArray * hdPaths = [NSMutableArray arrayWithObjects:@"M/44H/526H/0H/0/0", @"M/44H/526H/1H/0/0", nil];
    NSArray *privateKeys = [Mnemonic generatePrivateKeys: words : hdPaths];
    NSString * randomKey = [NSString generateKeyStoreWithPW:password randomKey:random];
    // private key -> address
    NSString * identityAddress = [Keypair getEncAddress : [Keypair getEncPublicKey: [privateKeys firstObject]]];
    NSString * identityKey = [NSString generateKeyStoreWithPW:password key:[privateKeys firstObject]];
    NSString * purseAddress = [Keypair getEncAddress : [Keypair getEncPublicKey: [privateKeys lastObject]]];
    NSString * purseKey = [NSString generateKeyStoreWithPW:password key:[privateKeys lastObject]];
    if (randomKey == nil) {
        [[HUDHelper sharedInstance] syncStopLoadingMessage:Localized(@"RandomGenerationFailure")];
    } else if (identityKey == nil) {
        [[HUDHelper sharedInstance] syncStopLoadingMessage:@"IdentityFailure"];
    } else if (purseKey == nil) {
        [[HUDHelper sharedInstance] syncStopLoadingMessage:Localized(@"WalletAccountFailure")];
    } else {
        [[HUDHelper sharedInstance] syncStopLoading];
        if(success != nil)
        {
            AccountModel * account = [[AccountModel alloc] init];
            account.identityName = identityName;
            account.randomNumber = randomKey;
            account.identityAccount = identityAddress;
            account.purseAccount = purseAddress;
            account.identityKey = identityKey;
            account.purseKey = purseKey;
            [AccountTool save:account];
            success(words);
        }
    }
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
    NSString * sourceAddress = [AccountTool account].purseAccount;
    NSString * privateKey = [NSString decipherKeyStoreWithPW:password keyStoreValueStr:[AccountTool account].purseKey];
    if ([Tools isEmpty:privateKey]) {
        [[HUDHelper sharedInstance] syncStopLoadingMessage:Localized(@"PasswordIsIncorrect")];
        return;
    }
    int64_t fee = [[[NSDecimalNumber decimalNumberWithString:feeLimit] decimalNumberByMultiplyingByPowerOf10: Decimals_BU] integerValue];
    int64_t nonce = [[HTTPManager shareManager] getAccountNonce: sourceAddress] + 1;
    if (nonce == 0) return;
    NSString * hash;
    if (tokenType == Token_Type_BU) {
        // BU
        int64_t amount = [[[NSDecimalNumber decimalNumberWithString:assets] decimalNumberByMultiplyingByPowerOf10: Decimals_BU] integerValue];
        BUSendOperation *operation = [BUSendOperation new];
        [operation setSourceAddress: sourceAddress];
        [operation setDestAddress: destAddress];
        [operation setAmount: amount];
        hash = [[HTTPManager shareManager] buildBlobAndSignAndSubmit:privateKey :sourceAddress :nonce :gasPrice :fee :operation :notes];
    } else {
        // Other currencies
        NSInteger amount = [[[NSDecimalNumber decimalNumberWithString:assets] decimalNumberByMultiplyingByPowerOf10: decimals] integerValue];
//        int64_t amount = multiplierNumber * powl(10, decimals);
        AssetSendOperation *operation = [AssetSendOperation new];
        [operation setSourceAddress: sourceAddress];
        [operation setDestAddress: destAddress];
        [operation setCode: code];
        [operation setIssuer: issuer];
        [operation setAmount: amount];
        hash = [[HTTPManager shareManager] buildBlobAndSignAndSubmit:privateKey :sourceAddress :nonce :gasPrice :fee :operation :notes];
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
    NSString * sourceAddress = [AccountTool account].purseAccount;
    NSString *key = [NSString stringWithFormat: @"asset_property_%@", registeredModel.code];
    AtpProperty * atpProperty = [[AtpProperty alloc] init];
    int64_t total = registeredModel.amount * pow(10, registeredModel.decimals);
    if (registeredModel.amount != 0 && total < 1) {
        [[HUDHelper sharedInstance] syncStopLoadingMessage:Localized(@"IssueNumberIsIncorrect")];
        return;
    }
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
    NSString * privateKey = [NSString decipherKeyStoreWithPW:password keyStoreValueStr:[AccountTool account].purseKey];
    if ([Tools isEmpty:privateKey]) {
        [[HUDHelper sharedInstance] syncStopLoadingMessage:Localized(@"PasswordIsIncorrect")];
        return;
    }
    int64_t feeLimit = [Tools BU2MO: Registered_Cost];
    int64_t nonce = [[HTTPManager shareManager] getAccountNonce: sourceAddress] + 1;
    if (nonce == 0) return;
    NSString * hash = [[HTTPManager shareManager] buildBlobAndSignAndSubmit:privateKey :sourceAddress :nonce :gasPrice :feeLimit :operation :nil];
    if (![Tools isEmpty: hash]) {
        [[HTTPManager shareManager] getTransactionStatusHash:hash success:success failure:failure];
    }
}
// Issue
- (void)getIssueAssetDataWithPassword:(NSString *)password
                            assetCode:(NSString *)assetCode
                           assetAmount:(NSString *)assetAmount
                             decimals:(NSInteger)decimals
                              success:(void (^)(TransactionResultModel * resultModel))success
                              failure:(void (^)(TransactionResultModel * resultModel))failure
{
    NSString * sourceAddress = [AccountTool account].purseAccount;
    // Asset amount
    int64_t amount = [assetAmount longLongValue] * powl(10, decimals);
    if (amount < 1) {
        [[HUDHelper sharedInstance] syncStopLoadingMessage:Localized(@"IssueNumberIsIncorrect")];
        return;
    }
    AssetIssueOperation *operation = [AssetIssueOperation new];
    [operation setSourceAddress: sourceAddress];
    [operation setCode: assetCode];
    [operation setAmount: amount];
    NSString * privateKey = [NSString decipherKeyStoreWithPW:password keyStoreValueStr:[AccountTool account].purseKey];
    if ([Tools isEmpty:privateKey]) {
        [[HUDHelper sharedInstance] syncStopLoadingMessage:Localized(@"PasswordIsIncorrect")];
        return;
    }
    int64_t feeLimit = [Tools BU2MO: Distribution_Cost];
    int64_t nonce = [[HTTPManager shareManager] getAccountNonce: sourceAddress] + 1;
    if (nonce == 0) return;
    NSString * hash = [[HTTPManager shareManager] buildBlobAndSignAndSubmit:privateKey :sourceAddress :nonce :gasPrice :feeLimit :operation :nil];
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
        dispatch_async(dispatch_get_main_queue(), ^{
            [[HUDHelper sharedInstance] syncStopLoadingMessage:[ErrorTypeTool getDescription:response.errorCode]];
        });
    }
    return nonce;
}

- (NSString *) buildBlobAndSignAndSubmit : (NSString *) privateKey : (NSString *) sourceAddress : (int64_t) nonce : (int64_t) gasPrice : (int64_t) feeLimit : (BaseOperation *)operation : (NSString *) notes {
    TransactionBuildBlobRequest *buildBlobRequest = [TransactionBuildBlobRequest new];
    [buildBlobRequest setSourceAddress : sourceAddress];
    [buildBlobRequest setNonce : nonce];
    [buildBlobRequest setGasPrice : gasPrice];
    [buildBlobRequest setFeeLimit : feeLimit];
    [buildBlobRequest addOperation : operation];
    [buildBlobRequest setMetadata: notes];
    
    // Serialization transaction
    TransactionService *transactionServer = [[[SDK sharedInstance] setUrl:_bumoNodeUrl] getTransactionService];
    TransactionBuildBlobResponse *buildBlobResponse = [transactionServer buildBlob : buildBlobRequest];
    NSString *hash = nil;
    if (buildBlobResponse.errorCode == Success_Code) {
        hash = buildBlobResponse.result.transactionHash;
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[HUDHelper sharedInstance] syncStopLoadingMessage:[ErrorTypeTool getDescription:buildBlobResponse.errorCode]];
        });
        return nil;
    }
    
    // sign
    TransactionSignRequest *signRequest = [TransactionSignRequest new];
    [signRequest setBlob : buildBlobResponse.result.transactionBlob];
    [signRequest addPrivateKey : privateKey];
    TransactionSignResponse * signResponse = [transactionServer sign : signRequest];
    if (signResponse.errorCode == Success_Code) {
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[HUDHelper sharedInstance] syncStopLoadingMessage:[ErrorTypeTool getDescription:signResponse.errorCode]];
        });
        return nil;
    }
    // Submission of transactions
    TransactionSubmitRequest *submitRequest = [TransactionSubmitRequest new];
    [submitRequest setTransactionBlob : buildBlobResponse.result.transactionBlob];
    [submitRequest setSignatures : [signResponse.result.signatures copy]];
    TransactionSubmitResponse *submitResponse = [transactionServer submit : submitRequest];
    if (submitResponse.errorCode == Success_Code) {
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[HUDHelper sharedInstance] syncStopLoadingMessage:[ErrorTypeTool getDescription:submitResponse.errorCode]];
        });
        return nil;
    }
    return hash;
}

// Judge whether the transfer / registration / issuance is successful.
- (void)getTransactionStatusHash:(NSString *)hash
                         success:(void (^)(TransactionResultModel * resultModel))success
                         failure:(void (^)(TransactionResultModel * resultModel))failure
{
    [[HUDHelper sharedInstance] syncLoading];
    __block TransactionGetInfoResponse *response = [TransactionGetInfoResponse new];
    __block TransactionResultModel * resultModel = [[TransactionResultModel alloc] init];
    resultModel.transactionHash = hash;
    __block NSInteger state = 0;
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    dispatch_group_async(group, queue, ^{
        for (int i = 0; i < Maximum_Number; i++) {
            dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
            TransactionGetInfoRequest *request = [TransactionGetInfoRequest new];
            [request setHash: hash];
            TransactionService *service = [[[SDK sharedInstance] setUrl: _bumoNodeUrl] getTransactionService];
            response = [service getInfo: request];
            if (response.errorCode == Success_Code) {
                dispatch_semaphore_signal(semaphore);
                break;
            } else {
                dispatch_semaphore_signal(semaphore);
                state ++;
            }
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        }
    });
    
    dispatch_group_notify(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (state == Maximum_Number) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[HUDHelper sharedInstance] syncStopLoading];
                if(failure != nil)
                {
                    resultModel.errorCode = response.errorCode;
                    resultModel.errorDesc = response.errorDesc;
                    failure(resultModel);
                }
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[HUDHelper sharedInstance] syncStopLoading];
                if(success != nil)
                {
                    TransactionHistory * history = response.result.transactions[0];
                    resultModel.transactionTime = history.closeTime;
                    resultModel.actualFee = history.actualFee;
                    resultModel.errorCode = history.errorCode;
                    resultModel.errorDesc = history.errorDesc;
                    success(resultModel);
                }
            });
        }
    });
}



@end
