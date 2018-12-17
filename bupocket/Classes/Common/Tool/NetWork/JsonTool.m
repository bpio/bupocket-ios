//
//  JsonTool.m
//  bupocket
//
//  Created by bupocket on 2018/10/25.
//  Copyright © 2018年 bupocket. All rights reserved.
//

#import "JsonTool.h"

@implementation JsonTool


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

+ (NSData *)JSONSDataWithDictionaryOrArray:(id)dictionaryOrArray
{
    if (dictionaryOrArray == nil) {
        return nil;
    }
    NSData *data = [NSJSONSerialization dataWithJSONObject:dictionaryOrArray options:NSJSONWritingPrettyPrinted error:nil];
    return data;
}

+ (id)dictionaryOrArrayWithJSONSString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    
    return [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:nil];
}

+ (id)dictionaryOrArrayWithJSONSData:(NSData *)jsonData
{
    if (jsonData == nil) {
        return nil;
    }
    return [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:nil];
}

@end
