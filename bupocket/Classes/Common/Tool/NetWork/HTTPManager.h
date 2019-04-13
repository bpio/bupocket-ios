//
//  HTTPManager.h
//  bupocket
//
//  Created by bupocket on 17/2/25.
//  Copyright © 2017年 bupocket. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RegisteredModel.h"
#import "TransactionResultModel.h"
#import "ConfirmTransactionModel.h"

@interface HTTPManager : NSObject

//// Dpos Type
//typedef NS_ENUM(NSInteger, DposType) {
//    DposTypeDefault,
//    DposTypeVote,
//    DposTypeUnVote,
//    DposTypeExtract,
//};

@property (nonatomic, strong) NSString * pushMessageSocketUrl;

+ (instancetype)shareManager;

- (void)initNetWork;

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
- (void)getAssetsDetailDataWithTokenType:(NSInteger)tokenType
                            currencyType:(NSString *)currencyType
                               assetCode:(NSString *)assetCode
                                  issuer:(NSString *)issuer
                                 address:(NSString *)address
                               pageIndex:(NSInteger)pageIndex
                                 success:(void (^)(id responseObject))success
                                 failure:(void (^)(NSError *error))failure;
// Transaction detail
- (void)getOrderDetailsDataWithAddress:(NSString *)address
                                 optNo:(NSInteger)optNo
                               success:(void (^)(id responseObject))success
                               failure:(void (^)(NSError *error))failure;
// Transaction Details
- (void)getTransactionDetailsDataWithHash:(NSString *)hash
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
// addressBook
- (void)getAddressBookListWithIdentityAddress:(NSString *)identityAddress
                                    pageIndex:(NSInteger)pageIndex
                                      success:(void (^)(id responseObject))success
                                      failure:(void (^)(NSError *error))failure;
// Add AddressBook
- (void)getAddAddressBookDataWithIdentityAddress:(NSString *)identityAddress
                                  linkmanAddress:(NSString *)linkmanAddress
                                        nickName:(NSString *)nickName
                                          remark:(NSString *)remark
                                         success:(void (^)(id responseObject))success
                                         failure:(void (^)(NSError *error))failure;
// update AddressBook
- (void)getUpdateAddressBookDataWithIdentityAddress:(NSString *)identityAddress
                                  oldLinkmanAddress:(NSString *)oldLinkmanAddress
                                  newLinkmanAddress:(NSString *)newLinkmanAddress
                                           nickName:(NSString *)nickName
                                             remark:(NSString *)remark
                                            success:(void (^)(id responseObject))success
                                            failure:(void (^)(NSError *error))failure;
// Delete AddressBook
- (void)getDeleteAddressBookDataWithIdentityAddress:(NSString *)identityAddress
                                     linkmanAddress:(NSString *)linkmanAddress
                                            success:(void (^)(id responseObject))success
                                            failure:(void (^)(NSError *error))failure;
// Account Center
- (void)getAccountCenterDataWithAppId:(NSString *)appId
                                 uuid:(NSString *)uuid
                              success:(void (^)(id responseObject))success
                              failure:(void (^)(NSError *error))failure;
// user Scan Qr Login
//- (void)getScanCodeLoginDataWithAddress:(NSString *)address
//                                   uuid:(NSString *)uuid
//                                success:(void (^)(id responseObject))success
//                                failure:(void (^)(NSError *error))failure;
//// Confirm Login
//- (void)getConfirmLoginDataWithAppId:(NSString *)appId
//                                uuid:(NSString *)uuid
//                             success:(void (^)(id responseObject))success
//                             failure:(void (^)(NSError *error))failure;
// dpos
- (void)getDposApplyNodeDataWithQRcodeSessionId:(NSString *)QRcodeSessionId
                                        success:(void (^)(id responseObject))success
                                        failure:(void (^)(NSError *error))failure;
// Contract Transaction
- (void)getContractTransactionWithModel:(ConfirmTransactionModel *)confirmTransactionModel
                                success:(void (^)(id responseObject))success
                                failure:(void (^)(NSError *error))failure;

// submit Contract Transaction / Transaction Status
- (void)submitContractTransactionPassword:(NSString *)password
                                  success:(void (^)(TransactionResultModel * resultModel))success
                                  failure:(void (^)(TransactionResultModel * resultModel))failure;
// Node List
- (void)getNodeListDataWithIdentityType:(NSString *)identityType
                               nodeName:(NSString *)nodeName
                         capitalAddress:(NSString *)capitalAddress
                                success:(void (^)(id responseObject))success
                                failure:(void (^)(NSError *error))failure;
// Voting Record
- (void)getVotingRecordDataWithNodeId:(NSString *)nodeId
                              success:(void (^)(id responseObject))success
                              failure:(void (^)(NSError *error))failure;

// Node Cooperate List
- (void)getNodeCooperateListDataSuccess:(void (^)(id responseObject))success
                                failure:(void (^)(NSError *error))failure;

// Node Cooperate Detail
- (void)getNodeCooperateDetailDataWithNodeId:(NSString *)nodeId
                                     success:(void (^)(id responseObject))success
                                     failure:(void (^)(NSError *error))failure;

#pragma mark - SDK
// Check the balance
- (int64_t)getAccountBalance;
// Query cost standard
// Obtain minimum asset limits and fuel unit prices for accounts in designated blocks
- (void)getBlockLatestFees;
// Balance judgment
- (NSDecimalNumber *)getDataWithBalanceJudgmentWithCost:(NSString *)cost ifShowLoading:(BOOL)ifShowLoading;
// Balance of assets
- (int64_t)getAssetInfoWithAddress:(NSString *)address code:(NSString *)code issuer:(NSString *)issuer;

// Query account / Is it activated?
- (NSString *)getAccountInfoWithAddress:(NSString *)address;

// identity data
- (void)setAccountDataWithRandom:(NSData *)random
                        password:(NSString *)password
                    identityName:(NSString *)identityName
                       typeTitle:(NSString *)typeTitle
                         success:(void (^)(id responseObject))success
                         failure:(void (^)(NSError *error))failure;
// Wallet data
- (void)setWalletDataWithMnemonics:(NSArray *)mnemonics
                          password:(NSString *)password
                        walletName:(NSString *)walletName
                           success:(void (^)(id responseObject))success
                           failure:(void (^)(NSError *error))failure;
- (BOOL)importWalletDataWalletName:(NSString *)walletName
                     walletAddress:(NSString *)walletAddress
                    walletKeyStore:(NSString *)walletKeyStore;
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
                             failure:(void (^)(TransactionResultModel * resultModel))failure;


// register
- (void)getRegisteredDataWithPassword:(NSString *)password
                      registeredModel:(RegisteredModel *)registeredModel
                              success:(void (^)(TransactionResultModel * resultModel))success
                              failure:(void (^)(TransactionResultModel * resultModel))failure;
// Issue
- (void)getIssueAssetDataWithPassword:(NSString *)password
                            assetCode:(NSString *)assetCode
                          assetAmount:(int64_t)assetAmount
                             decimals:(NSInteger)decimals
                              success:(void (^)(TransactionResultModel * resultModel))success
                              failure:(void (^)(TransactionResultModel * resultModel))failure;


@end
