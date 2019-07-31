//
//  TipsAlertView.h
//  bupocket
//
//  Created by bupocket on 2019/7/29.
//  Copyright © 2019 bupocket. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+CustomAlertView.h"

typedef NS_ENUM(NSInteger, TipsType) {
    TipsTypeDefault,
    TipsTypeNormal, // 图标
    TipsTypeError,
    TipsTypeChoice // 确认 取消
};

typedef void (^OnSureButtonClick)(void);

NS_ASSUME_NONNULL_BEGIN

@interface TipsAlertView : UIView

//@property (nonatomic, copy) OnCancleClick cancleBlock;
@property (nonatomic, copy) OnSureButtonClick sureBlock;

- (instancetype)initWithTipsType:(TipsType)tipsType title:(NSString *)title message:( NSString * _Nullable)message confrimBolck:(void (^ __nullable)(void))confrimBlock;

@end

NS_ASSUME_NONNULL_END
