//
//  TransactionDetailsViewController.h
//  bupocket
//
//  Created by bupocket on 2019/7/24.
//  Copyright © 2019 bupocket. All rights reserved.
//

#import "BaseViewController.h"
#import "AssetsDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TransactionDetailsViewController : BaseViewController

@property (nonatomic, strong) AssetsDetailModel * listModel;
@property (nonatomic, copy) NSString * assetCode;

@end

NS_ASSUME_NONNULL_END
