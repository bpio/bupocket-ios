//
//  HTTPRequestOperationManager.h
//  bupocket
//
//  Created by bupocket on 2018/10/23.
//  Copyright © 2018年 bupocket. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HTTPRequestOperationManager : NSObject

-(void)driveTask:(nullable void(^)(NSData *__nullable data,NSURLResponse * __nullable response))success
         failure:(nullable void (^)(NSError *__nullable error))failure;


- (instancetype) initWithMethod:(NSString *)method URL:(NSString *)URL parameters:( id)parameters;

@end

NS_ASSUME_NONNULL_END
