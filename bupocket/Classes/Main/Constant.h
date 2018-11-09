//
//  Constant.h
//  bupocket
//
//  Created by bubi on 2018/11/1.
//  Copyright © 2018年 bupocket. All rights reserved.
//

#ifndef Constant_h
#define Constant_h

#define NotFirst @"notFirst"
// 是否已创建身份
#define ifCreated @"ifCreated"
// 是否已成功备份助记词
#define ifBackup @"ifBackup"

// 添加资产数组
#define AddAssets @"AddAssets"

// 分页数据条数
#define PageSize_Max 10
// 助记词个数
#define NumberOf_MnemonicWords 12
// 随机数长度
#define Random_Length 16

// 登记费用
#define Registered_CostBU @"0.02 BU"
#define Registered_Cost 0.02
// 发行费用
#define Distribution_CostBU @"50.01 BU"
#define Distribution_Cost 50.01
// 转账支付费用
#define TransactionCost_MIN 0.01
#define TransactionCost_MAX 10
// 转账发送数量
#define SendingQuantity_MIN 0.00000001
#define SendingQuantity_MAX 10000
// 身份名和密码最大长度、交易备注长度、意见反馈练习方式长度
#define MAX_LENGTH 20
// 意见反馈内容
#define SuggestionsContent_MAX 100
// ATP
#define ATP_Version @"1.0"




#endif /* Constant_h */
