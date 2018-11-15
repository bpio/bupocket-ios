//
//  CreateTipsAlertView.h
//  bupocket
//
//  Created by bupocket on 2018/11/14.
//  Copyright © 2018年 bupocket. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+CustomAlertView.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^OnSureButtonClick)(void);

@interface CreateTipsAlertView : UIView

@property (nonatomic, copy) OnSureButtonClick sureBlock;

- (instancetype)initWithConfrimBolck:(nonnull void (^)(void))confrimBlock;

@end

NS_ASSUME_NONNULL_END
