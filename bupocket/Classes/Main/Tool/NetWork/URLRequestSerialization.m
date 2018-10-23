//
//  URLRequestSerialization.m
//  bupocket
//
//  Created by bupocket on 2018/10/23.
//  Copyright © 2018年 bupocket. All rights reserved.
//

#import "URLRequestSerialization.h"

@interface URLRequestSerialization()

@property (readwrite, nonatomic, strong) id  value;
@property (readwrite, nonatomic, strong) id  field;


@end

@implementation URLRequestSerialization

- (id)initWithField:(id)field value:(id)value {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.field = field;
    self.value = value;
    
    return self;
}

#pragma mark -

FOUNDATION_EXPORT NSArray * LYQueryStringPairsFromDictionary(NSDictionary *dictionary);
FOUNDATION_EXPORT NSArray * LYQueryStringPairsFromKeyAndValue(NSString *key, id value);

+(NSString *)LYQueryStringFromParameters:(NSDictionary *)parameters {
    NSMutableArray *mutablePairs = [NSMutableArray array];
    for (URLRequestSerialization *pair in LYQueryStringPairsFromDictionary(parameters)) {
        
        [mutablePairs addObject:[pair URLEncodedStringValue]];
    }
    
    return [mutablePairs componentsJoinedByString:@"&"];
}



NSArray * LYQueryStringPairsFromDictionary(NSDictionary *dictionary) {
    return LYQueryStringPairsFromKeyAndValue(nil, dictionary);
}



NSArray * LYQueryStringPairsFromKeyAndValue(NSString *key, id value) {
    NSMutableArray *mutableQueryStringComponents = [NSMutableArray array];
    
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"description" ascending:YES selector:@selector(compare:)];
    
    if ([value isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dictionary = value;
        for (id nestedKey in [dictionary.allKeys sortedArrayUsingDescriptors:@[ sortDescriptor ]]) {
            id nestedValue = dictionary[nestedKey];
            if (nestedValue) {
                [mutableQueryStringComponents addObjectsFromArray:LYQueryStringPairsFromKeyAndValue((key ? [NSString stringWithFormat:@"%@[%@]", key, nestedKey] : nestedKey), nestedValue)];
            }
        }
    } else if ([value isKindOfClass:[NSArray class]]) {
        NSArray *array = value;
        for (id nestedValue in array) {
            [mutableQueryStringComponents addObjectsFromArray:LYQueryStringPairsFromKeyAndValue([NSString stringWithFormat:@"%@[]", key], nestedValue)];
        }
    } else if ([value isKindOfClass:[NSSet class]]) {
        NSSet *set = value;
        for (id obj in [set sortedArrayUsingDescriptors:@[ sortDescriptor ]]) {
            [mutableQueryStringComponents addObjectsFromArray:LYQueryStringPairsFromKeyAndValue(key, obj)];
        }
    } else {
        [mutableQueryStringComponents addObject:[[URLRequestSerialization alloc] initWithField:key value:value]];
    }
    
    return mutableQueryStringComponents;
}


static NSString * LYPercentEscapedStringFromString(NSString *string) {
    static NSString * const kLYCharactersGeneralDelimitersToEncode = @":#[]@"; // does not include "?" or "/" due to RFC 3986 - Section 3.4
    static NSString * const kLYCharactersSubDelimitersToEncode = @"!$&'()*+,;=";
    
    NSMutableCharacterSet * allowedCharacterSet = [[NSCharacterSet URLQueryAllowedCharacterSet] mutableCopy];
    [allowedCharacterSet removeCharactersInString:[kLYCharactersGeneralDelimitersToEncode stringByAppendingString:kLYCharactersSubDelimitersToEncode]];
    
    
    static NSUInteger const batchSize = 50;
    
    NSUInteger index = 0;
    NSMutableString *escaped = @"".mutableCopy;
    
    while (index < string.length) {
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wgnu"
        NSUInteger length = MIN(string.length - index, batchSize);
#pragma GCC diagnostic pop
        NSRange range = NSMakeRange(index, length);
        
        range = [string rangeOfComposedCharacterSequencesForRange:range];
        
        NSString *substring = [string substringWithRange:range];
        NSString *encoded = [substring stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacterSet];
        [escaped appendString:encoded];
        
        index += range.length;
    }
    
    return escaped;
}

- (NSString *)URLEncodedStringValue {
    if (!self.value || [self.value isEqual:[NSNull null]]) {
        return LYPercentEscapedStringFromString([self.field description]);
    } else {
        return [NSString stringWithFormat:@"%@=%@", LYPercentEscapedStringFromString([self.field description]), LYPercentEscapedStringFromString([self.value description])];
    }
}


@end
