//
//  BackupMnemonicsViewController.h
//  bupocket
//
//  Created by bupocket on 2018/10/16.
//  Copyright © 2018年 bupocket. All rights reserved.
//

#import "BaseViewController.h"
#import "BackUpWalletViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface BackupMnemonicsViewController : BaseViewController

@property (nonatomic, copy) NSArray * mnemonicArray;
@property (nonatomic, assign) MnemonicType mnemonicType;

@end

NS_ASSUME_NONNULL_END
