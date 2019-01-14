//
//  ExportPrivateKeyViewController.h
//  bupocket
//
//  Created by huoss on 2019/1/8.
//  Copyright © 2019年 bupocket. All rights reserved.
//

#import "BaseViewController.h"
#import "WalletModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ExportPrivateKeyViewController : BaseViewController

@property (nonatomic, strong) WalletModel * walletModel;
@property (nonatomic, strong) NSString * password;

@end

NS_ASSUME_NONNULL_END
