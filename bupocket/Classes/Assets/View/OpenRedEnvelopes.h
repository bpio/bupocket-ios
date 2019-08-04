//
//  OpenRedEnvelopes.h
//  bupocket
//
//  Created by huoss on 2019/8/3.
//  Copyright © 2019 bupocket. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+CustomAlertView.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^OnCancleButtonClick)(void);
typedef void (^OnSureUpdateClick)(void);

@interface OpenRedEnvelopes : UIView

@property (nonatomic, copy) OnCancleButtonClick cancleBlock;
@property (nonatomic, copy) OnSureUpdateClick sureBlock;

- (instancetype)initWithRedEnvelopes:(NSString *)redEnvelopes confrimBolck:(nonnull void (^)(void))confrimBlock cancelBlock:(nonnull void (^)(void))cancelBlock;
@end

NS_ASSUME_NONNULL_END
