//
//  PurseCipherAlertView.h
//  bupocket
//
//  Created by bupocket on 2018/10/18.
//  Copyright © 2018年 bupocket. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+CustomAlertView.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^OnCancleButtonClick)(void);
typedef void (^OnSureButtonClick)(void);

@interface PurseCipherAlertView : UIView

@property (nonatomic, copy) OnCancleButtonClick cancleBlock;
@property (nonatomic, copy) OnSureButtonClick sureBlock;

- (instancetype)initWithFrame:(CGRect)frame confrimBolck:(void (^)(void))confrimBlock cancelBlock:(void (^)(void))cancelBlock;

@end

NS_ASSUME_NONNULL_END
