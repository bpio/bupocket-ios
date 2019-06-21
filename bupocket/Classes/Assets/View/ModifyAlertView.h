//
//  ModifyAlertView.h
//  bupocket
//
//  Created by bupocket on 2019/1/8.
//  Copyright © 2019年 bupocket. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+CustomAlertView.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, ModifyType) {
    ModifyTypeWalletName,
    ModifyTypeNodeAdd,
    ModifyTypeNodeEdit
};

typedef void (^OnCancleClick)(void);
typedef void (^OnSureClick)(NSString * text);

@interface ModifyAlertView : UIView

@property (nonatomic, copy) OnCancleClick cancleBlock;
@property (nonatomic, copy) OnSureClick sureBlock;

- (instancetype)initWithTitle:(NSString *)title placeholder:(NSString *)placeholder modifyType:(ModifyType)modifyType confrimBolck:(void (^)(NSString * text))confrimBlock cancelBlock:(void (^)(void))cancelBlock;

@end

NS_ASSUME_NONNULL_END
