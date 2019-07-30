//
//  TextInputAlertView.h
//  bupocket
//
//  Created by huoss on 2019/7/30.
//  Copyright © 2019 bupocket. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+CustomAlertView.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, InputType) {
    InputTypeWalletName,
    InputTypeNodeAdd,
    InputTypeNodeEdit,
    PWTypeTransferAssets, // sign
    PWTypeTransferVoucher,
    PWTypeTransferRegistered,
    PWTypeTransferDistribution,
    PWTypeTransferDpos,
    PWTypeBackUpID, // words ""
    PWTypeExitID, // null
    PWTypeDataReinforcement, // password, words ""
    PWTypeDeleteWallet, // null
    PWTypeExportKeystore, // null
    PWTypeExportPrivateKey, // password
};

typedef void (^OnCancleClick)(void);
typedef void (^OnSureClick)(NSString * text, NSArray * words);

@interface TextInputAlertView : UIView

@property (nonatomic, copy) OnCancleClick cancleBlock;
@property (nonatomic, copy) OnSureClick sureBlock;
@property (nonatomic, strong) NSString * text;

// PW
@property (nonatomic, strong) UITextField * textField;
//@property (nonatomic, assign) BOOL isAutomaticClosing;
@property (nonatomic, copy) NSString * walletKeyStore;
/** 通过keystone存储的随机数 */
@property (nonatomic, strong) NSString * randomNumber;

- (instancetype)initWithInputType:(InputType)inputType confrimBolck:(void (^)(NSString * text, NSArray * words))confrimBlock cancelBlock:(void (^)(void))cancelBlock;

@end

NS_ASSUME_NONNULL_END
