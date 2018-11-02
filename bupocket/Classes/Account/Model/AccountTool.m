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

/**
 *  存储帐号
 */
+ (void)save:(AccountModel *)account
{
    // 归档
    [NSKeyedArchiver archiveRootObject:account toFile:AccountFilePath];
}

/**
 *  读取帐号
 */
+ (AccountModel *)account
{
    return [NSKeyedUnarchiver unarchiveObjectWithFile:AccountFilePath];
}

/**
 *  清除path文件夹下缓存
 */
+ (BOOL)clearCache
{
    NSArray *subPathArr = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:AccountFilePath error:nil];
    NSString *filePath = nil;
    NSError *error = nil;
    for (NSString *subPath in subPathArr) {
        filePath = [AccountFilePath stringByAppendingPathComponent:subPath];
        //删除子文件夹
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
        if (error) {
            return NO;
        }
    }
    return YES;
}
@end
