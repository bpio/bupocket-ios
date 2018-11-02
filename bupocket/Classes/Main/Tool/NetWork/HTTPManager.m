//
//  HTTPManager.m
//  TheImperialPalaceMuseum
//
//  Created by 霍双双 on 17/2/25.
//  Copyright © 2017年 hss. All rights reserved.
//

#import "HTTPManager.h"
#import "HttpTool.h"
#import "AtpProperty.h"

//#import "Util.h"

@implementation HTTPManager

+ (HTTPManager *)shareManager
{
    __strong static HTTPManager * shareManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareManager = [[HTTPManager alloc]init];
    });
    return shareManager;
}

// 查询余额
+ (int64_t)getAccountBalance {
    AccountService *accountService = [[[SDK sharedInstance] setUrl:URL_SDK] getAccountService];
    AccountGetBalanceRequest * request = [AccountGetBalanceRequest new];
    [request setAddress : [AccountTool account].purseAccount];
    AccountGetBalanceResponse *response = [accountService getBalance : request];
    if (response.errorCode == 0) {
        return response.result.balance;
    } else {
        NSLog(@"%@", response.errorDesc);
        return 0;
    }
}

// 查询费用标准
+ (int64_t) getBlockFees {
    BlockGetFeesRequest *request = [BlockGetFeesRequest new];
    [request setBlockNumber: 617247];
    BlockService *service = [[[SDK sharedInstance] setUrl: URL_SDK] getBlockService];
    BlockGetFeesResponse *response = [service getFees: request];
    if (response.errorCode == 0) {
        return response.result.fees.baseReserve;
    } else {
        NSLog(@"error: %@", response.errorDesc);
        return 0;
    }
}


// Assets
+ (void)getAssetsDataWithAddress:(NSString *)address
                    currencyType:(NSString *)currencyType
                       tokenList:(NSArray *)tokenList
                         success:(void (^)(id responseObject))success
                         failure:(void (^)(NSError *error))failure
{
    NSString * url = SERVER_COMBINE_API(URLPREFIX, Assets_List);
    //HTTP请求体
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
    
    /*
    
    
    //请求体转换成字典
//    NSDictionary * parameters = [[HTTPManager shareManager] parametersWithHTTPBody:body];
//    NSError * error;
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:parmenters options:NSJSONWritingPrettyPrinted error:nil];
     NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    NSString * jsonString;
    if (jsonData && [jsonData length] > 0) {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    AFURLSessionManager * manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", nil];
    //创建请求request
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:url parameters:nil error:nil];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    // 转NSData作为HTTPBody
    [request setHTTPBody:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
    [[manager dataTaskWithRequest:request uploadProgress:^(NSProgress * _Nonnull uploadProgress) {
        
    } downloadProgress:^(NSProgress * _Nonnull downloadProgress) {
        
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (!error) {
            if (success) {
                success(responseObject);
            }
        } else {
            if (failure) {
                failure(error);
            }
        }
        
    }] resume];
     */
    
//    [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:0 timeoutInterval:30];
//
//    //设置请求方式为POST
//    request.HTTPMethod = @"POST";
//    //设置请求内容格式
////    [request setValue:@"application/json;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
//    request.HTTPBody = data;
//
//    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    manager.requestSerializer = [AFJSONRequestSerializer serializer];
//    [manager.requestSerializer setValue:@"application/json;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html",@"image/jpeg",@"text/plain", nil];
//    [manager.requestSerializer setTimeoutInterval:30.0];
//    NSURLSessionDataTask *dataTask =[manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
//        //8.解析数据
//        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
//        NSLog(@"%@",dict);
//
//    }];
//    //7.执行任务
//    [dataTask resume];
}
// AssetsDetail Transaction_Record
+ (void)getAssetsDetailDataWithAssetCode:(NSString *)assetCode
                                  issuer:(NSString *)issuer
                                 address:(NSString *)address
                               pageIndex:(NSInteger)pageIndex
                                 success:(void (^)(id responseObject))success
                                 failure:(void (^)(NSError *error))failure
{
    NSString * url;
    NSMutableDictionary * parmenters = [NSMutableDictionary dictionary];
    [parmenters addEntriesFromDictionary:@{@"startPage" : @(pageIndex),
                                           @"pageSize" : @(10)}];
    if ([assetCode isEqualToString:@"BU"]) {
        url = SERVER_COMBINE_API(URLPREFIX, Transaction_Record_BU);
        [parmenters setObject:address forKey:@"walletAddress"];
    } else {
        url = SERVER_COMBINE_API(URLPREFIX, Transaction_Record);
        [parmenters addEntriesFromDictionary:@{@"assetCode" : assetCode,
                                               @"issuer" : issuer,
                                               @"address" : address}];
    }
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
+ (void)getOrderDetailsDataWithHash:(NSString *)hash
                            success:(void (^)(id responseObject))success
                            failure:(void (^)(NSError *error))failure
{
    NSString * url = SERVER_COMBINE_API(URLPREFIX, Order_Details);
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
        }
    }];
}
// 身份账号数据
+ (void)setAccountDataWithRandom:(NSData *)random
                        password:(NSString *)password
                    identityName:(NSString *)identityName
                         success:(void (^)(id responseObject))success
                         failure:(void (^)(NSError *error))failure
{
    [MBProgressHUD wb_showActivity];
    // 随机数 -> 生成助记词
    NSArray * words = [Mnemonic generateMnemonicCode: [random copy]];
    NSLog(@"%@", [words componentsJoinedByString:@" "]);
    // 身份账户、钱包账户
    NSMutableArray * hdPaths = [NSMutableArray arrayWithObjects:@"M/44H/526H/0H/0/0", @"M/44H/526H/1H/0/0", nil];
    NSArray *privateKeys = [Mnemonic generatePrivateKeys: words : hdPaths];
    NSLog(@"%@", privateKeys);
    // 随机数data -> 随机数字符串
    //        NSString * randomNumber  = [Tools dataToHexStr: random];
    // 存储随机数、身份账户、钱包账户、创建身份成功
    NSString * randomKey = [NSString generateKeyStoreWithPW:password randomKey:random];
    // 私钥 -> 地址
    NSString * identityAddress = [Keypair getEncAddress : [Keypair getEncPublicKey: [privateKeys firstObject]]];
    NSString * identityKey = [NSString generateKeyStoreWithPW:password key:[privateKeys firstObject]];
    NSString * purseAddress = [Keypair getEncAddress : [Keypair getEncPublicKey: [privateKeys lastObject]]];
    NSString * purseKey = [NSString generateKeyStoreWithPW:password key:[privateKeys lastObject]];
    if (randomKey == nil) {
        [MBProgressHUD wb_showError:@"随机数keyStore生成失败"];
    } else if (identityKey == nil) {
        [MBProgressHUD wb_showError:@"身份账户keyStore生成失败"];
    } else if (purseKey == nil) {
        [MBProgressHUD wb_showError:@"钱包账户keyStore生成失败"];
    } else {
        [MBProgressHUD wb_hideHUD];
        if(success != nil)
        {
            AccountModel * account = [[AccountModel alloc] init];
            account.identityName = identityName;
            account.randomNumber = randomKey;
            account.identityAccount = identityAddress;
            account.purseAccount = purseAddress;
            account.identityKey = identityKey;
            account.purseKey = purseKey;
            // 存储帐号模型
            [AccountTool save:account];
            
            //            [defaults setObject:randomKey forKey:RandomNumber];
            //            [defaults setObject:[NSString generateKeyStoreWithPW:self.identityPassword.text key:[privateKeys firstObject]] forKey:IdentityAccount];
            //            [defaults setObject:[NSString generateKeyStoreWithPW:self.identityPassword.text key:[privateKeys firstObject]] forKey:PurseAccount];
            success(words);
        }
    }
}
// 转账
+ (void)setTransferDataWithPassword:(NSString *)password
                        destAddress:(NSString *)destAddress
                           BUAmount:(NSString *)BUAmount
                           feeLimit:(NSString *)feeLimit
                              notes:(NSString *)notes
                            success:(void (^)(TransactionResultModel * resultModel))success
                            failure:(void (^)(TransactionResultModel * resultModel))failure
{
    // Build BUSendOperation
    NSString * sourceAddress = [AccountTool account].purseAccount; // 钱包账户
    // Destination account
    //    NSString *destAddress = @"buQhapCK83xPPdjQeDuBLJtFNvXYZEKb6tKB"; // 对方账户
    // notes
    //    NSString *notes = @"test"; // 备注
    // BU amount
    int64_t amount = [Tools BU2MO: [BUAmount doubleValue]];
    BUSendOperation *operation = [BUSendOperation new];
    [operation setSourceAddress: sourceAddress];
    [operation setDestAddress: destAddress];
    [operation setAmount: amount];
    
    // Build blob, sign and submit transaction
//    NSString *privateKey = @"privbyQCRp7DLqKtRFCqKQJr81TurTqG6UKXMMtGAmPG3abcM9XHjWvq"; // 秘钥
    NSString * privateKey = [NSString decipherKeyStoreWithPW:password keyStoreValueStr:[AccountTool account].purseKey];
//    NSString *address = [Keypair getEncAddress : [Keypair getEncPublicKey: privateKey]]; // 钱包地址
    if ([Tools isEmpty:privateKey]) {
        [MBProgressHUD wb_showInfo:@"密码输入有误"];
        return;
    }
    int64_t gasPrice = 1000;
    int64_t fee = [Tools BU2MO: [feeLimit doubleValue]]; // 支付费用
    int64_t nonce = [HTTPManager getAccountNonce: sourceAddress] + 1;
    if (nonce == 0) return;
    NSString * hash = [HTTPManager buildBlobAndSignAndSubmit:privateKey :sourceAddress :nonce :gasPrice :fee :operation :notes];
    if (![Tools isEmpty: hash]) {
        [HTTPManager getTransactionStatusHash:hash success:success failure:failure];
    }
}
// 登记
+ (void)getRegisteredDataWithPassword:(NSString *)password
                      registeredModel:(RegisteredModel *)registeredModel
                              success:(void (^)(TransactionResultModel * resultModel))success
                              failure:(void (^)(TransactionResultModel * resultModel))failure
{
    // Build AccountSetMetadataOperation
    NSString * sourceAddress = [AccountTool account].purseAccount;
    NSString *key = [NSString stringWithFormat: @"asset_property_%@", registeredModel.code];//@"setMetadataTest";
    AtpProperty * atpProperty = [[AtpProperty alloc] init];
    int64_t total = registeredModel.amount * pow(10, registeredModel.decimals);
    if (registeredModel.amount != 0 && total < 1) {
        [MBProgressHUD wb_showInfo:@"发行数量有误"];
        return;
    }
    atpProperty.name = registeredModel.name;
    atpProperty.code = registeredModel.code;
    atpProperty.totalSupply = total;
    atpProperty.decimals = registeredModel.decimals;
    atpProperty.Description = registeredModel.desc;
    atpProperty.icon = @"";
    atpProperty.version = @"1.0";
    NSString * value = [atpProperty yy_modelToJSONString];
    AccountSetMetadataOperation *operation = [AccountSetMetadataOperation new];
    [operation setSourceAddress : sourceAddress];
    [operation setKey : key];
    [operation setValue : value];
    //[operation setMetadata : @"activate account"];
    
    // Build blob, sign and submit transaction
    NSString * privateKey = [NSString decipherKeyStoreWithPW:password keyStoreValueStr:[AccountTool account].purseKey];
    if ([Tools isEmpty:privateKey]) {
        [MBProgressHUD wb_showInfo:@"密码输入有误"];
        return;
    }
    int64_t gasPrice = 1000;
    int64_t feeLimit = [Tools BU2MO: Registered_Cost];
    int64_t nonce = [HTTPManager getAccountNonce: sourceAddress] + 1; // 序列号
    if (nonce == 0) return;
    NSString * hash = [HTTPManager buildBlobAndSignAndSubmit:privateKey :sourceAddress :nonce :gasPrice :feeLimit :operation :nil];
    if (![Tools isEmpty: hash]) {
        [HTTPManager getTransactionStatusHash:hash success:success failure:failure];
    }
}
// 发行
+ (void)getIssueAssetDataWithPassword:(NSString *)password
                            assetCode:(NSString *)assetCode
                           assetAmount:(NSString *)assetAmount
                             decimals:(NSInteger)decimals
                              success:(void (^)(TransactionResultModel * resultModel))success
                              failure:(void (^)(TransactionResultModel * resultModel))failure
{
    // Build AssetIssueOperation
    NSString * sourceAddress = [AccountTool account].purseAccount;
    // Asset amount
    int64_t amount = [assetAmount longLongValue] * powl(10, decimals); // 本次发行量
    if (amount < 1) {
        [MBProgressHUD wb_showInfo:@"发行数量有误"];
        return;
    }
    AssetIssueOperation *operation = [AssetIssueOperation new];
    [operation setSourceAddress: sourceAddress];
    [operation setCode: assetCode];
    [operation setAmount: amount];
    
    // Build blob, sign and submit transaction
    NSString * privateKey = [NSString decipherKeyStoreWithPW:password keyStoreValueStr:[AccountTool account].purseKey];
    if ([Tools isEmpty:privateKey]) {
        [MBProgressHUD wb_showInfo:@"密码输入有误"];
        return;
    }
    int64_t gasPrice = 1000;
    int64_t feeLimit = [Tools BU2MO: Distribution_Cost];
    int64_t nonce = [HTTPManager getAccountNonce: sourceAddress] + 1;
    if (nonce == 0) return;
    NSString * hash = [HTTPManager buildBlobAndSignAndSubmit:privateKey :sourceAddress :nonce :gasPrice :feeLimit :operation :nil];
    if (![Tools isEmpty: hash]) {
        [HTTPManager getTransactionStatusHash:hash success:success failure:failure];
    }
}
+ (int64_t) getAccountNonce: (NSString *)address {
    //NSString *address = @"buQnnUEBREw2hB6pWHGPzwanX7d28xk6KVcp";
    int64_t nonce = -1;
    AccountService *accountService = [[[SDK sharedInstance] setUrl:URL_SDK] getAccountService];
    AccountGetNonceRequest * request = [AccountGetNonceRequest new];
    [request setAddress : address];
    AccountGetNonceResponse *response = [accountService getNonce : request];
    if (response.errorCode == 0) {
        //NSLog(@"%@", [response.result yy_modelToJSONString]);
        nonce = response.result.nonce;
    } else {
        [MBProgressHUD wb_showError:response.errorDesc];
    }
    return nonce;
}

+ (NSString *) buildBlobAndSignAndSubmit : (NSString *) privateKey : (NSString *) sourceAddress : (int64_t) nonce : (int64_t) gasPrice : (int64_t) feeLimit : (BaseOperation *)operation : (NSString *) notes {
    TransactionBuildBlobRequest *buildBlobRequest = [TransactionBuildBlobRequest new];
    [buildBlobRequest setSourceAddress : sourceAddress];
    [buildBlobRequest setNonce : nonce];
    [buildBlobRequest setGasPrice : gasPrice];
    [buildBlobRequest setFeeLimit : feeLimit];
    [buildBlobRequest addOperation : operation];
    [buildBlobRequest setMetadata: notes];
    
    // 序列化交易
    TransactionService *transactionServer = [[[SDK sharedInstance] setUrl:URL_SDK] getTransactionService];
    TransactionBuildBlobResponse *buildBlobResponse = [transactionServer buildBlob : buildBlobRequest];
    NSString *hash = nil;
    if (buildBlobResponse.errorCode == 0) {
        NSLog(@"blob: %@, hash: %@", buildBlobResponse.result.transactionBlob, buildBlobResponse.result.transactionHash);
        hash = buildBlobResponse.result.transactionHash;
    } else {
        [MBProgressHUD wb_showError:buildBlobResponse.errorDesc];
        return nil;
    }
    
    // 签名
    TransactionSignRequest *signRequest = [TransactionSignRequest new];
    [signRequest setBlob : buildBlobResponse.result.transactionBlob];
    [signRequest addPrivateKey : privateKey];
    TransactionSignResponse * signResponse = [transactionServer sign : signRequest];
    if (signResponse.errorCode == 0) {
        NSLog(@"sign response: %@", [signResponse yy_modelToJSONString]);
    } else {
        [MBProgressHUD wb_showError:signResponse.errorDesc];
        return nil;
    }
    // 提交交易
    TransactionSubmitRequest *submitRequest = [TransactionSubmitRequest new];
    [submitRequest setTransactionBlob : buildBlobResponse.result.transactionBlob];
    [submitRequest setSignatures : [signResponse.result.signatures copy]];
    TransactionSubmitResponse *submitResponse = [transactionServer submit : submitRequest];
    if (submitResponse.errorCode == 0) {
        //NSLog(@"submit response: %@", [submitResponse yy_modelToJSONString]);
//        hash = submitResponse.result.transactionHash;
    } else {
        [MBProgressHUD wb_showError:submitResponse.errorDesc];
    }
    return hash;
}

// 判断转账/登记/发行是否成功
+ (void)getTransactionStatusHash: (NSString *)hash
                         success:(void (^)(TransactionResultModel * resultModel))success
                         failure:(void (^)(TransactionResultModel * resultModel))failure
{
    [MBProgressHUD wb_showActivity];
    __block TransactionGetInfoResponse *response = [TransactionGetInfoResponse new];
//    __block TransactionHistory *history = [TransactionHistory new];
    __block TransactionResultModel * resultModel = [[TransactionResultModel alloc] init];
    resultModel.transactionHash = hash;
    __block NSInteger state = 0;
    // 创建队列组，可以使多个网络请求异步执行，执行完之后再进行操作
    dispatch_group_t group = dispatch_group_create();
    //创建全局队列
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    
    dispatch_group_async(group, queue, ^{
        // 循环上传数据
        for (int i = 0; i < 20; i++) {
            //创建dispatch_semaphore_t对象
            dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
            TransactionGetInfoRequest *request = [TransactionGetInfoRequest new];
            [request setHash: hash];
            
            TransactionService *service = [[[SDK sharedInstance] setUrl: URL_SDK] getTransactionService];
            response = [service getInfo: request];
            if (response.errorCode == 0) {
                //NSLog(@"%@", [response.result yy_modelToJSONString]);
//                resultModel.history = response.result.transactions[0];
                // 请求成功发送信号量(+1)
                 dispatch_semaphore_signal(semaphore);
            } else {
                // 失败也请求成功发送信号量(+1)
                dispatch_semaphore_signal(semaphore); // 循环调用，判断超时
                state ++;
            }
            //信号量减1，如果>0，则向下执行，否则等待
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        }
    });
    
    // 当所有队列执行完成之后
    dispatch_group_notify(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 执行下面的判断代码
        if (state == 20) {
            // 返回主线程进行界面上的修改
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD wb_hideHUD];
                if(failure != nil)
                {
                    resultModel.errorCode = response.errorCode;
                    resultModel.errorDesc = response.errorDesc;
                    failure(resultModel);
                }
                // 超时
//                NSLog(@"error: %@", resultModel.response.errorDesc);
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD wb_hideHUD];
                if(success != nil)
                {
                    TransactionHistory * history = response.result.transactions[0];
                    resultModel.transactionTime = history.closeTime;
                    resultModel.errorCode = history.errorCode;
                    resultModel.errorDesc = history.errorDesc;
                    success(resultModel);
                }
            });
        }
    });
}

// 登记/发行资产
+ (void)getRegisteredORDistributionDataWithAssetCode:(NSString *)assetCode
                                        issueAddress:(NSString *)issueAddress
                                             success:(void (^)(id responseObject))success
                                             failure:(void (^)(NSError *error))failure
{
    NSString * url = SERVER_COMBINE_API(URLPREFIX, Registered_AND_Distribution);
    //HTTP请求体
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
        }
    }];
}

@end
