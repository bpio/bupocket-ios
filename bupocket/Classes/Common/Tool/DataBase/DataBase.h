//
//  DataBase.h
//  bupocket
//
//  Created by huoss on 2019/8/13.
//  Copyright © 2019 bupocket. All rights reserved.
//

#import "BaseModel.h"

typedef NS_ENUM(NSInteger, CacheDataType) {
    CacheTypeAssets,
    CacheTypeTransactionRecord,
    CacheTypeTransactionDetails,
    CacheTypeAddressBook,
    CacheTypeVoucherList,
    CacheTypeVoucherDetail,
    CacheTypeFindBanner,
    CacheTypeNodeList,
    CacheTypeCooperateList,
    CacheTypeVersionLogList
};

NS_ASSUME_NONNULL_BEGIN

@interface DataBase : BaseModel

+ (instancetype)shareDataBase;

- (void)clearCache;

- (void)saveDataWithArray:(NSArray *)array cacheType:(CacheDataType)cacheType;
- (NSArray *)getCachedDataWithCacheType:(CacheDataType)cacheType;
- (void)deleteCachedDataWithCacheType:(CacheDataType)cacheType;

// Transaction Details
- (void)saveDetailDataWithCacheType:(CacheDataType)cacheType dic:(NSDictionary *)dic ID:(NSString *)ID;
- (NSDictionary *)getDetailCachedDataWithCacheType:(CacheDataType)cacheType detailId:(NSString *)detailId;
- (void)deleteTxDetailsCachedDataWithCacheType:(CacheDataType)cacheType detailId:(NSString *)detailId;

@end

NS_ASSUME_NONNULL_END
