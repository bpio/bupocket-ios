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


+ (NSString *)JSONStringWithDictionaryOrArray:(id)dictionaryOrArray;

+ (NSData *)JSONSDataWithDictionaryOrArray:(id)dictionaryOrArray;

+ (id)dictionaryOrArrayWithJSONSString:(NSString *)jsonString;

+ (id)dictionaryOrArrayWithJSONSData:(NSData *)jsonData;

@end

NS_ASSUME_NONNULL_END
