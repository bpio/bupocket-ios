//
//  Constant.h
//  bupocket
//
//  Created by bubi on 2018/11/1.
//  Copyright © 2018年 bupocket. All rights reserved.
//

#ifndef Constant_h
#define Constant_h

//#define NotFirst @"notFirst"
// Identity creation
#define If_Created @"ifCreated"
// Successful backup of memorizing words
#define If_Backup @"ifBackup"
// skip the backup
#define If_Skip @"ifSkip"
#define If_Switch_TestNetwork @"ifSwitchTestNetwork"
// Language key
#define AppLanguage @"appLanguage"
#define ZhHans @"zh-Hans"
#define EN @"en"
#define Current_Currency @"CurrentCurrency"
// Network request timeout limit time
#define Timeout_Interval 30.0
// Add assets
#define Add_Assets @"AddAssets"
#define Add_Assets_Test @"AddAssetsTest"

#define PageIndex_Default 1
#define PageSize_Max 10
#define Success_Code 0
// Number of mnemonic words
#define NumberOf_MnemonicWords 12
// Random number length
#define Random_Length 16
// Estimated registration fees
#define Registered_CostBU @"0.02 BU"
#define Registered_Cost 0.02
// Estimated issuance cost
#define Distribution_CostBU @"50.01 BU"
#define Distribution_Cost 50.01
// Transfer payment expenses
#define TransactionCost_MIN 0.01
#define TransactionCost_MAX 10
// 转账发送数量
//#define SendingQuantity_MIN 0.00000001
//#define SendingQuantity_MAX 10000
// Maximum length of ID and password / Transaction memo length / Length of feedback contact mode
#define MAX_LENGTH 20
// Cycle query transaction state maximum number
#define Maximum_Number 20
// Feedback content
#define SuggestionsContent_MAX 100
// ATP
#define ATP_Version @"1.0"




#endif /* Constant_h */
