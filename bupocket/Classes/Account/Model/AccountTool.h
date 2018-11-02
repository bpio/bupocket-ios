//
//  AccountTool.h
//  bupocket
//
//  Created by bupocket on 2018/10/26.
//  Copyright © 2018年 bupocket. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AccountModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface AccountTool : NSObject



/**
 *  存储帐号
 */
+ (void)save:(AccountModel *)account;

/**
 *  读取帐号
 */
+ (AccountModel *)account;

/**
 *  清除path文件夹下缓存
 */
+ (BOOL)clearCache;

@end

NS_ASSUME_NONNULL_END
