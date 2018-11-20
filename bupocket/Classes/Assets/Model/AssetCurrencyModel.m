//
//  AssetCurrencyModel.m
//  bupocket
//
//  Created by bupocket on 2018/11/16.
//  Copyright © 2018年 bupocket. All rights reserved.
//

#import "AssetCurrencyModel.h"

@implementation AssetCurrencyModel

+ (NSString *)getCurrencyUnitWithAssetCurrency:(NSInteger)assetCurrency
{
    NSString * currencyUnit;
    switch (assetCurrency) {
        case AssetCurrencyCNY:
            currencyUnit = @"¥";
            break;
            case AssetCurrencyUSD:
            currencyUnit = @"$";
            break;
            case AssetCurrencyJPY:
            currencyUnit = @"¥";
            break;
            case AssetCurrencyKRW:
            currencyUnit = @"₩";
            break;
            
        default:
            break;
    }
    return currencyUnit;
}
+ (NSString *)getAssetCurrencyTypeWithAssetCurrency:(NSInteger)assetCurrency
{
    NSString * currencyUnit;
    switch (assetCurrency) {
        case AssetCurrencyCNY:
            currencyUnit = @"CNY";
            break;
        case AssetCurrencyUSD:
            currencyUnit = @"USD";
            break;
        case AssetCurrencyJPY:
            currencyUnit = @"JPY";
            break;
        case AssetCurrencyKRW:
            currencyUnit = @"KRW";
            break;
            
        default:
            break;
    }
    return currencyUnit;
}

@end
