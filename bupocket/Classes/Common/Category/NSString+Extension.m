//
//  NSString+Extension.m
//  bupocket
//
//  Created by bupocket on 2018/10/25.
//  Copyright © 2018年 bupocket. All rights reserved.
//

#import "NSString+Extension.h"
#import "CommonCrypto/CommonDigest.h"

@implementation NSString (Extension)

+ (NSString *)stringEllipsisWithStr:(NSString *)str subIndex:(NSInteger)subIndex
{
    if (str.length > (subIndex * 2)) {
        return  [NSString stringWithFormat:@"%@***%@", [str substringToIndex:subIndex], [str substringFromIndex:str.length - subIndex]];
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
// 千分符
+ (NSString *)stringAmountSplitWith:(NSString *)str
{
//    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc]init];
//    [numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
//    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
//    [numberFormatter setFormatWidth:20];
//    NSString *numberString = [numberFormatter stringFromNumber:[NSNumber numberWithString:str]];
//    NSLog(@"%@",numberString);
//    return numberString;
    double oldf = [str doubleValue];
    long long oldll = [str longLongValue];
    double tmptf = oldf - oldll;
    NSString * currencyStr = nil;
    if(tmptf > 0){
//        currencyStr = [NSNumberFormatter localizedStringFromNumber:[NSNumber numberWithDouble:oldf] numberStyle:NSNumberFormatterDecimalStyle];
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        numberFormatter.numberStyle = NSNumberFormatterRoundFloor;//格式化的格式
//        numberFormatter.maximumFractionDigits = 8;
        [numberFormatter setPositiveFormat:@" ###,###.000000"];//保留两位小数
        currencyStr = [numberFormatter stringFromNumber:[NSNumber numberWithString:str]];
    } else {
        currencyStr = [NSNumberFormatter localizedStringFromNumber:[NSNumber numberWithLongLong:oldll] numberStyle:NSNumberFormatterDecimalStyle];
    }
    return currencyStr;
}

/**
 * MD5加密
 *
 * return  加密后的字符串
 */
+ (NSString *)MD5:(NSString *)mdStr {
    const char *original_str = [mdStr UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(original_str, (CC_LONG)strlen(original_str), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [hash appendFormat:@"%02X", result[i]];
    return [hash lowercaseString];
}

@end
