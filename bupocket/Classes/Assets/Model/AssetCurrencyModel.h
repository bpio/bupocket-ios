//
//  AssetCurrencyModel.h
//  bupocket
//
//  Created by bupocket on 2018/11/16.
//  Copyright © 2018年 bupocket. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface AssetCurrencyModel : BaseModel

typedef NS_ENUM(NSInteger, AssetCurrency) {
    AssetCurrencyCNY,
    AssetCurrencyUSD,
    AssetCurrencyJPY,
    AssetCurrencyKRW,
};
+ (NSString *)getCurrencyUnitWithAssetCurrency:(NSInteger)assetCurrency;
+ (NSString *)getAssetCurrencyTypeWithAssetCurrency:(NSInteger)assetCurrency;

@end

NS_ASSUME_NONNULL_END
