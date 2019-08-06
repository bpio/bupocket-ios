//
//  OpenRedEnvelopes.h
//  bupocket
//
//  Created by huoss on 2019/8/3.
//  Copyright © 2019 bupocket. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+CustomAlertView.h"

typedef NS_ENUM(NSInteger, OpenRedEnvelopesType) {
    OpenRedEnvelopesDefault, // 开
    OpenRedEnvelopesNormal, // 已领完
};

NS_ASSUME_NONNULL_BEGIN

typedef void (^OnCancleButtonClick)(void);
typedef void (^OnSureOpenClick)(id responseObject);

@interface OpenRedEnvelopes : UIView

@property (nonatomic, copy) OnCancleButtonClick cancleBlock;
@property (nonatomic, copy) OnSureOpenClick sureBlock;

- (instancetype)initWithOpenType:(OpenRedEnvelopesType)openType redEnvelopes:(NSString *)redEnvelopes activityID:(NSString *)activityID confrimBolck:(nonnull void (^)(id responseObject))confrimBlock cancelBlock:(nonnull void (^)(void))cancelBlock;
@end

NS_ASSUME_NONNULL_END
