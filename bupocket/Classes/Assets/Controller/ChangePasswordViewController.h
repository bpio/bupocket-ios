//
//  ChangePasswordViewController.h
//  bupocket
//
//  Created by bupocket on 2018/10/19.
//  Copyright © 2018年 bupocket. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ChangePasswordViewController : BaseViewController

@property (nonatomic, strong) WalletModel * walletModel;
@property (nonatomic, strong) NSMutableArray * walletArray;
@property (nonatomic, assign) NSInteger index;

@end

NS_ASSUME_NONNULL_END
