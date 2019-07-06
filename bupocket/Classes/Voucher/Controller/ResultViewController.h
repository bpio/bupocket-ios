//
//  ResultViewController.h
//  bupocket
//
//  Created by huoss on 2019/7/5.
//  Copyright © 2019 bupocket. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ResultViewController : BaseViewController

@property (nonatomic, assign) BOOL state;
@property (nonatomic, strong) TransactionResultModel * resultModel;
@property (nonatomic, strong) ConfirmTransactionModel * confirmTransactionModel;

@end

NS_ASSUME_NONNULL_END
