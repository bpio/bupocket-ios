//
//  HttpTool.h
//  TheImperialPalaceMuseum
//
//  Created by bupocket on 17/2/25.
//  Copyright © 2017年 hss. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HttpTool : NSObject

+ (instancetype)shareTool;

- (void)GET:(NSString *)URLString
 parameters:(NSDictionary *)parameters
    success:(void(^)(id responseObject))success
    failure:(void(^)(NSError * error))failure;

- (void)POST:(NSString *)URLString
  parameters:(NSDictionary *)parameters
     success:(void(^)(id responseObject))success
     failure:(void(^)(NSError * error))failure;
@end
