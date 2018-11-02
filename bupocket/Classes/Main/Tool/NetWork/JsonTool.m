//
//  JsonTool.m
//  bupocket
//
//  Created by bupocket on 2018/10/25.
//  Copyright © 2018年 bupocket. All rights reserved.
//

#import "JsonTool.h"

@implementation JsonTool

/**
 将字典或者数组转换为JSON格式字符串
 @return JSON格式字符串
 */
+ (NSString *)JSONStringWithDictionaryOrArray:(id)dictionaryOrArray
{
    if (dictionaryOrArray == nil) {
        return nil;
    }
    NSData *data = [NSJSONSerialization dataWithJSONObject:dictionaryOrArray options:NSJSONWritingPrettyPrinted error:nil];
    if (data == nil) {
        return nil;
    }
    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return string;
}
/**
 将字典或者数组转换为JSON的Data
 @return JSON的Data
 */
+ (NSData *)JSONSDataWithDictionaryOrArray:(id)dictionaryOrArray
{
    if (dictionaryOrArray == nil) {
        return nil;
    }
    NSData *data = [NSJSONSerialization dataWithJSONObject:dictionaryOrArray options:NSJSONWritingPrettyPrinted error:nil];
    return data;
}
/**
 将JSON格式字符串转换为字典或者数组
 @return 字典或者数组
 */
+ (id)dictionaryOrArrayWithJSONSString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    
    return [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:nil];
}
/**
 将JSON的Data转换为字典或者数组
 @return 字典或者数组
 */
+ (id)dictionaryOrArrayWithJSONSData:(NSData *)jsonData
{
    if (jsonData == nil) {
        return nil;
    }
    return [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:nil];
}

@end
