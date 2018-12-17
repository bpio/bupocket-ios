//
//  RegisteredResultViewController.h
//  bupocket
//
//  Created by bupocket on 2018/10/29.
//  Copyright © 2018年 bupocket. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, RegisteredResultState) {
    RegisteredResultSuccess,
    RegisteredResultFailure,
    RegisteredResultOvertime
};

@interface RegisteredResultViewController : BaseViewController

@property (nonatomic, assign) RegisteredResultState registeredResultState;
@property (nonatomic, strong) RegisteredModel * registeredModel;
@property (nonatomic, strong) NSMutableArray * listArray;

@end

NS_ASSUME_NONNULL_END
