//
//  ActivityResultModel.h
//  bupocket
//
//  Created by huoss on 2019/8/4.
//  Copyright © 2019 bupocket. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ActivityResultModel : BaseModel

@property (nonatomic, strong) NSDictionary * bonusInfo;
@property (nonatomic, strong) NSDictionary * activityRules;
// 七夕幸运儿
@property (nonatomic, strong) NSString * label;
// 获奖信息
@property (nonatomic, strong) NSDictionary * latelyData;

@end

NS_ASSUME_NONNULL_END
