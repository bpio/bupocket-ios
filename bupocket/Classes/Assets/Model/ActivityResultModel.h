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
@property (nonatomic, strong) NSString * pageTitle;
// 获奖信息
@property (nonatomic, strong) NSDictionary * latelyData;

@end

NS_ASSUME_NONNULL_END
