//
//  TransferAccountsViewController.h
//  bupocket
//
//  Created by bupocket on 2018/10/22.
//  Copyright © 2018年 bupocket. All rights reserved.
//

#import "BaseViewController.h"
#import "AssetsListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TransferAccountsViewController : BaseViewController

@property (nonatomic, strong) AssetsListModel * listModel;
@property (nonatomic, strong) NSString * address;

@end

NS_ASSUME_NONNULL_END
