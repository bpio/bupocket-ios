//
//  VoteAlertView.h
//  bupocket
//
//  Created by huoss on 2019/3/22.
//  Copyright © 2019年 bupocket. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+CustomAlertView.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^OnCancleButtonClick)(void);
typedef void (^ConfirmButtonClick)(void);

@interface VoteAlertView : UIView

@property (nonatomic, copy) OnCancleButtonClick cancleBlock;
@property (nonatomic, copy) ConfirmButtonClick sureBlock;

- (instancetype)initWithTransferInfoArray:(NSArray *)transferInfoArray confrimBolck:(nonnull void (^)(void))confrimBlock cancelBlock:(nonnull void (^)(void))cancelBlock;

@end

NS_ASSUME_NONNULL_END
