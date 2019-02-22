//
//  ExportViewController.h
//  bupocket
//
//  Created by bupocket on 2019/1/7.
//  Copyright © 2019年 bupocket. All rights reserved.
//

#import "BaseViewController.h"
#import "WalletModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ExportViewController : BaseViewController

@property (nonatomic, strong) WalletModel * walletModel;
@property (nonatomic, strong) NSMutableArray * walletArray;
@property (nonatomic, assign) NSInteger index;

@end

NS_ASSUME_NONNULL_END
