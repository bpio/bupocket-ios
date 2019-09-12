//
//  NodeVotingAlertView.h
//  bupocket
//
//  Created by huoss on 2019/8/28.
//  Copyright © 2019 bupocket. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+CustomAlertView.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^OnCancleClick)(void);
typedef void (^OnConfirmClick)(NSString * text);

@interface NodeVotingAlertView : UIView

@property (nonatomic, copy) OnCancleClick cancleClick;
@property (nonatomic, copy) OnConfirmClick confirmClick;

- (instancetype)initWithVoteAmountNumber:(NSDecimalNumber * )amountNumber confrimBolck:(void (^)(NSString * text))confrimBlock cancelBlock:(void (^)(void))cancelBlock;

@end

NS_ASSUME_NONNULL_END
