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

static AccountTool * _shareTool = nil;

+ (instancetype)shareTool
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!_shareTool) {
            _shareTool = [[AccountTool alloc] init];
        }
    });
    return _shareTool;
}
+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shareTool = [super allocWithZone:zone];
    });
    return _shareTool;
}


- (void)save:(AccountModel *)account
{
    [NSKeyedArchiver archiveRootObject:account toFile:AccountFilePath];
}

- (AccountModel *)account
{
    return [NSKeyedUnarchiver unarchiveObjectWithFile:AccountFilePath];
}

- (void)clearCache
{
    if ([[NSFileManager defaultManager] isDeletableFileAtPath:AccountFilePath]) {
        [[NSFileManager defaultManager] removeItemAtPath:AccountFilePath error:nil];
    }
}
@end
