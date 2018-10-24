//
//  HTTPManager.h
//  TheImperialPalaceMuseum
//
//  Created by 霍双双 on 17/2/25.
//  Copyright © 2017年 hss. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTTPManager : NSObject

+ (HTTPManager *)shareManager;

// Assets
+ (void)getAssetsDataWithAddress:(NSString *)address
                    currencyType:(NSString *)currencyType
                       tokenList:(NSArray *)tokenList
                         success:(void (^)(id responseObject))success
                         failure:(void (^)(NSError *error))failure;
// AssetsDetail Transaction_Record
+ (void)getAssetsDetailDataWithAssetCode:(NSString *)assetCode
                                  issuer:(NSString *)issuer
                                 address:(NSString *)address
                               pageIndex:(NSInteger)pageIndex
                                 success:(void (^)(id responseObject))success
                                 failure:(void (^)(NSError *error))failure;
// OrderDetails
+ (void)getOrderDetailsDataWithHash:(NSString *)hash
                            success:(void (^)(id responseObject))success
                            failure:(void (^)(NSError *error))failure;

@end
