//
//  SharingCanvassingAlertView.h
//  bupocket
//
//  Created by huoss on 2019/4/4.
//  Copyright © 2019年 bupocket. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+CustomAlertView.h"
#import "NodePlanModel.h"


NS_ASSUME_NONNULL_BEGIN

typedef void (^OnCancleClick)(void);
typedef void (^OnConfrimClick)(NSString * text);

@interface SharingCanvassingAlertView : UIView

@property (nonatomic, copy) OnCancleClick cancleClick;
@property (nonatomic, copy) OnConfrimClick confrimClick;
@property (nonatomic, strong) NodePlanModel * nodePlanModel;

- (instancetype)initWithNodePlanModel:(NodePlanModel *)nodePlanModel confrimBolck:(void (^)(NSString * text))confrimBlock cancelBlock:(void (^)(void))cancelBlock;


@end

NS_ASSUME_NONNULL_END
