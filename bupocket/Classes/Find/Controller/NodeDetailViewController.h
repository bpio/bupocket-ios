//
//  NodeDetailViewController.h
//  bupocket
//
//  Created by huoss on 2019/8/26.
//  Copyright © 2019 bupocket. All rights reserved.
//

#import "BaseViewController.h"
#import "NodePlanModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface NodeDetailViewController : BaseViewController

@property (nonatomic, strong) NodePlanModel * nodePlanModel;
@property (nonatomic, copy) NSString * contractAddress;
@property (nonatomic, copy) NSString * accountTag;
@property (nonatomic, copy) NSString * accountTagEn;

@end

NS_ASSUME_NONNULL_END
