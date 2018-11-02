//
//  JsonTool.h
//  bupocket
//
//  Created by bupocket on 2018/10/25.
//  Copyright © 2018年 bupocket. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JsonTool : NSObject

/**
 将字典或者数组转换为JSON格式字符串
 @return JSON格式字符串
 */
+ (NSString *)JSONStringWithDictionaryOrArray:(id)dictionaryOrArray;

/**
 将字典或者数组转换为JSON的Data
 @return JSON的Data
 */
+ (NSData *)JSONSDataWithDictionaryOrArray:(id)dictionaryOrArray;

/**
 将JSON格式字符串转换为字典或者数组
 @return 字典或者数组
 */
+ (id)dictionaryOrArrayWithJSONSString:(NSString *)jsonString;

/**
 将JSON的Data转换为字典或者数组
 @return 字典或者数组
 */
+ (id)dictionaryOrArrayWithJSONSData:(NSData *)jsonData;

@end

NS_ASSUME_NONNULL_END
