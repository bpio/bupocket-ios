//
//  VersionUpdateAlertView.h
//  bupocket
//
//  Created by bupocket on 2018/11/13.
//  Copyright © 2018年 bupocket. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+CustomAlertView.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^OnCancleButtonClick)(void);
typedef void (^OnSureUpdateClick)(void);

@interface VersionUpdateAlertView : UIView

@property (nonatomic, copy) OnCancleButtonClick cancleBlock;
@property (nonatomic, copy) OnSureUpdateClick sureBlock;

- (instancetype)initWithUpdateVersionNumber:(NSString *)versionNumber versionSize:(NSString *)versionSize content:(NSString *)content verType:(NSInteger)verType confrimBolck:(nonnull void (^)(void))confrimBlock cancelBlock:(nonnull void (^)(void))cancelBlock;

@end

NS_ASSUME_NONNULL_END
