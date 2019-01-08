//
//  ModifyAlertView.h
//  bupocket
//
//  Created by huoss on 2019/1/8.
//  Copyright © 2019年 bupocket. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+CustomAlertView.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^OnCancleButtonClick)(void);
typedef void (^OnSureButtonClick)(NSString * text);

@interface ModifyAlertView : UIView

@property (nonatomic, copy) OnCancleButtonClick cancleBlock;
@property (nonatomic, copy) OnSureButtonClick sureBlock;

- (instancetype)initWithText:(NSString *)text confrimBolck:(void (^)(NSString * text))confrimBlock cancelBlock:(void (^)(void))cancelBlock;

@end

NS_ASSUME_NONNULL_END
