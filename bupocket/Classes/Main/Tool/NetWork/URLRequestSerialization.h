//
//  URLRequestSerialization.h
//  bupocket
//
//  Created by bupocket on 2018/10/23.
//  Copyright © 2018年 bupocket. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface URLRequestSerialization : NSObject

+(NSString *)LYQueryStringFromParameters:(NSDictionary *)parameters;

@end

NS_ASSUME_NONNULL_END
