//
//  AccountTool.m
//  bupocket
//
//  Created by bupocket on 2018/10/26.
//  Copyright © 2018年 bupocket. All rights reserved.
//

#import "AccountTool.h"

#define AccountFilePath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"account.data"]

@implementation AccountTool

+ (void)save:(AccountModel *)account
{
    [NSKeyedArchiver archiveRootObject:account toFile:AccountFilePath];
}

+ (AccountModel *)account
{
    return [NSKeyedUnarchiver unarchiveObjectWithFile:AccountFilePath];
}

+ (BOOL)clearCache
{
    NSArray *subPathArr = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:AccountFilePath error:nil];
    NSString *filePath = nil;
    NSError *error = nil;
    for (NSString *subPath in subPathArr) {
        filePath = [AccountFilePath stringByAppendingPathComponent:subPath];
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
        if (error) {
            return NO;
        }
    }
    return YES;
}
@end
