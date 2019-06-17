//
//  WalletManagementViewController.h
//  bupocket
//
//  Created by huoss on 2019/6/14.
//  Copyright © 2019 bupocket. All rights reserved.
//

#import "BaseViewController.h"
#import "WalletModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface WalletManagementViewController : BaseViewController

@property (nonatomic, strong) WalletModel * walletModel;
@property (nonatomic, strong) NSMutableArray * walletArray;
@property (nonatomic, assign) NSInteger index;

@end

NS_ASSUME_NONNULL_END
