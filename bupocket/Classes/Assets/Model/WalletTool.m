//
//  WalletTool.m
//  bupocket
//
//  Created by huoss on 2019/1/11.
//  Copyright © 2019年 bupocket. All rights reserved.
//

#import "WalletTool.h"

#define WalletFilePath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"wallet.data"]

@implementation WalletTool

static WalletTool * _shareTool = nil;

+ (instancetype)shareTool
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!_shareTool) {
            _shareTool = [[WalletTool alloc] init];
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

- (void)save:(NSArray *)walletArray
{
    [NSKeyedArchiver archiveRootObject:walletArray toFile:WalletFilePath];
}

- (NSArray *)walletArray
{
    return [NSKeyedUnarchiver unarchiveObjectWithFile:WalletFilePath];
}
- (void)clearCache
{
    if ([[NSFileManager defaultManager] isDeletableFileAtPath:WalletFilePath]) {
        [[NSFileManager defaultManager] removeItemAtPath:WalletFilePath error:nil];
    }
//    if ([fileManager fileExistsAtPath:WalletFilePath]) {
//        [fileManager removeItemAtPath:WalletFilePath error:nil];
//        NSArray * childerFiles = [fileManager subpathsAtPath:WalletFilePath];
//        for (NSString *fileName in childerFiles) {
//            //如有需要，加入条件，过滤掉不想删除的文件
//            NSString * absolutePath = [WalletFilePath stringByAppendingPathComponent:fileName];
//        }
//    }
}

@end
