//
//  LinkAlertView.h
//  bupocket
//
//  Created by huoss on 2019/4/10.
//  Copyright © 2019年 bupocket. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+CustomAlertView.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^OnCancleButtonClick)(void);
typedef void (^OnSureUpdateClick)(void);

@interface LinkAlertView : UIView

@property (nonatomic, copy) OnCancleButtonClick cancleBlock;
@property (nonatomic, copy) OnSureUpdateClick sureBlock;

- (instancetype)initWithNodeName:(NSString *)nodeName link:(NSString *)link confrimBolck:(nonnull void (^)(void))confrimBlock cancelBlock:(nonnull void (^)(void))cancelBlock;

@end

NS_ASSUME_NONNULL_END
