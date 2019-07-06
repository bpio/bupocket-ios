//
//  DonateVoucherViewController.h
//  bupocket
//
//  Created by huoss on 2019/7/6.
//  Copyright © 2019 bupocket. All rights reserved.
//

#import "BaseViewController.h"
#import "VoucherModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DonateVoucherViewController : BaseViewController

@property (nonatomic, strong) VoucherModel * voucherModel;
@property (nonatomic, strong) NSString * receiveAddressStr;

@end

NS_ASSUME_NONNULL_END
