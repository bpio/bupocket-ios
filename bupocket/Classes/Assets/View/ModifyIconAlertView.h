//
//  ModifyIconAlertView.h
//  bupocket
//
//  Created by huoss on 2019/6/25.
//  Copyright © 2019 bupocket. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+CustomAlertView.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^OnCancleClick)(void);
typedef void (^OnConfrimClick)(NSInteger index);

@interface ModifyIconAlertView : UIView

@property (nonatomic, copy) OnCancleClick cancleBlock;
@property (nonatomic, copy) OnConfrimClick sureBlock;

@property (nonatomic, assign) NSInteger index;

- (instancetype)initWithTitle:(NSString *)title confrimBolck:(void (^)(NSInteger index))confrimBlock cancelBlock:(void (^)(void))cancelBlock;

@end

NS_ASSUME_NONNULL_END
