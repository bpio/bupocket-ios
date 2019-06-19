//
//  WalletDetailsViewController.h
//  bupocket
//
//  Created by huoss on 2019/6/18.
//  Copyright © 2019 bupocket. All rights reserved.
//

#import "BaseViewController.h"

typedef void (^ReturnValueBlock) (UIImage * walletIcon, NSString * walletName);

NS_ASSUME_NONNULL_BEGIN

@interface WalletDetailsViewController : BaseViewController

@property(nonatomic, copy) ReturnValueBlock returnValueBlock;
@property (nonatomic, strong) UIImage * walletIcon;
@property (nonatomic, strong) WalletModel * walletModel;
@property (nonatomic, strong) NSMutableArray * walletArray;
@property (nonatomic, assign) NSInteger index;

@end

NS_ASSUME_NONNULL_END
