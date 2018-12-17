//
//  NSString+Extension.m
//  bupocket
//
//  Created by bupocket on 2018/10/25.
//  Copyright © 2018年 bupocket. All rights reserved.
//

#import "NSString+Extension.h"

@implementation NSString (Extension)

+ (NSString *)stringEllipsisWithStr:(NSString *)str
{
    if (str.length > 10) {
        return  [NSString stringWithFormat:@"%@***%@", [str substringToIndex:5], [str substringFromIndex:str.length - 5]];
    } else {
        return str;
    }
}
+ (NSString *)stringAppendingBUWithStr:(NSString *)str
{
    return [str stringByAppendingString:@" BU"];
}

// key -> keyStoreValue
+ (NSString *)generateKeyStoreWithPW:(NSString *)PW randomKey:(NSData *)randomKey
{
    //    NSString *encPrivateKey = @"privbtGQELqNswoyqgnQ9tcfpkuH8P1Q6quvoybqZ9oTVwWhS6Z2hi1B";
    NSData * password = [PW dataUsingEncoding : NSUTF8StringEncoding];
    KeyStoreEty * keyStoreValue = [KeyStore generateKeyStoreFromData:password Data:randomKey :2];
    return [keyStoreValue yy_modelToJSONString];
}
+ (NSString *)generateKeyStoreWithPW:(NSString *)PW key:(NSString *)key
{
    //    NSString *encPrivateKey = @"privbtGQELqNswoyqgnQ9tcfpkuH8P1Q6quvoybqZ9oTVwWhS6Z2hi1B";
    NSData * password = [PW dataUsingEncoding : NSUTF8StringEncoding];
    KeyStoreEty * keyStoreValue = [KeyStore generateKeyStore:password PrivateKey:key :2];
    return [keyStoreValue yy_modelToJSONString];
}
// keyStoreValue -> key
+ (NSData *)decipherKeyStoreWithPW:(NSString *)PW randomKeyStoreValueStr:(NSString *)randomKeyStoreValueStr
{
    KeyStoreEty * randomKeyStoreValue = [KeyStoreEty yy_modelWithJSON: randomKeyStoreValueStr];
    NSData * password = [PW dataUsingEncoding : NSUTF8StringEncoding];
    return [KeyStore decipherKeyStoreWithData:randomKeyStoreValue :password];
}
+ (NSString *)decipherKeyStoreWithPW:(NSString *)PW keyStoreValueStr:(NSString *)keyStoreValueStr
{
    KeyStoreEty * keyStoreValue = [KeyStoreEty yy_modelWithJSON: keyStoreValueStr];
    NSData * password = [PW dataUsingEncoding : NSUTF8StringEncoding];
    return [KeyStore decipherKeyStore: keyStoreValue  : password];
}
// base64 encode
+ (NSString *)encode:(NSString *)string
{
    NSData * data = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSData * base64Data = [data base64EncodedDataWithOptions:0];
    NSString * baseString = [[NSString alloc] initWithData:base64Data encoding:NSUTF8StringEncoding];
    return baseString;
}
// base64 dencode
+ (NSString *)dencode:(NSString *)base64String
{
    NSData * data = [[NSData alloc]initWithBase64EncodedString:base64String options:NSDataBase64DecodingIgnoreUnknownCharacters];
    NSString * string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return string;
}


@end
