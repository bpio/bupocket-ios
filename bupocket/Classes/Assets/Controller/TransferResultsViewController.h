//
//  TransferResultsViewController.h
//  bupocket
//
//  Created by bupocket on 2018/10/22.
//  Copyright © 2018年 bupocket. All rights reserved.
//

#import "BaseViewController.h"
#import "ConfirmTransactionModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TransferResultsViewController : BaseViewController

@property (nonatomic, strong) NSMutableArray * transferInfoArray;
@property (nonatomic, assign) BOOL state;

@property (nonatomic, strong) TransactionResultModel * resultModel;
@property (nonatomic, strong) ConfirmTransactionModel * confirmTransactionModel;

@end

NS_ASSUME_NONNULL_END
