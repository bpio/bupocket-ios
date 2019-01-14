//
//  WalletAddressAlertView.h
//  bupocket
//
//  Created by huoss on 2019/1/11.
//  Copyright © 2019年 bupocket. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+CustomAlertView.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^OnCancleButtonClick)(void);
typedef void (^OnSureButtonClick)(void);

@interface WalletAddressAlertView : UIView

@property (nonatomic, copy) OnCancleButtonClick cancleBlock;
@property (nonatomic, copy) OnSureButtonClick sureBlock;

- (instancetype)initWithWalletAddress:(NSString *)walletAddress confrimBolck:(nonnull void (^)(void))confrimBlock cancelBlock:(nonnull void (^)(void))cancelBlock;

@end

NS_ASSUME_NONNULL_END
