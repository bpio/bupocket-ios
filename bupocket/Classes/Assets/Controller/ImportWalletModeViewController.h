//
//  ImportWalletModeViewController.h
//  bupocket
//
//  Created by bupocket on 2019/1/9.
//  Copyright © 2019年 bupocket. All rights reserved.
//

#import "BaseViewController.h"

typedef NS_ENUM(NSInteger, ImportWalletMode) {
    ImportWalletMnemonics,
    ImportWalletPrivateKey,
    ImportWalletKeystore
};

NS_ASSUME_NONNULL_BEGIN

@interface ImportWalletModeViewController : BaseViewController

@property (assign, nonatomic) ImportWalletMode importWalletMode;

@end

NS_ASSUME_NONNULL_END
