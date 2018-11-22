//
//  HTTPManager.h
//  TheImperialPalaceMuseum
//
//  Created by bupocket on 17/2/25.
//  Copyright © 2017年 hss. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RegisteredModel.h"
#import "TransactionResultModel.h"

@interface HTTPManager : NSObject

@property (nonatomic, strong) NSString * pushMessageSocketUrl;

+ (instancetype)shareManager;

// Switched network
- (void)SwitchedNetworkWithIsTest:(BOOL)isTest;

// VersionUpdate
- (void)getVersionDataWithSuccess:(void (^)(id responseObject))success
                          failure:(void (^)(NSError *error))failure;

// Assets
- (void)getAssetsDataWithAddress:(NSString *)address
                    currencyType:(NSString *)currencyType
                       tokenList:(NSArray *)tokenList
                         success:(void (^)(id responseObject))success
                         failure:(void (^)(NSError *error))failure;
// SearchAssets
- (void)getSearchAssetsDataWithAssetCode:(NSString *)assetCode
                               pageIndex:(NSInteger)pageIndex
                                 success:(void (^)(id responseObject))success
                                 failure:(void (^)(NSError *error))failure;
// AssetsDetail Transaction_Record
- (void)getAssetsDetailDataWithAssetCode:(NSString *)assetCode
                                  issuer:(NSString *)issuer
                                 address:(NSString *)address
                            currencyType:(NSString *)currencyType
                               pageIndex:(NSInteger)pageIndex
                                 success:(void (^)(id responseObject))success
                                 failure:(void (^)(NSError *error))failure;
// OrderDetails
- (void)getOrderDetailsDataWithHash:(NSString *)hash
                            success:(void (^)(id responseObject))success
                            failure:(void (^)(NSError *error))failure;
// Registration / issuance of assets information
- (void)getRegisteredORDistributionDataWithAssetCode:(NSString *)assetCode
                                        issueAddress:(NSString *)issueAddress
                                             success:(void (^)(id responseObject))success
                                             failure:(void (^)(NSError *error))failure;
// Feedback feedback
- (void)getFeedbackDataWithContent:(NSString *)content
                           contact:(NSString *)contact
                           success:(void (^)(id responseObject))success
                           failure:(void (^)(NSError *error))failure;

#pragma mark - SDK
// Check the balance
- (int64_t)getAccountBalance;
// Query cost standard
- (int64_t) getBlockFees;
// Balance judgment
- (int64_t)getDataWithBalanceJudgmentWithCost:(double)cost ifShowLoading:(BOOL)ifShowLoading;
// Balance of assets
- (int64_t)getAssetInfoWithAddress:(NSString *)address code:(NSString *)code issuer:(NSString *)issuer;

// identity data
- (void)setAccountDataWithRandom:(NSData *)random
                        password:(NSString *)password
                    identityName:(NSString *)identityName
                         success:(void (^)(id responseObject))success
                         failure:(void (^)(NSError *error))failure;
// Transfer accounts
- (void)setTransferDataWithPassword:(NSString *)password
                        destAddress:(NSString *)destAddress
                           BUAmount:(NSString *)BUAmount
                           feeLimit:(NSString *)feeLimit
                              notes:(NSString *)notes
                               code:(NSString *)code
                             issuer:(NSString *)issuer
                            success:(void (^)(TransactionResultModel * resultModel))success
                            failure:(void (^)(TransactionResultModel * resultModel))failure;


// register
- (void)getRegisteredDataWithPassword:(NSString *)password
                      registeredModel:(RegisteredModel *)registeredModel
                              success:(void (^)(TransactionResultModel * resultModel))success
                              failure:(void (^)(TransactionResultModel * resultModel))failure;
// Issue
- (void)getIssueAssetDataWithPassword:(NSString *)password
                            assetCode:(NSString *)assetCode
                          assetAmount:(NSString *)assetAmount
                             decimals:(NSInteger)decimals
                              success:(void (^)(TransactionResultModel * resultModel))success
                              failure:(void (^)(TransactionResultModel * resultModel))failure;


@end