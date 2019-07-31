//
//  VoucherViewController.h
//  bupocket
//
//  Created by bupocket on 2019/6/29.
//  Copyright © 2019 bupocket. All rights reserved.
//

#import "BaseViewController.h"
#import "VoucherModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface VoucherViewController : BaseViewController

@property (nonatomic, copy) void (^voucher)(VoucherModel *);
@property (nonatomic, assign) BOOL isChoiceVouchers;
@property (nonatomic, copy) NSString * voucherId;

@end

NS_ASSUME_NONNULL_END
