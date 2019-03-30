//
//  DposAlertView.h
//  bupocket
//
//  Created by bupocket on 2019/3/27.
//  Copyright © 2019年 bupocket. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+CustomAlertView.h"
#import "ApplyNodeModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^OnCancleClick)(void);
typedef void (^OnSureClick)(void);

@interface DposAlertView : UIView

@property (nonatomic, copy) OnCancleClick cancleBlock;
@property (nonatomic, copy) OnSureClick sureBlock;
@property (nonatomic, strong) ApplyNodeModel * applyNodeModel;

- (instancetype)initWithDpos:(ApplyNodeModel *)applyNodeModel confrimBolck:(void (^)(void))confrimBlock cancelBlock:(void (^)(void))cancelBlock;

@end

NS_ASSUME_NONNULL_END
