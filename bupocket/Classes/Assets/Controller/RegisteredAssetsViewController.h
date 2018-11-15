//
//  RegisteredAssetsViewController.h
//  bupocket
//
//  Created by bupocket on 2018/10/29.
//  Copyright © 2018年 bupocket. All rights reserved.
//

#import "BaseViewController.h"
#import "RegisteredModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RegisteredAssetsViewController : BaseViewController

@property (nonatomic, strong) RegisteredModel * registeredModel;
@property (nonatomic, copy) NSString * uuid;

@end

NS_ASSUME_NONNULL_END
