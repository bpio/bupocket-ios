//
//  BottomConfirmAlertView.h
//  bupocket
//
//  Created by huoss on 2019/7/4.
//  Copyright © 2019 bupocket. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+CustomAlertView.h"
#import "ConfirmTransactionModel.h"
#import "DposModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, HandlerType) {
    HandlerTypeTransferAssets,
    HandlerTypeTransferDpos,
    HandlerTypeTransferDposCommand,
    HandlerTypeTransferVoucher
};

typedef void (^OnCancleClick)(void);
typedef void (^OnSureClick)(void);

@interface BottomConfirmAlertView : UIView

@property (nonatomic, strong) UILabel * title;

@property (nonatomic, copy) OnCancleClick cancleBlock;
@property (nonatomic, copy) OnSureClick sureBlock;
@property (nonatomic, strong) DposModel * dposModel;

- (instancetype)initWithIsShowValue:(BOOL)isShowValue handlerType:(HandlerType)handlerType confirmModel:(ConfirmTransactionModel *)confirmModel confrimBolck:(void (^)(void))confrimBlock cancelBlock:(void (^)(void))cancelBlock;

@end

NS_ASSUME_NONNULL_END
