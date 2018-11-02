//
//  mnemonic.m
//  sdk-ios
//
//  Created by 冯瑞明 on 2018/10/11.
//  Copyright © 2018年 dlx. All rights reserved.
//

#import "Mnemonic.h"
#import "Tools.h"
#import "Hash.h"
#import "BUChainKey.h"
#import <CommonCrypto/CommonHMAC.h>
#import <CommonCrypto/CommonKeyDerivation.h>

@implementation Mnemonic
+ (NSArray *) generateMnemonicCode: (NSData *)random {
    if ([random length] != 16) {
        return nil;
    }

    NSData *hash = [Hash sha256: random];
    NSMutableArray *checkSumBits = [NSMutableArray arrayWithArray:[Tools dataToBitArray:hash]];
    NSMutableArray *seedBits = [NSMutableArray arrayWithArray:[Tools dataToBitArray: random]];
    for(int i = 0 ; i < (int)seedBits.count / 32 ; i++){
        [seedBits addObject:checkSumBits[i]];
    }
    
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    if ([Tools isEmpty: bundle]) {
        return nil;
    }
    NSString *resourcePath = [bundle pathForResource:@"english" ofType:@"txt"];
    if ([Tools isEmpty: resourcePath]) {
        return nil;
    }
    NSString *fileText = [NSString stringWithContentsOfFile:resourcePath encoding:NSUTF8StringEncoding error:NULL];
    NSArray *lines = [fileText componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    
    NSMutableArray *words = [NSMutableArray arrayWithCapacity:(int)seedBits.count / 11];
    for(int i = 0 ; i < (int)seedBits.count / 11 ; i++) {
        NSUInteger wordNumber = strtol([[[seedBits subarrayWithRange:NSMakeRange(i * 11, 11)] componentsJoinedByString:@""] UTF8String], NULL, 2);
        [words addObject:lines[wordNumber]];
    }
    return [words copy];
}

+ (NSData *) randomFromMnemonicCode: (NSArray *)mnemonicCodes {
    if ([Tools isEmpty: mnemonicCodes] || [mnemonicCodes count] != 12) {
        return nil;
    }
    
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    if ([Tools isEmpty: bundle]) {
        return nil;
    }
    NSString *resourcePath = [bundle pathForResource:@"english" ofType:@"txt"];
    if ([Tools isEmpty: resourcePath]) {
        return nil;
    }
    NSString *fileText = [NSString stringWithContentsOfFile:resourcePath encoding:NSUTF8StringEncoding error:NULL];
    NSArray *lines = [fileText componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    int bitLength = (int)mnemonicCodes.count * 11;
    NSMutableData* buf = [NSMutableData dataWithLength:bitLength / 8 + ((bitLength % 8) > 0 ? 1 : 0)];
    
    for (int i = 0; i < mnemonicCodes.count; i++) {
        NSString* word = mnemonicCodes[i];
        NSUInteger wordIndex = [lines indexOfObject:word];
        if (wordIndex == NSNotFound) {
            return nil;
        }
        
        [self BTCMnemonicIntegerTo11Bits: (uint8_t*)buf.mutableBytes :(i * 11) :(int)wordIndex];
    }
    NSData* entropy = [buf subdataWithRange:NSMakeRange(0, buf.length - 1)];
    
    // Calculate the checksum
    NSUInteger checksumLength = bitLength / 32;
    NSData* checksumHash = [Hash sha256: entropy];
    uint8_t checksumByte = (uint8_t) (((0xFF << (8 - checksumLength)) & 0xFF) & (0xFF & ((int) ((uint8_t*)checksumHash.bytes)[0] )));
    
    uint8_t lastByte = ((uint8_t*)buf.bytes)[buf.length - 1];
    
    // Verify the checksum
    if (lastByte != checksumByte) {
        return nil;
    }
    
    if ([Tools isEmpty: entropy]) {
        return nil;
    }
    return entropy;
}

+ (void) BTCMnemonicIntegerTo11Bits:(uint8_t *)buf :(int)bitIndex :(int)integer {
    for (int i = 0; i < 11; i++) {
        if ((integer & 0x400) == 0x400) {
            [self BTCMnemonicSetBit:buf :(bitIndex + i)];
        }
        integer = integer << 1;
    }
}

+ (void) BTCMnemonicSetBit:(uint8_t *)buf :(int)bitIndex {
    int value = ((int) buf[bitIndex / 8]) & 0xFF;
    value = value | (1 << (7 - (bitIndex % 8)));
    buf[bitIndex / 8] = (uint8_t) value;
}

+ (NSArray *) generatePrivateKeys: (NSArray *)mnemonicCodes : (NSArray *)hdPaths {
    if ([Tools isEmpty: mnemonicCodes] || [mnemonicCodes count] % 4 != 0 || [mnemonicCodes count] == 0) {
        return nil;
    }
    
    NSString *mnemonicStr = [mnemonicCodes componentsJoinedByString:@" "];
    NSData *data = [mnemonicStr dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *dataString = [[NSString alloc] initWithData: data encoding: NSASCIIStringEncoding];
    NSData *normalized = [dataString dataUsingEncoding: NSASCIIStringEncoding allowLossyConversion: NO];
    
    NSString* passwordPhrase = @"";
    NSData *saltData =
    [[@"mnemonic" stringByAppendingString: [[NSString alloc] initWithData:[passwordPhrase dataUsingEncoding: NSASCIIStringEncoding allowLossyConversion:YES] encoding:NSASCIIStringEncoding]] dataUsingEncoding: NSASCIIStringEncoding allowLossyConversion: NO];
    
    NSMutableData *hashKeyData = [NSMutableData dataWithLength:CC_SHA512_DIGEST_LENGTH];
    CCKeyDerivationPBKDF(kCCPBKDF2, normalized.bytes, normalized.length, saltData.bytes, saltData.length, kCCPRFHmacAlgSHA512, 2048, hashKeyData.mutableBytes, hashKeyData.length);
    
    NSData *seed = [NSData dataWithData:hashKeyData];
    BUChainKey *buChainKey = [[BUChainKey alloc] initWithSeed: seed];
    NSMutableArray *privateKeys = [NSMutableArray new];
    for (NSString *hdPath in hdPaths) {
        BUChainKey *buChainKeyIndex = [buChainKey derivedKeychainWithPath:hdPath];
        NSString *privateKey = [buChainKeyIndex getEncPrivateKey];
        [privateKeys addObject: privateKey];
    }
    
    return [privateKeys copy];
}

@end
