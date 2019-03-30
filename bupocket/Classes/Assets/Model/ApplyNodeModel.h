//
//  ApplyNodeModel.h
//  bupocket
//
//  Created by bupocket on 2019/3/27.
//  Copyright © 2019年 bupocket. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ApplyNodeModel : BaseModel

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

@end

NS_ASSUME_NONNULL_END
