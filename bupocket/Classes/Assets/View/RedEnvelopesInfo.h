//
//  RedEnvelopesInfo.h
//  bupocket
//
//  Created by huoss on 2019/8/3.
//  Copyright © 2019 bupocket. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActivityInfoModel.h"

typedef NS_ENUM(NSInteger, RedEnvelopesType) {
    RedEnvelopesTypeDefault,
    RedEnvelopesTypeNormal,
};

typedef void (^OnCancleButtonClick)(void);
typedef void (^OnSureUpdateClick)(void);

NS_ASSUME_NONNULL_BEGIN

@interface RedEnvelopesInfo : UIView

@property (nonatomic, copy) OnCancleButtonClick cancleBlock;
@property (nonatomic, copy) OnSureUpdateClick sureBlock;

- (instancetype)initWithRedEnvelopesType:(RedEnvelopesType)redEnvelopesType confrimBolck:(void (^ _Nullable)(void))confrimBlock cancelBlock:(void (^ _Nullable)(void))cancelBlock;

@property (nonatomic, strong) ActivityInfoModel * activityInfoModel;

@end

NS_ASSUME_NONNULL_END
