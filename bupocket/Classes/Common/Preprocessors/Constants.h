//
//  Constants.h
//  bupocket
//
//  Created by bupocket on 2019/4/26.
//  Copyright © 2019年 bupocket. All rights reserved.
//

#ifndef Constants_h
#define Constants_h

// URL
#define SERVER_COMBINE_API(API_BASE, API_INTERFACE) [NSString stringWithFormat:@"%@%@",API_BASE,API_INTERFACE]

#define WEB_SERVER_DOMAIN @"https://api-bp.bumo.io/"
#define BUMO_NODE_URL @"https://wallet-node.bumo.io"
#define BUMO_TOOLS_URL @"https://ws-tools.bumo.io"

#define WEB_SERVER_DOMAIN_TEST @"http://api-bp.bumotest.io/"
#define BUMO_NODE_URL_TEST @"https://wallet-node.bumotest.io"
//#define WEB_SERVER_DOMAIN_TEST @"http://192.168.6.97:5648/"
//#define BUMO_NODE_URL_TEST @"http://192.168.21.35:36002"
//#define WEB_SERVER_DOMAIN_TEST @"http://test-bupocket-api.bumocdn.com/"
//#define BUMO_NODE_URL_TEST @"http://192.168.3.65:36002"

#define BUMO_TOOLS_URL_TEST @"https://ws-tools.bumotest.io"

#define Information_URL @"https://m-news.bumo.io"

// App type 1-android 2-iOS
#define Version_Update @"wallet/version?appType=2"
#define Version_Log @"wallet/version/log"
#define Assets_List @"wallet/token/list"
#define Transaction_Record @"wallet/v2/tx/list"
#define Order_Details @"wallet/v2/tx/detail"
#define Transaction_Details @"wallet/tx/detail"
#define Assets_Search @"wallet/query/token"
#define Registered_And_Distribution @"wallet/token/detail"
#define Help_And_Feedback @"user/feedback"
// AddressBook
#define AddressBook_List @"wallet/my/addressBook/list"
#define Add_AddressBook @"wallet/my/addressBook/add"
#define Update_AddressBook @"wallet/my/addressBook/update"
#define Delete_AddressBook @"wallet/my/addressBook/delete"

// Account center
//#define Account_Center_ScanQRLogin @"qr/v1/userScanQrLogin"
#define Account_Center_ScanQRLogin @"login/v1/qr"
#define Account_Center_Confirm_Login @"login/v1/qr/confirm"

// dpos
// 轮播图
#define Node_Ad_Banner @"nodeServer/slideshow/v1"

#define Node_Content @"nodeServer/qr/v1/content"
// 确认交易
#define Node_Confirm @"nodeServer/tx/v1/confirm"
// 节点撤票
#define Node_Withdrawal_Confirm @"nodeServer/node/v1/vote/revoke/user"
// 节点列表
#define Node_List @"nodeServer/node/v1/list/app"
// 邀请投票
#define Node_Invitation_Vote @"nodeServer/node/v1/detail"
// 共建节点列表
#define Node_Cooperate_List @"nodeServer/node/v1/cooperate/list"
#define Node_Cooperate_Detail @"nodeServer/node/v1/cooperate/detail"
// 投票记录
#define Voting_Record @"nodeServer/node/v1/vote/list"
#define Node_Image_URL @"img_dpos/"
// 生成短链接
#define Node_ShortLink_URL @"nodeServer/shortlink"
#define Validate_Node_Path @"supernodes/detail/validate/"
#define Kol_Node_Path @"supernodes/detail/kol/"
// 共建节点支持验证
#define Node_Cooperate_Support @"nodeServer/node/v1/cooperate/support"
// 共建节点退出验证
#define Node_Cooperate_Exit @"nodeServer/node/v1/cooperate/exit"

// 交易状态查询链接
#define Transaction_Query_Link @"http://explorer.bumo.io"
// 交易成功或超时广告图
#define AD_URL @"nodeServer/ad/v1/6aa3838c760b4e2abf37910f75394834"
// 扫码字符串
//#define Account_Center_Prefix @"bumo://login/"
//#define Dpos_Prefix @"bumo://dpos/"
#define Account_Center_Contains @"/xDnAs_login/"
#define Dpos_Contains @"/xDnAs_dpos/"
#define Dpos_Prefix @"###UDCBU###"
#define Node_Check @"/getLedger"
#define Server_Check @"healthcheck"
// voucher
#define Voucher_Prefix @"/xDnAs_rv/"
#define Voucher_List @"voucher/v1/my/list"
#define Voucher_Detail @"voucher/v1/detail"


#define HDPaths @[@"M/44H/526H/0H/0/0", @"M/44H/526H/1H/0/0"]
#define LastVersion @"LastVersion"
// Identity creation
#define If_Created @"ifCreated"
// Successful backup of memorizing words
#define If_Backup @"ifBackup"
// skip the backup
//#define If_Skip @"ifSkip"
#define If_Show_Switch_Network @"ifShowSwitchNetwork"
#define If_Switch_TestNetwork @"ifSwitchTestNetwork"
#define If_Show_Custom_Network @"ifShowCustomNetwork"
#define If_Custom_Network @"ifCustomNetwork"
#define Version_Info @"VersionInfo"
#define If_Hidden_New @"IfHiddenNew"
// Language key
#define AppLanguage @"appLanguage"
#define ZhHans @"zh-Hans"
#define EN @"en"
// Current currency index 0：CNY（¥）, 1：USD（$）, 2：JPY（¥）, 3：KRW（₩）,
#define Current_Currency @"CurrentCurrency"
#define Current_Node_URL @"CurrentNodeURL"
#define Current_Node_URL_Test @"CurrentNodeURLTest"
#define Node_URL_Array @"NodeUrlArray"
#define Node_URL_Array_Test @"NodeUrlArrayTest"
//#define Node_URL_Array_Custom @"NodeUrlArrayCustom"
#define Current_Node_URL_Custom @"CurrentNodeURLCustom"
//#define Default_Node_URL_Custom @"DefaultNodeURLCustom"

// imported Wallet
//#define imported_Wallet @"importedWallet"
// Network request timeout limit time
#define Timeout_Interval 60.0
#define Assets_HomePage_CacheData @"AssetsHomePageCacheData"
#define Assets_HomePage_CacheData_Test @"AssetsHomePageCacheDataTest"
#define Assets_HomePage_CacheData_Custom @"AssetsHomePageCacheDataCustom"
// 0: BU 1：ATP 2：CTP
#define Token_Type_BU 0
// 0：Turn out 1：To change into
#define Transaction_Type_TurnOut 0
// Add assets
#define Add_Assets @"AddAssets"
#define Add_Assets_Test @"AddAssetsTest"
#define Add_Assets_Custom @"AddAssetsCustom"

#define PageIndex_Default 1
#define PageSize_Max 10
#define Success_Code 0
// Number of mnemonic words
#define NumberOf_MnemonicWords 12
// Random number length
#define Random_Length 16
// Estimated registration fees
//#define Registered_CostBU @"0.02 BU"
#define Registered_Cost @"0.02"
// Estimated issuance cost
//#define Distribution_CostBU @"50.01 BU"
#define Distribution_Cost @"50.01"
// Transfer payment expenses
#define TransactionCost_MAX @"10"
#define TransactionCost_MIN @"0.01"
#define TransactionCost_Check_MIN @"0.15"
#define TransactionCost_Cooperate_MIN @"10.3"
#define Activate_Cooperate_MIN @"0.01"

//#define NodeType_Consensus @"1"
//#define NodeType_Ecological @"2"

#define Role_validator @"validator"
#define Role_kol @"kol"

#define TransactionCost_NotActive_MIN @"0.03"
#define ActivateInitBalance @"0.02"
// BU decimals
#define Decimals_BU 8
// Number of transfers sent
//#define SendingQuantity_MIN @"0.00000001"
#define SendingQuantity_MAX @"100000000"
#define SendingQuantity_MAX_Division @"100,000,000"
// Maximum length of ID and password / Transaction memo length / Length of feedback contact mode
#define MAX_LENGTH 20
#define PW_MIN_LENGTH 6
#define PW_MAX_LENGTH 30
// Cycle query transaction state maximum number
#define Maximum_Number 30
// Feedback content
#define SuggestionsContent_MAX 100
#define AlertBgAlpha 0.2
// ATP Version
#define ATP_Version @"1.0"
// Obtain minimum asset limits and fuel unit prices for accounts in designated blocks
#define Minimum_Asset_Limitation @"MinimumAssetLimitation"

#define Address_MinimumFontSize ScreenScale(10)

#define AddressBook_Cache_Name @"addressBook.sqlite"

//#define Wechat_APP_ID @"wxaecf7ac4085fd34a"
//#define SmallRoutine_Original_ID @"gh_463781563a74"

#define Wechat_APP_ID @"wxaecf7ac4085fd34a"
#define XCX_YouPin_Original_ID @"gh_545e659b7dcd"

#define Tencent_App_ID @"101569415"
#define UM_App_Key @"5cc7a6020cafb223d0000ae9"

#define Dispatch_After_Time 0.5

#define SubIndex_Address 5
#define SubIndex_hash 8

#endif /* Constants_h */
