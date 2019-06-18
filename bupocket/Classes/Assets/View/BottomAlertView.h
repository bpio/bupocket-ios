//
//  BottomAlertView.h
//  bupocket
//
//  Created by huoss on 2019/6/18.
//  Copyright © 2019 bupocket. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+CustomAlertView.h"

typedef NS_ENUM(NSInteger, HandlerType) {
    HandlerTypeWallet,
    HandlerTypeNode
};

NS_ASSUME_NONNULL_BEGIN

typedef void (^OnCancleClick)(void);
typedef void (^OnHandlerClick)(UIButton * btn);

@interface BottomAlertView : UIView

@property (nonatomic, copy) OnCancleClick cancleClick;
@property (nonatomic, copy) OnHandlerClick handlerClick;

- (instancetype)initWithHandlerArray:(NSArray *)array handlerType:(HandlerType)handlerType handlerClick:(void (^)(UIButton * btn))handlerClick cancleClick:(void (^)(void))cancleClick;

@end

NS_ASSUME_NONNULL_END
