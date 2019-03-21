//
//  DateTool.h
//  bupocket
//
//  Created by bupocket on 2018/10/25.
//  Copyright © 2018年 bupocket. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DateTool : NSObject

// Time stamp - > time
+ (NSString *)getDateStringWithTimeStr:(NSString *)str;
+ (NSString *)getDateProcessingWithTimeStr:(NSString *)str;

@end

NS_ASSUME_NONNULL_END
