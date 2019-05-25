//
//  AdsModel.h
//  bupocket
//
//  Created by bupocket on 2019/4/22.
//  Copyright © 2019年 bupocket. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface AdsModel : BaseModel

@property (nonatomic, copy) NSString * type; // 1: App 2: H5
@property (nonatomic, copy) NSString * url;
@property (nonatomic, copy) NSString * imageUrl;

@end

NS_ASSUME_NONNULL_END
