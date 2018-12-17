//
//  AssetsListModel.h
//  bupocket
//
//  Created by bupocket on 2018/10/23.
//  Copyright © 2018年 bupocket. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface AssetsListModel : BaseModel

@property (nonatomic, copy) NSString * amount;
@property (nonatomic, copy) NSString * assetAmount;
@property (nonatomic, copy) NSString * assetCode;
@property (nonatomic, assign) NSInteger decimals;
@property (nonatomic, copy) NSString * icon;
@property (nonatomic, copy) NSString * issuer;
@property (nonatomic, copy) NSString * price;
@property (nonatomic, assign) NSInteger type;

@end

NS_ASSUME_NONNULL_END
