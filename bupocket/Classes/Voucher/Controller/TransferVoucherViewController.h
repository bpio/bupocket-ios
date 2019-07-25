//
//  TransferVoucherViewController.h
//  bupocket
//
//  Created by huoss on 2019/7/15.
//  Copyright © 2019 bupocket. All rights reserved.
//

#import "BaseViewController.h"
#import "AssetsListModel.h"
#import "VoucherModel.h"

typedef NS_ENUM(NSInteger, TransferType) {
    TransferTypeAssets,
    TransferTypeVoucher
};

NS_ASSUME_NONNULL_BEGIN

@interface TransferVoucherViewController : BaseViewController

@property (assign, nonatomic) TransferType transferType;

@property (nonatomic, strong) AssetsListModel * listModel;

@property (nonatomic, strong) VoucherModel * voucherModel;
@property (nonatomic, strong) NSString * receiveAddressStr;


@end

NS_ASSUME_NONNULL_END
