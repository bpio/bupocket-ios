//
//  NetWorkManager.h
//  bupocket
//
//  Created by bupocket on 2018/10/23.
//  Copyright © 2018年 bupocket. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NetWorkManager : NSObject

+ (NetWorkManager *)shareManager;
// Assets
+ (void)getDataWithSuccess:(void (^)(id responseObject))success
                   failure:(void (^)(NSError *error))failure;

@end

NS_ASSUME_NONNULL_END
