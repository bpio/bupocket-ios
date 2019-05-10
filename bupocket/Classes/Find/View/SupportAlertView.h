//
//  SupportAlertView.h
//  bupocket
//
//  Created by bupocket on 2019/4/8.
//  Copyright © 2019年 bupocket. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+CustomAlertView.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^OnCancleClick)(void);
typedef void (^OnConfirmClick)(NSString * text);

@interface SupportAlertView : UIView

@property (nonatomic, copy) OnCancleClick cancleClick;
@property (nonatomic, copy) OnConfirmClick confirmClick;

- (instancetype)initWithTotalTarget:(NSString *)totalTarget purchaseAmount:(NSString *)purchaseAmount confrimBolck:(void (^)(NSString * text))confrimBlock cancelBlock:(void (^)(void))cancelBlock;

@end

NS_ASSUME_NONNULL_END
