//
//  ActivityAwardsModel.h
//  bupocket
//
//  Created by huoss on 2019/8/4.
//  Copyright © 2019 bupocket. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ActivityAwardsModel : BaseModel

@property (nonatomic, copy) NSString * receiver;
@property (nonatomic, copy) NSString * date;
@property (nonatomic, copy) NSString * amount;
@property (nonatomic, copy) NSString * tokenSymbol;
// 最佳标识：0 否 1是
@property (nonatomic, copy) NSString * mvpFlag;

@end

NS_ASSUME_NONNULL_END
