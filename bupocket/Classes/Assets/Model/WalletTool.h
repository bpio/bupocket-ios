//
//  WalletTool.h
//  bupocket
//
//  Created by bupocket on 2019/1/11.
//  Copyright © 2019年 bupocket. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface WalletTool : BaseModel

+ (instancetype)shareTool;

- (void)save:(NSArray *)walletArray;

- (NSArray *)walletArray;

- (void)clearCache;

@end

NS_ASSUME_NONNULL_END
