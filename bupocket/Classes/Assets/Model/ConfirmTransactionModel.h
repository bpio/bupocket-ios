//
//  ConfirmTransactionModel.h
//  bupocket
//
//  Created by bupocket on 2019/3/30.
//  Copyright © 2019年 bupocket. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, TransactionType) {
    TransactionTypeApplyNode = 1,
    TransactionTypeVote = 3,
    TransactionTypeCooperate = 4,
    TransactionTypeCooperateSupport = 5,
    TransactionTypeCooperateSignOut = 7,
    TransactionTypeCheck = 80,
    TransactionTypeNodeWithdrawal = 10
};

NS_ASSUME_NONNULL_BEGIN

@interface ConfirmTransactionModel : BaseModel

@property (nonatomic, copy) NSString * qrcodeSessionId;
// 1-转入质押金 2-追加质押金 3-用户投票 4-共建自购 5-共建支持 6-节点退出 7-共建退出 8-委员会审核 9-奖励提取 10-撤票
@property (nonatomic, copy) NSString * type;
// 目标地址
@property (nonatomic, copy) NSString * destAddress;
// 调用合约支出BU数量
@property (nonatomic, copy) NSString * amount;
// 调用合约的脚本内容
@property (nonatomic, copy) NSString * script;
// 二维码内容（交易内容）
@property (nonatomic, copy) NSString * qrRemark;
@property (nonatomic, copy) NSString * qrRemarkEn;
// 账户标签
@property (nonatomic, copy) NSString * accountTag;
@property (nonatomic, copy) NSString * accountTagEn;

@property (nonatomic, copy) NSString * transactionCost;
@property (nonatomic, copy) NSString * nodeId;

@property (nonatomic, copy) NSString * copies;

// 区分扫码操作还是共建详情页操作
@property (nonatomic, assign) BOOL isCooperateDetail;

@end

NS_ASSUME_NONNULL_END
