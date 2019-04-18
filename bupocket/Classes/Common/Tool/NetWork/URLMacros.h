//
//  URLMacros.h
//  bupocket
//
//  Created by bupocket on 2018/10/23.
//  Copyright © 2018年 bupocket. All rights reserved.
//

#ifndef URLMacros_h
#define URLMacros_h

#define SERVER_COMBINE_API(API_BASE, API_INTERFACE) [NSString stringWithFormat:@"%@%@",API_BASE,API_INTERFACE]

#define WEB_SERVER_DOMAIN @"https://api-bp.bumo.io/"
#define BUMO_NODE_URL @"https://wallet-node.bumo.io"
#define PUSH_MESSAGE_SOCKET_URL @"https://ws-tools.bumo.io"

#define WEB_SERVER_DOMAIN_TEST @"http://192.168.6.97:5648/"
//#define WEB_SERVER_DOMAIN_TEST @"http://api-bp.bumotest.io/"
//#define BUMO_NODE_URL_TEST @"https://wallet-node.bumotest.io"
#define BUMO_NODE_URL_TEST @"http://192.168.21.35:36002"
#define PUSH_MESSAGE_SOCKET_URL_TEST @"https://ws-tools.bumotest.io"

#define Information_URL @"https://m-news.bumo.io"

// App type 1-android 2-iOS
#define Version_Update @"wallet/version?appType=2"
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
#define Account_Center_Prefix @"bumo://login/"
//#define Account_Center_ScanQRLogin @"qr/v1/userScanQrLogin"
#define Account_Center_ScanQRLogin @"login/v1/qr"
#define Account_Center_Confirm_Login @"login/v1/qr/confirm"

// dpos
#define Dpos_Prefix @"bumo://dpos/"
#define Node_Content @"nodeServer/qr/v1/content"
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
#define Node_Image_URL @"img-dpos/"
// 生成短链接
#define Node_ShortLink_URL @"nodeServer/shortlink"
#define Validate_Node_Path @"dpos/detail/validate/"
#define Kol_Node_Path @"dpos/detail/kol/"
// 共建节点支持验证
#define Node_Cooperate_Support @"nodeServer/node/v1/cooperate/support"
// 共建节点退出验证
#define Node_Cooperate_Exit @"nodeServer/node/v1/cooperate/exit"

// 交易状态查询链接
#define Transaction_Query_Link @"http://explorer.bumo.io"

#endif /* URLMacros_h */
