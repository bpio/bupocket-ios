//
//  DataBase.h
//  bupocket
//
//  Created by huoss on 2019/8/13.
//  Copyright © 2019 bupocket. All rights reserved.
//

#import "BaseModel.h"

typedef NS_ENUM(NSInteger, CacheDataType) {
    CacheTypeAddressBook,
    CacheTypeVoucherList,
    CacheTypeFindBanner,
    CacheTypeNodeList,
    CacheTypeCooperateList,
    CacheTypeVersionLogList
};

NS_ASSUME_NONNULL_BEGIN

@interface DataBase : BaseModel

+ (instancetype)shareDataBase;

- (void)saveDataWithArray:(NSArray *)array cacheType:(CacheDataType)cacheType;
- (NSArray *)getCachedDataWithCacheType:(CacheDataType)cacheType;
- (void)deleteCachedDataWithCacheType:(CacheDataType)cacheType;

@end

NS_ASSUME_NONNULL_END
