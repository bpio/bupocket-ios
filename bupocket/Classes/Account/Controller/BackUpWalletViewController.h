//
//  BackUpWalletViewController.h
//  bupocket
//
//  Created by bupocket on 2019/6/17.
//  Copyright © 2019 bupocket. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, MnemonicType) {
    MnemonicCreateID,
    MnemonicCreateWallet,
    MnemonicBackup,
    MnemonicExport
};

@interface BackUpWalletViewController : BaseViewController

@property (nonatomic, copy) NSArray * mnemonicArray;
@property (nonatomic, assign) MnemonicType mnemonicType;

// 导出助记词
/** 通过keystone存储的随机数 */
@property (nonatomic, strong) NSString * randomNumber;

@end

NS_ASSUME_NONNULL_END
