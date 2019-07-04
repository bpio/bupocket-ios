//
//  PasswordAlertView.h
//  bupocket
//
//  Created by bupocket on 2019/1/11.
//  Copyright © 2019年 bupocket. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+CustomAlertView.h"

typedef NS_ENUM(NSInteger, PasswordType) {
    PWTypeTransaction, // sign
    PWTypeBackUpID, // words ""
    PWTypeExitID, // null
    PWTypeDataReinforcement, // password, words ""
    PWTypeDeleteWallet, // null
    PWTypeExportKeystore, // null
    PWTypeExportPrivateKey, // password
};

NS_ASSUME_NONNULL_BEGIN

typedef void (^OnCancleButtonClick)(void);
typedef void (^OnSureWalletPWClick)(NSString * password, NSArray * words);

@interface PasswordAlertView : UIView

- (instancetype)initWithPrompt:(NSString *)prompt confrimBolck:(void (^)(NSString * password, NSArray * words))confrimBlock cancelBlock:(void (^)(void))cancelBlock;


@property (nonatomic, assign) NSInteger passwordType;
@property (nonatomic, assign) BOOL isAutomaticClosing;
@property (nonatomic, copy) NSString * walletKeyStore;

@property (nonatomic, strong) UITextField * PWTextField;
@property (nonatomic, strong) UIButton * closeBtn;

/** 通过keystone存储的随机数 */
@property (nonatomic, strong) NSString * randomNumber;

@end

NS_ASSUME_NONNULL_END
