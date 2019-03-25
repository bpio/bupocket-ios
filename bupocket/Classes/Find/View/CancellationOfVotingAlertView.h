//
//  CancellationOfVotingAlertView.h
//  bupocket
//
//  Created by huoss on 2019/3/25.
//  Copyright © 2019年 bupocket. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+CustomAlertView.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^OnCancleClick)(void);
typedef void (^OnSureClick)(NSString * text);

@interface CancellationOfVotingAlertView : UIView


@property (nonatomic, copy) OnCancleClick cancleBlock;
@property (nonatomic, copy) OnSureClick sureBlock;

- (instancetype)initWithText:(NSString *)text confrimBolck:(void (^)(NSString * text))confrimBlock cancelBlock:(void (^)(void))cancelBlock;

@end

NS_ASSUME_NONNULL_END
