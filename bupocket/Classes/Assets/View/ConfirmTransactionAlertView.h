//
//  ConfirmTransactionAlertView.h
//  bupocket
//
//  Created by bupocket on 2019/3/30.
//  Copyright © 2019年 bupocket. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+CustomAlertView.h"
#import "ConfirmTransactionModel.h"
#import "DposModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^OnCancleClick)(void);
typedef void (^OnConfirmClick)(NSString * transactionCost);

@interface ConfirmTransactionAlertView : UIView

@property (nonatomic, copy) OnCancleClick cancleBlock;
@property (nonatomic, copy) OnConfirmClick sureBlock;
@property (nonatomic, strong) ConfirmTransactionModel * confirmTransactionModel;
@property (nonatomic, strong) DposModel * dposModel;

- (instancetype)initWithDposConfrimBolck:(void (^)(NSString * transactionCost))confrimBlock cancelBlock:(void (^)(void))cancelBlock;

@end

NS_ASSUME_NONNULL_END
