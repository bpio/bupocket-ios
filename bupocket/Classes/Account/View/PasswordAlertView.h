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
    PasswordBackupType,
    PasswordTurnOutType,
    PasswordWarnType
};

NS_ASSUME_NONNULL_BEGIN

typedef void (^OnCancleButtonClick)(void);
typedef void (^OnSureWalletPWClick)(NSString * password, NSArray * words);

@interface PasswordAlertView : UIView

- (instancetype)initWithPrompt:(NSString *)prompt walletKeyStore:(NSString *)walletKeyStore isAutomaticClosing:(BOOL)isAutomaticClosing confrimBolck:(void (^)(NSString * password, NSArray * words))confrimBlock cancelBlock:(void (^)(void))cancelBlock;

@end

NS_ASSUME_NONNULL_END
