//
//  AtpProperty.h
//  bupocket
//
//  Created by bubi on 2018/11/1.
//  Copyright © 2018年 bupocket. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface AtpProperty : BaseModel

@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * code;
@property (nonatomic, assign) int64_t totalSupply;
@property (nonatomic, assign) NSInteger decimals;
@property (nonatomic, copy) NSString * Description;
@property (nonatomic, copy) NSString * icon;
@property (nonatomic, copy) NSString * version;

@end

NS_ASSUME_NONNULL_END
