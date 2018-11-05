//
//  SearchAssetsModel.h
//  bupocket
//
//  Created by bubi on 2018/11/5.
//  Copyright © 2018年 bupocket. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SearchAssetsModel : BaseModel

@property (nonatomic, copy) NSString * assetCode;
@property (nonatomic, copy) NSString * assetName;
@property (nonatomic, copy) NSString * icon;
@property (nonatomic, copy) NSString * issuer;
@property (nonatomic, assign) NSInteger recommend;
@property (nonatomic, assign) NSInteger type;

@end

NS_ASSUME_NONNULL_END
