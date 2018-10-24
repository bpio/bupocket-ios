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

// 正式环境
#define URLPREFIX @"http://52.80.218.114:8081/"
// 测试环境
#define VIDEOURLPREFIX @"http://52.80.218.114:8081/"

#pragma mark - ——————— 详细接口地址 ————————

// Assets
#define Assets_List @"wallet/token/list"
#define Transaction_Record @"wallet/token/tx/list"
// BU
#define Transaction_Record_BU @"wallet/user/tx/list"
// OrderDetails
#define Order_Details @"wallet/tx/detail"
//#define Assets_Detail @"wallet/query/token"

#endif /* URLMacros_h */
