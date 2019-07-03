//
//  ConfirmMnemonicViewController.h
//  bupocket
//
//  Created by bupocket on 2018/10/19.
//  Copyright © 2018年 bupocket. All rights reserved.
//

#import "BaseViewController.h"
#import "BackUpWalletViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ConfirmMnemonicViewController : BaseViewController

@property (nonatomic, strong) NSArray * mnemonicArray;
@property (nonatomic, assign) MnemonicType mnemonicType;

@end

NS_ASSUME_NONNULL_END
