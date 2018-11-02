//
//  DistributionResultsViewController.h
//  bupocket
//
//  Created by bupocket on 2018/10/29.
//  Copyright © 2018年 bupocket. All rights reserved.
//

#import "BaseViewController.h"
#import "DistributionModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DistributionResultsViewController : BaseViewController

// 0 成功 1 失败 2 超时
@property (nonatomic, assign) NSInteger state;
//@property (nonatomic, strong) NSDictionary * scanDic;
//@property (nonatomic, strong) NSDictionary * assetsDic;
@property (nonatomic, strong) RegisteredModel * registeredModel;
@property (nonatomic, strong) DistributionModel * distributionModel;

@end

NS_ASSUME_NONNULL_END
