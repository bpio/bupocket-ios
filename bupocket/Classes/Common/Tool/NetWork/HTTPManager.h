//
//  HTTPManager.h
//  bupocket
//
//  Created by bupocket on 17/2/25.
//  Copyright © 2017年 bupocket. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sdk_ios/sdk_ios.h>
#import <YYKit/YYKit.h>
#import "RegisteredModel.h"
#import "TransactionResultModel.h"
#import "ConfirmTransactionModel.h"
#import "WalletModel.h"
#import "DposModel.h"

typedef NS_ENUM(NSInteger, AccountDataType) {
    AccountDataCreateID,
    AccountDataCreateWallet,
    AccountDataRecoveryID,
    AccountDataSafe
};

@interface HTTPManager : NSObject

@property (nonatomic, strong) NSString * pushMessageSocketUrl;

+ (instancetype)shareManager;

- (void)initNetWork;

// Switched network
- (void)SwitchedNetworkWithIsTest:(BOOL)isTest;
// show Custom network
- (void)ShowCustomNetwork;
// Switched Custom network
- (void)SwitchedNetworkWithIsCustom:(BOOL)isCustom;
// Switched Node url
- (void)SwitchedNodeWithURL:(NSString *)URL;

- (NSString *)getCurrentNetwork;

// Version Update
- (void)getDataWithURL:(NSString *)URL
               success:(void (^)(id responseObject))success
               failure:(void (^)(NSError *error))failure;

// Version Log
- (void)getVersionLogDataWithPageIndex:(NSInteger)pageIndex
                               success:(void (^)(id responseObject))success
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
- (void)getOrderDetailsDataWithOptNo:(NSInteger)optNo
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
#pragma mark - Activity(RedEnvelopes)
// Activity
- (void)getActivityDataWithURL:(NSString *)URL
                     bonusCode:(NSString *)bonusCode
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
// find ad banner
- (void)getAdsDataWithURL:(NSString *)URL
                  success:(void (^)(id responseObject))success
                  failure:(void (^)(NSError *error))failure;
// Node URL Check
- (void)getNodeDataWithURL:(NSString *)URL
                   success:(void (^)(id responseObject))success
                   failure:(void (^)(NSError *error))failure;

// banner
- (void)getBannerAdsDataWithSuccess:(void (^)(id responseObject))success
                            failure:(void (^)(NSError *error))failure;
// dpos
- (void)getDposApplyNodeDataWithQRcodeSessionId:(NSString *)QRcodeSessionId
                                        success:(void (^)(id responseObject))success
                                        failure:(void (^)(NSError *error))failure;
// Contract Transaction
#pragma mark 确认交易
// Contract Transaction
- (BOOL)getTransactionHashWithModel:(ConfirmTransactionModel *)confirmTransactionModel;
- (void)getContractTransactionWithModel:(ConfirmTransactionModel *)confirmTransactionModel
                                success:(void (^)(id responseObject))success
                                failure:(void (^)(NSError *error))failure;
// short link
- (void)getShortLinkDataWithType:(NSString *)type
                            path:(NSString *)path
                         success:(void (^)(id responseObject))success
                         failure:(void (^)(NSError *error))failure;
// Node List
- (void)getNodeListDataWithIdentityType:(NSString *)identityType
                               nodeName:(NSString *)nodeName
                         capitalAddress:(NSString *)capitalAddress
                                success:(void (^)(id responseObject))success
                                failure:(void (^)(NSError *error))failure;
// Node Invitation Vote
- (void)getNodeInvitationVoteDataWithNodeId:(NSString *)nodeId
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
#pragma mark - Voucher
// voucher list
- (void)getVoucherListDataWithPageIndex:(NSInteger)pageIndex
                                success:(void (^)(id responseObject))success
                                failure:(void (^)(NSError *error))failure;
// voucher detail
- (void)getVoucherDetailDataWithVoucherId:(NSString *)voucherId
                                trancheId:(NSString *)trancheId
                                    spuId:(NSString *)spuId
                          contractAddress:(NSString *)contractAddress
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

// vouther Balace
- (int64_t)getVoutherBalanceWithDposModel:(DposModel *)dposModel;

#pragma mark - Nonce
- (int64_t) getAccountNonce: (NSString *)address;
#pragma mark - hash
- (BOOL)getHashWithSourceAddress:(NSString *)sourceAddress
                           nonce:(int64_t)nonce
                        gasPrice:(int64_t)gasPrice
                        feeLimit:(int64_t)feeLimit
                      operations:(NSMutableArray<BaseOperation *> *)operations
                           notes:(NSString *) notes;
#pragma mark - sign
- (BOOL)getSignWithPrivateKey:(NSString *)privateKey;

#pragma mark 提交交易
- (void)submitTransactionWithSuccess:(void (^)(TransactionResultModel * resultModel))success
                             failure:(void (^)(TransactionResultModel * resultModel))failure;

// Query account / Is it activated?
- (NSString *)getAccountInfoWithAddress:(NSString *)address;

#pragma mark - account data
- (void)setAccountDataWithRandom:(NSData *)random
                        password:(NSString *)password
                            name:(NSString *)name
                 accountDataType:(AccountDataType)accountDataType
                         success:(void (^)(id responseObject))success
                         failure:(void (^)(NSError *error))failure;
// Wallet data
- (void)setWalletDataWithMnemonics:(NSArray *)mnemonics
                          password:(NSString *)password
                        walletName:(NSString *)walletName
                           success:(void (^)(id responseObject))success
                           failure:(void (^)(NSError *error))failure;
// device bind
- (void)getDeviceBindDataWithURL:(NSString *)URL
                 identityAddress:(NSString *)identityAddress
                   walletAddress:(NSString *)walletAddress
                        signData:(NSString *)signData
                       publicKey:(NSString *)publicKey
                         success:(void (^)(id responseObject))success
                         failure:(void (^)(NSError *error))failure;
- (BOOL)setWalletDataWalletName:(NSString *)walletName
                  walletAddress:(NSString *)walletAddress
                 walletKeyStore:(NSString *)walletKeyStore
                   randomNumber:(NSString *)randomNumber;
- (void)modifyPasswordWithOldPW:(NSString *)oldPW
                             PW:(NSString *)PW
                    walletModel:(WalletModel *)walletModel
                        success:(void (^)(id responseObject))success;
#pragma mark - 转账
// Transfer accounts
- (BOOL)setTransferDataWithTokenType:(NSInteger)tokenType
                         destAddress:(NSString *)destAddress
                              assets:(NSString *)assets
                            decimals:(NSInteger)decimals
                            feeLimit:(NSString *)feeLimit
                               notes:(NSString *)notes
                                code:(NSString *)code
                              issuer:(NSString *)issuer;


// register
- (BOOL)getRegisteredDataWithRegisteredModel:(RegisteredModel *)registeredModel;
// Issue
- (BOOL)getIssueAssetDataWithAssetCode:(NSString *)assetCode
                           assetAmount:(int64_t)assetAmount
                              decimals:(NSInteger)decimals;

#pragma mark - 调用底层合约
- (BOOL)getTransactionWithDposModel:(DposModel *)dposModel isDonateVoucher:(BOOL)isDonateVoucher;


@end
