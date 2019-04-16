//
//  ConfirmTransactionAlertView.h
//  bupocket
//
//  Created by huoss on 2019/3/30.
//  Copyright © 2019年 bupocket. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+CustomAlertView.h"
#import "ConfirmTransactionModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^OnCancleClick)(void);
typedef void (^OnSureClick)(NSString * transactionCost);

@interface ConfirmTransactionAlertView : UIView

@property (nonatomic, copy) OnCancleClick cancleBlock;
@property (nonatomic, copy) OnSureClick sureBlock;
@property (nonatomic, strong) ConfirmTransactionModel * confirmTransactionModel;

- (instancetype)initWithDpos:(ConfirmTransactionModel *)confirmTransactionModel confrimBolck:(void (^)(NSString * transactionCost))confrimBlock cancelBlock:(void (^)(void))cancelBlock;

@end

NS_ASSUME_NONNULL_END
