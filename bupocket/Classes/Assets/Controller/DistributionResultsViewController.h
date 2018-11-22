//
//  DistributionResultsViewController.h
//  bupocket
//
//  Created by bupocket on 2018/10/29.
//  Copyright © 2018年 bupocket. All rights reserved.
//

#import "BaseViewController.h"
#import "DistributionModel.h"

typedef NS_ENUM(NSInteger, DistributionResultState) {
    DistributionResultSuccess,
    DistributionResultFailure,
    DistributionResultOvertime
};

NS_ASSUME_NONNULL_BEGIN

@interface DistributionResultsViewController : BaseViewController

@property (nonatomic, assign) DistributionResultState distributionResultState;
@property (nonatomic, strong) RegisteredModel * registeredModel;
@property (nonatomic, strong) DistributionModel * distributionModel;

@end

NS_ASSUME_NONNULL_END
