//
//  NSString+Extension.h
//  bupocket
//
//  Created by bupocket on 2018/10/25.
//  Copyright © 2018年 bupocket. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Extension)

+ (NSString *)stringEllipsisWithStr:(NSString *)str;

+ (NSString *)stringAppendingBUWithStr:(NSString *)str;

// key -> keyStoreValue
+ (NSString *)generateKeyStoreWithPW:(NSString *)PW randomKey:(NSData *)randomKey;
+ (NSString *)generateKeyStoreWithPW:(NSString *)PW key:(NSString *)key;
// keyStoreValue -> key
+ (NSData *)decipherKeyStoreWithPW:(NSString *)PW randomKeyStoreValueStr:(NSString *)randomKeyStoreValueStr;
+ (NSString *)decipherKeyStoreWithPW:(NSString *)PW keyStoreValueStr:(NSString *)keyStoreValueStr;
// base64 Code
+ (NSString *)encode:(NSString *)string;
// base64 Decode
+ (NSString *)dencode:(NSString *)base64String;

+ (NSString *)stringAmountSplitWith:(NSString *)str;


@end

NS_ASSUME_NONNULL_END
