//
//  HTTPSessionManager.h
//  bupocket
//
//  Created by bupocket on 2018/10/23.
//  Copyright © 2018年 bupocket. All rights reserved.
//

#import "AFHTTPSessionManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface HTTPSessionManager : AFHTTPSessionManager

+ (instancetype)sessionManager;

@end

NS_ASSUME_NONNULL_END
