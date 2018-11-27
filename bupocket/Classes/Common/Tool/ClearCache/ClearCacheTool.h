//
//  ClearCacheTool.h
//  bupocket
//
//  Created by bupocket on 17/5/18.
//  Copyright © 2017年 bupocket. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^CleanCacheBlock)(void);

@interface ClearCacheTool : NSObject

/**
 *  清理缓存
 */
+ (void)cleanCache:(CleanCacheBlock)block;

/**
 *  整个缓存目录的大小
 */
+ (float)folderSizeAtPath;

+ (void)cleanUserDefaults;


@end
