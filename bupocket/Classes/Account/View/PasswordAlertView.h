//
//  PasswordAlertView.h
//  bupocket
//
//  Created by huoss on 2019/1/11.
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

@property (nonatomic, copy) OnCancleButtonClick cancleBlock;
@property (nonatomic, copy) OnSureWalletPWClick sureBlock;
@property (nonatomic, assign) BOOL isAutomaticClosing;

- (instancetype)initWithPrompt:(NSString *)prompt isAutomaticClosing:(BOOL)isAutomaticClosing confrimBolck:(void (^)(NSString * password, NSArray * words))confrimBlock cancelBlock:(void (^)(void))cancelBlock;

@end

NS_ASSUME_NONNULL_END
