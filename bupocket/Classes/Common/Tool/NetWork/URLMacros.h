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

/*
#define URLPREFIX @"http://52.80.218.114:8081/"
#define URL_SDK @"http://seed1.bumotest.io:26002"
#define URLPREFIX_Socket @"http://192.168.6.98:3100"
 */

#define WEB_SERVER_DOMAIN @"https://api-bp.bumo.io/"
#define BUMO_NODE_URL @"http://wallet-node.bumo.io"
#define PUSH_MESSAGE_SOCKET_URL @"https://ws-tools.bumo.io"

#define WEB_SERVER_DOMAIN_TEST @"http://52.80.218.114:8081/"
//#define WEB_SERVER_DOMAIN_TEST @"http://api-bp.bumotest.io/"
#define BUMO_NODE_URL_TEST @"http://wallet-node.bumotest.io"
#define PUSH_MESSAGE_SOCKET_URL_TEST @"https://ws-tools.bumotest.io"

#define Version_Update @"wallet/version?appType=2"
#define Assets_List @"wallet/token/list"
#define Transaction_Record @"wallet/token/tx/list"
#define Transaction_Record_BU @"wallet/user/tx/list"
#define Order_Details @"wallet/tx/detail"
#define Assets_Search @"wallet/query/token"
#define Registered_And_Distribution @"wallet/token/detail"
#define Help_And_Feedback @"user/feedback"


#endif /* URLMacros_h */
