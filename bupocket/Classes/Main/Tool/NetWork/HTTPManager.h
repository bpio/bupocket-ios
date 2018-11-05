//
//  HTTPManager.h
//  TheImperialPalaceMuseum
//
//  Created by 霍双双 on 17/2/25.
//  Copyright © 2017年 hss. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RegisteredModel.h"
#import "TransactionResultModel.h"
//#import "DistributionModel.h"

@interface HTTPManager : NSObject

+ (HTTPManager *)shareManager;

+ (int64_t)getAccountBalance;
+ (int64_t) getBlockFees;
// 余额是否足够
+ (int64_t)getDataWithBalanceJudgmentWithCost:(double)cost;

// Assets
+ (void)getAssetsDataWithAddress:(NSString *)address
                    currencyType:(NSString *)currencyType
                       tokenList:(NSArray *)tokenList
                         success:(void (^)(id responseObject))success
                         failure:(void (^)(NSError *error))failure;
// SearchAssets
+ (void)getSearchAssetsDataWithAssetCode:(NSString *)assetCode
                               pageIndex:(NSInteger)pageIndex
                                 success:(void (^)(id responseObject))success
                                 failure:(void (^)(NSError *error))failure;
// AssetsDetail Transaction_Record
+ (void)getAssetsDetailDataWithAssetCode:(NSString *)assetCode
                                  issuer:(NSString *)issuer
                                 address:(NSString *)address
                               pageIndex:(NSInteger)pageIndex
                                 success:(void (^)(id responseObject))success
                                 failure:(void (^)(NSError *error))failure;
// OrderDetails
+ (void)getOrderDetailsDataWithHash:(NSString *)hash
                            success:(void (^)(id responseObject))success
                            failure:(void (^)(NSError *error))failure;


// 身份账号数据
+ (void)setAccountDataWithRandom:(NSData *)random
                        password:(NSString *)password
                    identityName:(NSString *)identityName
                         success:(void (^)(id responseObject))success
                         failure:(void (^)(NSError *error))failure;
// 转账
+ (void)setTransferDataWithPassword:(NSString *)password
                        destAddress:(NSString *)destAddress
                           BUAmount:(NSString *)BUAmount
                           feeLimit:(NSString *)feeLimit
                              notes:(NSString *)notes
                            success:(void (^)(TransactionResultModel * resultModel))success
                            failure:(void (^)(TransactionResultModel * resultModel))failure;

// 登记/发行资产
+ (void)getRegisteredORDistributionDataWithAssetCode:(NSString *)assetCode
                                        issueAddress:(NSString *)issueAddress
                                             success:(void (^)(id responseObject))success
                                             failure:(void (^)(NSError *error))failure;

// 登记
+ (void)getRegisteredDataWithPassword:(NSString *)password
                      registeredModel:(RegisteredModel *)registeredModel
                              success:(void (^)(TransactionResultModel * resultModel))success
                              failure:(void (^)(TransactionResultModel * resultModel))failure;
// 发行
+ (void)getIssueAssetDataWithPassword:(NSString *)password
                            assetCode:(NSString *)assetCode
                          assetAmount:(NSString *)assetAmount
                             decimals:(NSInteger)decimals
                              success:(void (^)(TransactionResultModel * resultModel))success
                              failure:(void (^)(TransactionResultModel * resultModel))failure;
+ (void)getFeedbackDataWithContent:(NSString *)content
                           contact:(NSString *)contact
                           success:(void (^)(id responseObject))success
                           failure:(void (^)(NSError *error))failure;

@end
