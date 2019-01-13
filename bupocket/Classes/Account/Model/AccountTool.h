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

+ (instancetype)shareTool;

- (void)save:(AccountModel *)account;

- (AccountModel *)account;

- (void)clearCache;

@end

NS_ASSUME_NONNULL_END
