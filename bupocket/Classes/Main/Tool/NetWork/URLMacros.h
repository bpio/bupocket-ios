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

//#define URLPREFIX @"http://api-bp.bumotest.io/"
#define URLPREFIX @"http://52.80.218.114:8081/"
#define URLPREFIX_Socket @"http://192.168.6.98:3100"
// SDK
#define URL_SDK @"http://seed1.bumotest.io:26002"


#define Assets_List @"wallet/token/list"
#define Transaction_Record @"wallet/token/tx/list"
#define Transaction_Record_BU @"wallet/user/tx/list"
#define Order_Details @"wallet/tx/detail"
//#define Assets_Detail @"wallet/query/token"
#define Registered_AND_Distribution @"wallet/token/detail"


#endif /* URLMacros_h */
