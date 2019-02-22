//
//  SafetyReinforcementAlertView.h
//  bupocket
//
//  Created by bupocket on 2019/1/11.
//  Copyright © 2019年 bupocket. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+CustomAlertView.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^OnSureClick)(void);

@interface SafetyReinforcementAlertView : UIView

@property (nonatomic, copy) OnSureClick sureBlock;

- (instancetype)initWithTitle:(NSString *)title promptText:(NSString *)promptText confrim:(NSString *)confrim confrimBolck:(nonnull void (^)(void))confrimBlock;


@end

NS_ASSUME_NONNULL_END
